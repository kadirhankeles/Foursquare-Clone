//
//  AddMapVC.swift
//  Foursquare Clone
//
//  Created by Kadirhan Keles on 10.03.2023.
//

import UIKit
import MapKit
import FirebaseStorage
import FirebaseFirestore
class AddMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var chosenLatitude = ""
    var chosenLongitude = ""
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(saveButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer: )))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
        
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            self .mapView.addAnnotation(annotation)
            
            self.chosenLatitude = String(coordinates.latitude)
            self.chosenLongitude = String(coordinates.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    @objc func saveButtonClicked() {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        //media klasörü oluştur.
        let mediaFolder = storageReference.child("media")
        if let data = PlaceModel.sharedInstance.placeImage.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child(uuid)
            imageReference.putData(data) { (metadata, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "Error")
                }else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            //database
                            let db = Firestore.firestore()
                            var dbReference : DocumentReference? = nil
                            
                            let dbPost = [
                                "imageUrl": imageUrl!,
                                "placeName": PlaceModel.sharedInstance.placeName,
                                "placeType": PlaceModel.sharedInstance.placeType,
                                "latitude": self.chosenLatitude,
                                "longitude": self.chosenLongitude,
                                "date": FieldValue.serverTimestamp(),
                            ] as [String : Any]
                            
                            dbReference = db.collection("Posts").addDocument(data: dbPost, completion: { (error) in
                                if error != nil {
                                    print(error?.localizedDescription ?? "Error")
                                }else {
                                    self.performSegue(withIdentifier: "toListVC", sender: nil)
                                }
                            })
                            
                        }
                    }
                }
            }
        }
    }
    
    @objc func backButtonClicked() {
        self.dismiss(animated: true)
    }

    

}
