//
//  AddPlaceVC.swift
//  Foursquare Clone
//
//  Created by Kadirhan Keles on 10.03.2023.
//

import UIKit

class AddPlaceVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var addType: UITextField!
    @IBOutlet weak var addName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        addImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func imageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        addImage.image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true)
    }

  
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if addName.text != "" && addType.text != "" {
            if let chosenImage = addImage.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = addName.text!
                placeModel.placeType = addType.text!
                placeModel.placeImage = chosenImage
            }
            self.performSegue(withIdentifier: "toMapVC", sender: nil)
        }else {
            let alert = UIAlertController(title: "Error", message: "Please enter Name/Type", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
        
        
    }
    
}
