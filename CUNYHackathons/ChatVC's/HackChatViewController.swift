//
//  HackChatViewController.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 12/12/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit

//this struct holds chat data
struct ChatData
{
    public var senderID:String
    public var senderName:String
    public var text:String
}
//this struct holds the incomplete group data
struct GroupIncData
{
    public var groupName:String
    public var memberNum:Int
    public var missingMemberList:[String]
    public var hackathonName:String
}

//this struct holds the group data
struct GroupData
{
    public var groupName:String
    public var memberNum:Int
    public var chatList:[ChatData]
    public var hackathonName:String
}

//this is the class for the incomplete group tableview cell
class HackChatCell1: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource
{
    //outlets
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hackNameLabel: UILabel!
    
    //vars
    public var parentVC: HackChatViewController? = nil
    public var lookingForList: [String] = []
    
    //initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    //UICollectionViewDelegate functions
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return lookingForList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? ChatCollectionCell
        
        cell?.lookingForLabel.text = lookingForList[indexPath.row]
    
        return cell!
    }
    
    //handle selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        parentVC?.selectedGroup   = self.chatNameLabel.text
        parentVC?.selectedRequest = self.lookingForList[indexPath.row]
        parentVC?.performSegue(withIdentifier: "openRequest", sender: parentVC)
    }
    
    func setDelegate()
    {
        collectionView.delegate   = self
        collectionView.dataSource = self
    }
}

//this is the class for the complete group tableview cell
class HackChatCell2: UITableViewCell
{
    //outlets
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var hackNameLabel: UILabel!
    
    //vars
    public var chatList:[ChatData] = []
}

//this is the class for the collectionview cell
class ChatCollectionCell: UICollectionViewCell
{
    @IBOutlet weak var lookingForLabel: UILabel!
}

/*
 * This VC is the landing screen for the chats
 */
class HackChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    //vars
    public var groupIncList: [GroupIncData] = []
    public var groupList: [GroupData]       = []
    public var selectedRequest: String?     = nil
    public var selectedGroup: String?       = nil
    public var selectedChat: GroupData?     = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return groupIncList.count
        }
        return groupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //depending on what section you are in, the cells are different
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inc") as? HackChatCell1
            
            cell?.setDelegate()
            cell?.parentVC = self
            cell?.chatNameLabel.text = groupIncList[indexPath.row].groupName
            cell?.memberLabel.text   = "Members: \(groupIncList[indexPath.row].memberNum)"
            cell?.lookingForList     = groupIncList[indexPath.row].missingMemberList
            cell?.hackNameLabel.text = groupIncList[indexPath.row].hackathonName
            
            return cell!
        }
        if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "done") as? HackChatCell2
            cell?.chatList           = groupList[indexPath.row].chatList
            cell?.chatNameLabel.text = groupList[indexPath.row].groupName
            cell?.memberLabel.text   = "Members: \(groupList[indexPath.row].memberNum)"
            cell?.hackNameLabel.text = groupList[indexPath.row].hackathonName
            
            return cell!
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 200.0
        }
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 0
        {
            cell?.selectionStyle = .none
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 1
        {
            self.selectedChat = groupList[indexPath.row]
            self.performSegue(withIdentifier: "openChat", sender: self)
        }
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 0
        {
            return "Groups Available"
        }
        if section == 1
        {
            return "Your Groups"
        }
        return "Nothing"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate   = self
        tableView.dataSource = self
        
        groupIncList.append(GroupIncData(groupName: "Best Group!", memberNum: 5, missingMemberList: ["looking for a UI guy","looking for a backend guy","looking for anyone", "looking for you"], hackathonName: "CUNY Hackathon"))
        groupIncList.append(GroupIncData(groupName: "My group 2", memberNum: 3, missingMemberList: ["looking for One more guy"], hackathonName: "CUNY Hackathon"))
        
        groupList.append(GroupData(groupName: "Coolest Group", memberNum: 5, chatList: [], hackathonName: "CUNY Hackathon"))
        groupList.append(GroupData(groupName: "Best Group", memberNum: 25, chatList: [], hackathonName: "CUNY Hackathon"))
    }
    
    //pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "openRequest"
        {
            if let navVC = segue.destination as? UINavigationController
            {
                if let nextVC = navVC.viewControllers.first as? SendRequestViewController
                {
                    nextVC.groupName    = self.selectedGroup
                    nextVC.positionName = self.selectedRequest
                }
            }
        }
        
        if segue.identifier == "openChat"
        {
            if let navVC = segue.destination as? UINavigationController
            {
                if let nextVC = navVC.viewControllers.first as? ChatViewController
                {
                    nextVC.currentChat = self.selectedChat
                    nextVC.title       = self.selectedChat?.groupName
                }
            }
        }
    }
    
    //actions
    @IBAction func addGroupPressed(_ sender: Any)
    {
        self.performSegue(withIdentifier: "newGroup", sender: self)
    }
    
    
}
