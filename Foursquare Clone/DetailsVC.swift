//
//  DetailsVC.swift
//  Foursquare Clone
//
//  Created by Kadirhan Keles on 10.03.2023.
//

import UIKit
import MapKit
import SDWebImage
class DetailsVC: UIViewController {
    
    var chosenID = ""
    var chosenImage = ""
    var chosenLong = ""
    var chosenLati = ""
    var chosenName = ""
    var chosenType = ""
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var typeText: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.text = chosenName
        typeText.text = chosenType
        imageView.sd_setImage(with: URL(string: chosenImage))
        
        getMap()
    }
    
    func getMap() {
        let location = CLLocationCoordinate2D(latitude: Double(self.chosenLati)!, longitude:
        Double(self .chosenLong)!)

        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: location, span: span)

        self.mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = chosenName
        annotation.subtitle = chosenType
        self.mapView.addAnnotation(annotation)
        
    }
    

}
