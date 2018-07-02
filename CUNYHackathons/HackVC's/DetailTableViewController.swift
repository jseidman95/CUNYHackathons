//
//  DetailTableViewController.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 12/11/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit
import SDWebImage

/*
 * This VC is presented when the user clicks on a hackathon to see it's data
 */
class DetailTableViewController: UITableViewController
{
    //vars
    public var hackathon:HackathonData? = nil

    //outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateStartPicker: UIDatePicker!
    @IBOutlet weak var dateEndPicker: UIDatePicker!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var prizeTextField: UITextField!
    
    //automatically generated functions
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //process the given hackathon
        if let hackathon = self.hackathon
        {
            //if there is a start date
            if let startDate = hackathon.startDate
            {
                //if there is a hasTime value
                if let hasTime = hackathon.hasTime
                {
                    //set the mode of the date picker based on the hasTime bool
                    if !hasTime
                    {
                            dateStartPicker.datePickerMode = .date
                    }
                    dateStartPicker.date = startDate
                }
            }
            //if there is a end date
            if let endDate = hackathon.endDate
            {
                if let hasTime = hackathon.hasTime
                {
                    if !hasTime
                    {
                        dateEndPicker.datePickerMode = .date
                    }
                    dateEndPicker.date = endDate
                }
            }
            
            //get image
            if let image     = hackathon.hackathonImage { imageView.image = image}
            if let imageLink = hackathon.imageLink { imageView.sd_setImage(with: URL(string: imageLink), completed: nil)}

            //set text fields
            nameTextField.text        = hackathon.name
            descriptionTextField.text = hackathon.description
            cityTextField.text        = hackathon.city
            stateTextField.text       = hackathon.state
            infoTextField.text        = hackathon.info
            linkTextField.text        = hackathon.link
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //dynamically "remove" tableview cells if there is no data for them
        if indexPath.section == 0 && indexPath.row == 0 { if nameTextField.text        == ""  { return 0 }}
        if indexPath.section == 0 && indexPath.row == 1 { if descriptionTextField.text == ""  { return 0 }}
        if indexPath.section == 1 && indexPath.row == 0 { if hackathon?.startDate      == nil { return 0 }}
        if indexPath.section == 1 && indexPath.row == 1 { if hackathon?.endDate        == nil { return 0 }}
        if indexPath.section == 1 && indexPath.row == 2 { if stateTextField.text       == ""  { return 0 }}
        if indexPath.section == 2 && indexPath.row == 0 { if infoTextField.text        == ""  { return 0 }}
        if indexPath.section == 2 && indexPath.row == 1 { if linkTextField.text        == ""  { return 0 }}
        if indexPath.section == 2 && indexPath.row == 2 { if prizeTextField.text       == ""  { return 0 }}
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    //handle selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 2 && indexPath.row == 1
        {
            self.performSegue(withIdentifier: "showWeb", sender: self)
        }
    }
    
    //get rid of selection highlight
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        if indexPath.section != 2 && indexPath.row != 1
        {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.selectionStyle = .none
        }
        return indexPath
    }
    
    //pass data and perform segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showWeb"
        {
            if let nextVC = segue.destination as? WebViewController
            {
                nextVC.urlString = linkTextField.text!
            }
        }
    }
    
    //actions
    @IBAction func backtion(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
