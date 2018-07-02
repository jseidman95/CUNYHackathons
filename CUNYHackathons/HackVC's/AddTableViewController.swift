//
//  AddTableViewController.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 12/6/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit
import WebKit

/*
 * This is the VC that allows for the admin to add a new hackathon from scratch
 */
class AddTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var imageTapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var startDP: UIDatePicker!
    @IBOutlet weak var endDP: UIDatePicker!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var prizeTextField: UITextField!
    
    //vars
    let imagePicker = UIImagePickerController()
    
    //automatically generated functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
        imageView.isUserInteractionEnabled = true
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        //we make the assumtion for now that we will have at least one data field for each section
        //THIS COULD CHANGE IN THE FUTURE
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 { return 2 }
        return 3
    }

    //actions
    @IBAction func cancelAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addHackathon(_ sender: Any)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        var response = [String:Any]()
        
        if imageView.image! != #imageLiteral(resourceName: "noPic")
        {
            var argsDict = [String:String]()
            if nameTextField.text!  != "" {argsDict["name"] = nameTextField.text!}
            else {argsDict["name"] = "NULL"}
            if descTextField.text!  != "" {argsDict["description"] = descTextField.text!}
            else {argsDict["description"] = "NULL"}
            if prizeTextField.text! != "" {argsDict["prize"] = prizeTextField.text!}
            else {argsDict["prize"] = "NULL"}
            if cityTextField.text!  != "" {argsDict["city"] = cityTextField.text!}
            else {argsDict["city"] = "NULL"}
            if stateTextField.text! != "" {argsDict["state"] = stateTextField.text!}
            else {argsDict["state"] = "NULL"}
            argsDict["startDate"] = dateFormatter.string(from: startDP.date)
            argsDict["endDate"] = dateFormatter.string(from: endDP.date)
            if infoTextField.text! != "" {argsDict["info"] = infoTextField.text!}
            else {argsDict["info"] = "NULL"}
            if linkTextField.text!  != "" {argsDict["link"] = linkTextField.text!}
            else {argsDict["link"] = "NULL"}
            argsDict["imageLink"] = "NULL"
            
            response = DatabaseLoader.uploadImage(link: "http://gorrick.tech/antfiles/hackathon_op/addhackathon.php", argsDict: argsDict, hackImage: imageView.image!)
        }
        else
        {
            var argsArray = [String]()
            if nameTextField.text! != "" {argsArray.append("name=\(nameTextField.text!)")}
            else {argsArray.append("name=NULL")}
            if descTextField.text! != "" {argsArray.append("description=\(descTextField.text!)")}
            else {argsArray.append("description=NULL")}
            if prizeTextField.text! != "" {argsArray.append("prize=\(prizeTextField.text!)")}
            else {argsArray.append("prize=NULL")}
            if cityTextField.text! != "" {argsArray.append("city=\(cityTextField.text!)")}
            else {argsArray.append("city=NULL")}
            if stateTextField.text! != "" {argsArray.append("state=\(stateTextField.text!)")}
            else {argsArray.append("state=NULL")}
            argsArray.append("startDate=\(dateFormatter.string(from: startDP.date))")
            argsArray.append("endDate=\(dateFormatter.string(from: endDP.date))")
            argsArray.append("hasTime=\(true)")
            if infoTextField.text! != "" {argsArray.append("info=\(infoTextField.text!)")}
            else {argsArray.append("info=NULL")}
            if linkTextField.text! != "" {argsArray.append("link=\(linkTextField.text!)")}
            else {argsArray.append("link=NULL")}
            argsArray.append("imageLink=NULL")
            response = DatabaseLoader.getJSONArray(requestType: "POST", link: "http://gorrick.tech/antfiles/hackathon_op/addhackathon.php",argsArray: argsArray)
        }
        if response["success"] == nil
        {
            var message = ""
            for (key,value) in response { message = value as! String }
            
            // create the alert
            let alert = UIAlertController(title: "Add Hackathon Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            // create the alert
            let alert = UIAlertController(title: "Add Hackathon Success", message: "Hackathon Added", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                _ in
                self.dismiss(animated: true, completion: nil)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //the function that presents the image picker
    @IBAction func touchedImage(_ sender: Any)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Functions from UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageView.contentMode = .scaleToFill
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
}
