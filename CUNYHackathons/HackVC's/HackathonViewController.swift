//
//  HackathonViewController.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 11/29/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit
import BEMCheckBox

//this struct holds all the data required for storing hackathon information (all optional due to potentially missing values during scraping)
struct HackathonData
{
    public var name:String?
    public var description:String?
    public var prizeText:String?
    public var city:String?
    public var state:String?
    public var startDate:Date?
    public var endDate:Date?
    public var info:String?
    public var link:String?
    public var imageLink:String?
    public var hackathonImage:UIImage?
    public var hasTime:Bool?
}

/*
 * This class is the cell that is used in collection view
 */
class HackathonViewCell:UICollectionViewCell
{
    @IBOutlet weak var hackathonImageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var hackLabel: UILabel!
    @IBOutlet weak var hackNameView: UIView!
    @IBOutlet weak var hackNameLabel: UILabel!
}

/*
 * This view controller is the landing screen for viewing the hackathons.  It is the same screen for the users
 * and the admins (with minor differences).
 */
class HackathonViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //vars
    public var hackathonDataList = [HackathonData]()
    public var isAdmin = true //the value that tells the controller if an admin is viewing it or not
    public var selectedHackathon:HackathonData? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //set delegates
        collectionView.dataSource = self
        collectionView.delegate   = self

        //if the user is not an admin, hide the add button (the user is not privy to this kind of access)
        if !isAdmin
        {
            addButton.title = ""
            addButton.isEnabled = false
        }
        
        //make the layout for the collection view
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
  
        getHackathonData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        getHackathonData()
    }
    
    func getHackathonData()
    {
        self.hackathonDataList = DatabaseLoader.getHackathonDataList(requestType: "POST", link: "http://gorrick.tech/antfiles/hackathon_op/retrievehackathon.php", argsArray: [])
        self.sortHackathonList()
        self.collectionView.reloadData()
    }
    
    //UICollectionViewDataSource functions
    //set number of sections to be 1
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    //set number of items to be equal to the number of items in the data list
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return hackathonDataList.count
    }
    
    //make cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //get cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? HackathonViewCell
        
        //set the name for the hackathon
        if let name = hackathonDataList[indexPath.row].name
        {
            cell?.hackNameLabel.text = name
        }
        else
        {
            cell?.hackNameLabel.text = ""
        }
        
        //check if an image was not given
        if hackathonDataList[indexPath.row].hackathonImage ==  nil
        {
            //if an image link was given set the image link to the imageview
            if let imageLink = hackathonDataList[indexPath.row].imageLink
            {
                cell?.hackathonImageView.sd_setImage(with: URL(string:imageLink), completed: nil)
            }
            //if no image was given, give the hackathon the default image
            else
            {
                cell?.hackathonImageView.image = #imageLiteral(resourceName: "newNoPic")
            }
            
        }
        //if an image was given, set it
        else
        {
            cell?.hackathonImageView.image = hackathonDataList[indexPath.row].hackathonImage
        }
        
        //if state and city are not nil
        if let city = hackathonDataList[indexPath.row].city, let state = hackathonDataList[indexPath.row].state
        {
            cell?.colorView.backgroundColor = StateEnum.getStateValue(stateString: state)?.color
            cell?.hackLabel.text = "\(city), \(state)"
        }
        //if only state is non-nil
        else if let state = hackathonDataList[indexPath.row].state
        {
            cell?.colorView.backgroundColor = StateEnum.getStateValue(stateString: state)?.color
            cell?.hackLabel.text = "\(state)"
        }
        //in all other cases...
        else
        {
            cell?.colorView.backgroundColor = StateEnum.getStateValue(stateString: "Unknown")?.color
            
            if let prizeText = hackathonDataList[indexPath.row].prizeText
            {
                cell?.hackLabel.text = prizeText
            }
            else
            {
                cell?.hackLabel.text = "Hackathon"
            }
        }
        
        //make text smaller if necessery
        cell?.hackLabel.sizeToFit()
        if let width = cell?.hackLabel.frame.width, let height =  cell?.colorView.frame.height
        {
            var newWidth = width
            while (newWidth + 20.0 > height) //40.0 is the buffer zone
            {
                cell?.hackLabel.font = cell?.hackLabel.font.withSize((cell?.hackLabel.font.pointSize)! - 1.0)
                cell?.hackLabel.sizeToFit()
                newWidth = (cell?.hackLabel.frame.width)!
            }
        }
        
        cell?.hackLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2) //rotate label
        cell?.layer.borderWidth   = 1.0                                            //set border width
        cell?.layer.borderColor   = UIColor.gray.cgColor                           //set border color
        
        return cell!
    }
    
    //handle selection of cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.selectedHackathon = hackathonDataList[indexPath.row]
        self.performSegue(withIdentifier: "detailSegue1", sender: self) //go to detail page
    }
    
    //UICollectionViewDelegateFlowLayout functions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width, height: 175)
    }
    
    //public functions
    //This function sorts the hackathon list, sorted by state enum raw value
    public func sortHackathonList()
    {
        self.hackathonDataList.sort(by: {
            
            if $0.state == nil {return false}
            if $1.state == nil {return true}
            
            if let state1 = $0.state, let state2 = $1.state
            {
                return StateEnum.getStateValue(stateString: state1)!.rawValue < StateEnum.getStateValue(stateString: state2)!.rawValue
            }
            
            return false
        })
    }
    
    //prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //if the detail view controller is being shown, pass the selected hackathon to the next VC
        if segue.identifier == "detailSegue1"
        {
            //first get the navigation controller
            if let navVC = segue.destination as? UINavigationController
            {
                //then get the actual VC
                if let nextVC = navVC.viewControllers.first as? DetailTableViewController
                {
                    nextVC.hackathon = self.selectedHackathon
                }
            }
        }
    }
}
