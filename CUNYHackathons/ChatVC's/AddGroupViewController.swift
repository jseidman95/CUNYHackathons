//
//  AddGroupViewController.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 12/12/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit

//This class is the cell for hackathon list
class HackListCell: UITableViewCell
{
    @IBOutlet weak var hackNameLabel: UILabel!
}

//this class is the cell for the member request list
class MemberListCell: UITableViewCell
{
    @IBOutlet weak var memberLabel: UILabel!
}

/*
 * This VC contains the necassery elements to add a new group
 */
class AddGroupViewController: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    public var hackathonData:[HackathonData] = []
    public var lookingForList:[String] = []
    
    @IBOutlet weak var hackathonTV: UITableView!
    @IBOutlet weak var lookingForTV: UITableView!
    @IBOutlet weak var nameTF: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hackathonTV.delegate    = self
        lookingForTV.delegate   = self
        hackathonTV.dataSource  = self
        lookingForTV.dataSource = self
        
        self.hackathonData = DatabaseLoader.getHackathonDataList(requestType: "POST", link: "http://gorrick.tech/antfiles/hackathon_op/retrievehackathon.php", argsArray: [])
    }
    
    //UITableViewDelegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == hackathonTV
        {
            return hackathonData.count
        }
        return lookingForList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //the cells are different for the different tables
        if tableView == hackathonTV
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "hackCell") as? HackListCell
            cell?.hackNameLabel.text = hackathonData[indexPath.row].name
            
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "lookCell") as? MemberListCell
        cell?.memberLabel.text = lookingForList[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == lookingForTV { return true }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete && tableView == lookingForTV)
        {
            // handle delete (by removing the data from your array and updating the tableview)
            self.lookingForList.remove(at: indexPath.row)
            self.lookingForTV.reloadData()
        }
    }
    

    //actions
    @IBAction func addLookFor(_ sender: Any)
    {
        let alert = UIAlertController(title: "Add Member Request", message: "Enter text", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Add Member Description"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if textField?.text != ""
            {
                self.lookingForList.append((textField?.text!)!)
            }
            self.lookingForTV.reloadData()
            
            self.lookingForTV.scrollToRow(at: IndexPath(row: self.lookingForList.count-1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAction(_ sender: Any)
    {
        print(hackathonTV.indexPathForSelectedRow)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if self.nameTF.isFirstResponder
        {
            self.nameTF.resignFirstResponder()
        }
    }
}
