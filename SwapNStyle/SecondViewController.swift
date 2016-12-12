//
//  SecondViewController.swift
//  SwapNStyle
//
//  Created by Evan Elkin on 11/27/16.
//  Copyright © 2016 Evan Elkin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var pickerData: [String] = [String]()
    // for simulator presentation only
    let defaultShirts: [UIImage] = [#imageLiteral(resourceName: "shirt"), #imageLiteral(resourceName: "shirt2"), #imageLiteral(resourceName: "shirt3"), #imageLiteral(resourceName: "shirt4")]
    let defaultPants: [UIImage] = [#imageLiteral(resourceName: "pants"), #imageLiteral(resourceName: "pants2"), #imageLiteral(resourceName: "pants3"), #imageLiteral(resourceName: "pants4")]
    let defaultShoes: [UIImage] = [#imageLiteral(resourceName: "shoes"), #imageLiteral(resourceName: "shoes2"), #imageLiteral(resourceName: "shoes3"), #imageLiteral(resourceName: "shoes4")]
    
    //clothing item is created
    var clothingItem: Item = Item(id: 1, itemType: "Shirt", itemPicture: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connection to picker
        self.picker.delegate = self
        self.picker.dataSource = self
        
        pickerData = ["Shirt", "Pants", "Shoes"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Picker
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        clothingItem.itemType = pickerData[row]
    }
    
    // MARK: Finding image
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // source: https://makeapppie.com/2016/06/28/how-to-use-uiimagepickercontroller-for-a-camera-and-photo-library-in-swift-3-0/
    @IBAction func takePhotoForImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.delegate = self
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.modalPresentationStyle = .fullScreen
            
            present(imagePickerController,animated: true,completion: nil)
        } else {
            
            // default photo
            let rand = Int(arc4random_uniform(4) + 1)
            
            if clothingItem.itemType == "Shirt" {
                photoImageView.image = defaultShirts[rand]
            } else if clothingItem.itemType == "Pants" {
                photoImageView.image = defaultPants[rand]
            } else {
                photoImageView.image = defaultShoes[rand]
            }
            
            noCamera()
        }
    }
    // source: https://makeapppie.com/2016/06/28/how-to-use-uiimagepickercontroller-for-a-camera-and-photo-library-in-swift-3-0/
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    // MARK: Adding Image to database
    @IBAction func addItemToVCImageView(_ sender: UIButton) {

        // sets the name of the clothing item picture
        // lots of lines due to formatting out punc + spaces
        clothingItem.itemPicture = "\(Date()).png"
        clothingItem.itemPicture = clothingItem.itemPicture.replacingOccurrences(of: "-", with: " ")
        clothingItem.itemPicture = clothingItem.itemPicture.replacingOccurrences(of: ":", with: " ")
        clothingItem.itemPicture = clothingItem.itemPicture.replacingOccurrences(of: "+", with: " ")
        clothingItem.itemPicture = clothingItem.itemPicture.replacingOccurrences(of: " ", with: "")
        
        // USE FOR SAVING IMAGE
        // get a path to the Documents directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths.first
        
        // take the image from the image view and save to a file with name of the clothing item picture
        if let image = photoImageView.image {
            if let data = UIImagePNGRepresentation(image) {
                let fileName = documentsDirectory?.appendingPathComponent("\(clothingItem.itemPicture)")
                try? data.write(to: fileName!)
            }
        }
        
        //adding to database
        if let id = ItemDB.instance.add(item: clothingItem) {
            clothingItem.id = id
            print("added to database")
        }
        
        //goes back to first page of app
        navigationController?.popViewController(animated: true)
    }
    
}
