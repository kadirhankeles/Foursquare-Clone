//
//  PlacesVC.swift
//  Foursquare Clone
//
//  Created by Kadirhan Keles on 10.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var placeId = [String]()
    var placeNameArray = [String]()
    var placeTypeArray = [String]()
    var placeImageArray = [String]()
    var placeLongArray = [String]()
    var placeLatiArray = [String]()
    var selectedId = ""
    var selectedImage = ""
    var selectedLong = ""
    var selectedLati = ""
    var selectedName = ""
    var selectedType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.black
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor.black
        getDataFromFirebase()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 1.00, green: 0.82, blue: 0.29, alpha: 1.00)
        
    }
   
    
    
    @objc func logoutButtonClicked() {
        do {
               try Auth.auth().signOut()
                   self.performSegue(withIdentifier: "toViewController", sender: nil)
               }catch {
                   print("error")
               }
    }

    @objc func addButtonClicked() {
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear
        var content = cell.defaultContentConfiguration()
        content.text=placeNameArray[indexPath.row]
        content.secondaryText = placeTypeArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedId = placeId[indexPath.row]
        selectedImage = placeImageArray[indexPath.row]
        selectedLati = placeLatiArray[indexPath.row]
        selectedLong = placeLongArray[indexPath.row]
        selectedName = placeNameArray[indexPath.row]
        selectedType = placeTypeArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            if let destinationVC = segue.destination as? DetailsVC {
                destinationVC.chosenID = selectedId
                destinationVC.chosenImage = selectedImage
                destinationVC.chosenLati = selectedLati
                destinationVC.chosenLong = selectedLong
                destinationVC.chosenName = selectedName
                destinationVC.chosenType = selectedType
            }
        }
    }
    
    func getDataFromFirebase(){
        let db = Firestore.firestore()
        db.collection("Posts").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.placeTypeArray.removeAll(keepingCapacity: false)
                    self.placeId.removeAll(keepingCapacity: false)
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeLongArray.removeAll(keepingCapacity: false)
                    self.placeLatiArray.removeAll(keepingCapacity: false)
                    self.placeImageArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        if let docID = document.documentID as? String{
                            self.placeId.append(docID)
                            print(docID)
                        }
                        if let placeName = document.get("placeName") as? String {
                            self.placeNameArray.append(placeName)
                        }
                        if let placeType = document.get("placeType") as? String {
                            self.placeTypeArray.append(placeType)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.placeImageArray.append(imageUrl)
                        }
                        if let lati = document.get("latitude") as? String {
                            self.placeLatiArray.append(lati)
                        }
                        if let long = document.get("longitude") as? String {
                            self .placeLongArray.append(long)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}
