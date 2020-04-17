//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Константин Сабицкий on 08.04.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import UIKit
import Cosmos

class NewPlaceViewController: UITableViewController {
    
    //MARK: PROPERTIES
    var currentPlace: Place!
    var imageIsChanged = false
    var currentRating = 0.0
    
    //MARK: OUTLETS
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var ratingControl: RaitingControl!
    @IBOutlet weak var cosmosView: CosmosView!
    
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        setupEditScreen()
        //cosmosView.fillmode = .half/.precise - это более точное выставление рейтинга
        cosmosView.didTouchCosmos = { rating in
        self.currentRating = rating
        }
    }
    
    //MARK: TABLEVIEW DELEGATE
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
                let cameraIcon = #imageLiteral(resourceName: "camera")
                let photoIcon = #imageLiteral(resourceName: "photo")
                let actionSheet = UIAlertController(title: nil,
                                                    message: nil,
                                                    preferredStyle: .actionSheet)
                let camera = UIAlertAction(title: "Camera",
                                           style: .default){_ in
                self.chooseImagePicker(source: .camera)
                }
            
                camera.setValue(cameraIcon, forKey: "image")
                camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

                let photo = UIAlertAction(title: "Photo",
                                          style: .default){_ in
                self.chooseImagePicker(source: .photoLibrary)
                }

                photo.setValue(photoIcon, forKey: "image")
                photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
                let cancel = UIAlertAction(title: "Cancel",
                                           style: .cancel)

                actionSheet.addAction(camera)
                actionSheet.addAction(photo)
                actionSheet.addAction(cancel)

                present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }

    //MARK: NAVIGATION
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            guard let identifier = segue.identifier,
              let mapVC = segue.destination as? MapViewController
              else {return}
        
            mapVC.incomeSegueIndentifier = identifier
            mapVC.mapVCDelegate = self
            if identifier == "showPlace" {
                mapVC.place.name = placeName.text!
                mapVC.place.location = placeLocation.text
                mapVC.place.type = placeType.text
                mapVC.place.imageData = placeImage.image?.pngData()
            }
        }
    
    
    
    func savePlace() {
        
        let image = imageIsChanged ? placeImage.image : #imageLiteral(resourceName: "imagePlaceholder")
        let imageData = image?.pngData()
        
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData,
                             rating: currentRating )
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
                
            } else {
                StorageManager.saveObject(newPlace)
            }
        }
        

    private func setupEditScreen() {
        if currentPlace != nil {
            setupNavBar()
            imageIsChanged = true
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else {return}
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            cosmosView.rating = currentPlace.rating
        }
    }
    
    private func setupNavBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

    //MARK: EXTENSION - TEXTFIELD DELEGATE
    extension NewPlaceViewController: UITextFieldDelegate {


        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        }

        
        @objc private func textFieldChanged() {
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
            } else {
            saveButton.isEnabled = false
            }
        }

}

    //MARK: EXTENSION - WORK WITH IMAGE
    extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func chooseImagePicker(source: UIImagePickerController.SourceType) {

        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)

        }
    }


        func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        imageIsChanged = true



        dismiss(animated: true, completion: nil)

    }
}

extension NewPlaceViewController: MapViewControllerDelegate {
    
    func getAddress(_ address: String?) {
        placeLocation.text = address
    }
    
    
}
