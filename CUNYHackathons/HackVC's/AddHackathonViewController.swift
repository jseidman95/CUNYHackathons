//
//  AddHackathonViewController.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 11/30/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit
import Kanna
import Alamofire
import SDWebImage
import BEMCheckBox

/*
 * This is the class for the cell that will be used in the collectionview.  It also includes a
 * caching mechanism so the proper checkboxes are selected when cells are dequeued
 */
class AddHackathonViewCell:UICollectionViewCell
{
    //outlets
    @IBOutlet weak var hackImageView: UIImageView!
    @IBOutlet weak var hackLabel: UILabel!
    @IBOutlet weak var hackLabelView: UIView!
    @IBOutlet weak var checkBoxView: UIView!
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var hackNameView: UIView!
    @IBOutlet weak var hackNameLabel: UILabel!
    
    //vars
    var parentController:AddHackathonViewController? = nil
    
    //caching mechanism
    static var selectedCellArray:[String] = []
    @IBAction func checkBoxChanged(_ sender: Any)
    {
        //if the checkbox has been turned on, add the hackathon to the selected array
        if checkBox.on
        {
            //The reason the name is used is because of the potential dequeue error
            AddHackathonViewCell.selectedCellArray.append(hackNameLabel.text!)
            
            //change the button to add once a cell has been selected
            if let p = parentController
            {
                p.rightButtonItem.title = "Add"
            }
        }
        //if the checkbox has been turned off, remove the hackathon from the selected array
        else
        {
            AddHackathonViewCell.selectedCellArray = AddHackathonViewCell.selectedCellArray.filter({ $0 != hackNameLabel.text!})
            
            //if no cells are selected,change button back
            if let p = parentController, AddHackathonViewCell.selectedCellArray == []
            {
                p.rightButtonItem.title = "Create"
            }
        }
    }
}

/*
 * This view controller allows an admin to browse through scraped hackathon data and choose hackathons to
 * add to the list for CUNY Students OR the admin can create a hackathon from scratch and add it to the list
 */
class AddHackathonViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    //outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rightButtonItem: UIBarButtonItem!
    
    //vars
    public var hackathonDataList = [HackathonData]()
    public var dbHackathonDataList = [HackathonData]()
    public var selectedHackathon:HackathonData? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //set delegates
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        //set flow layout for the collection view
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
        self.dbHackathonDataList = DatabaseLoader.getHackathonDataList(requestType: "POST", link: "http://gorrick.tech/antfiles/hackathon_op/retrievehackathon.php", argsArray: [])
        //scrape the data and add it to the hackathon data list
        self.scrapeData(URLString: "https://mlh.io/seasons/na-2018/events", label: "MLH")
        self.parseHL(startURL: "http://www.hackalist.org/api/1.0/", yearString: "2017", monthString: "11", endURL: ".json")
        self.scrapeData(URLString: "https://nyhackathons.com/", label: "NYH")
    }
    
    //UICollectionViewDataSource functions
    //return the number of sections to be 1
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    
    //return the datalist count as the number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return hackathonDataList.count
    }
    
    //create the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? AddHackathonViewCell
        
        //set the color for checkbox
        cell?.checkBox.onCheckColor = UIColor.white
        cell?.checkBox.onTintColor = UIColor.white
        
        //set the name
        if let name = hackathonDataList[indexPath.row].name
        {
            cell?.hackNameLabel.text = name
        }
        
        //set the color based on the state value
        if let state = hackathonDataList[indexPath.row].state
        {
            if let city = hackathonDataList[indexPath.row].city
            {
                cell?.hackLabel.text = "\(city), \(state)"
            }
            else
            {
                cell?.hackLabel.text  = "\(state)"
            }
            cell?.checkBoxView.backgroundColor  = StateEnum.getStateValue(stateString: state)?.color
            cell?.hackLabelView.backgroundColor = StateEnum.getStateValue(stateString: state)?.color
        }
        
        //rotate label
        cell?.hackLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)

        //make text smaller if necessery
        cell?.hackLabel.sizeToFit()
        if let width = cell?.hackLabel.intrinsicContentSize.width, let height = cell?.hackLabelView.frame.height
        {
            var newWidth = width
            while (newWidth + 20.0 > height) //40.0 is the buffer zone
            {
                cell?.hackLabel.font = cell?.hackLabel.font.withSize((cell?.hackLabel.font.pointSize)! - 1.0)
                cell?.hackLabel.sizeToFit()
                newWidth = (cell?.hackLabel.intrinsicContentSize.width)!
            }
        }
        
        //set the image
        if let image = hackathonDataList[indexPath.row].hackathonImage
        {
            cell?.hackImageView.image = image
        }
        else
        {
            if let imageLink = hackathonDataList[indexPath.row].imageLink
            {
                cell?.hackImageView.sd_setImage(with: URL(string: imageLink), completed: nil)
            }
            else
            {
                cell?.hackImageView.image = #imageLiteral(resourceName: "newNoPic")
            }
        }

        //set cell border
        cell?.layer.borderWidth = 1.0
        cell?.layer.borderColor = UIColor.gray.cgColor
        
        //make sure selection is correct
        cell?.parentController = self
        if AddHackathonViewCell.selectedCellArray.contains((cell?.hackNameLabel.text)!)
        {
            cell?.checkBox.setOn(true, animated: false)
        }
        else
        {
            cell?.checkBox.setOn(false, animated: false)
        }

        return cell!
    }
    
    //all cells should be height 175
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.width, height: 175)
    }
    
    //handle selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.selectedHackathon = hackathonDataList[indexPath.row]
        self.performSegue(withIdentifier: "detailSegue2", sender: self)
    }
    
    //handle segues and pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //if the user is is going to the details, send selected hackathon
        if segue.identifier == "detailSegue2"
        {
            if let navVC = segue.destination as? UINavigationController
            {
                if let nextVC = navVC.viewControllers.first as? DetailTableViewController
                {
                    nextVC.hackathon = self.selectedHackathon
                }
            }
        }
    }
    
    //actions
    @IBAction func cancelButtonAction(_ sender: Any)
    {
        //clear the selected cell array so the selected cells are not saved
        AddHackathonViewCell.selectedCellArray = []
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAddButton(_ sender: Any)
    {
        if rightButtonItem.title == "Create"
        {
            self.performSegue(withIdentifier: "createSegue", sender: self)
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            for name in AddHackathonViewCell.selectedCellArray
            {
                for value in self.hackathonDataList
                {
                    if value.name == name
                    {
                        var startDate:String = ""
                        var endDate:String = ""
                        
                        if let start = value.startDate
                        {
                            startDate = dateFormatter.string(from: start)
                        }
                        if let end = value.endDate
                        {
                            endDate = dateFormatter.string(from: end)
                        }
                        
                        var argsArray = [String]()
                        if value.name != nil {argsArray.append("name=\(value.name!)")}
                        else {argsArray.append("name=NULL")}
                        if value.description != nil {argsArray.append("description=\(value.description!)")}
                        else {argsArray.append("description=NULL")}
                        if value.prizeText != nil {argsArray.append("prize=\(value.prizeText!)")}
                        else {argsArray.append("prize=NULL")}
                        if value.city != nil {argsArray.append("city=\(value.city!)")}
                        else {argsArray.append("city=NULL")}
                        if value.state != nil {argsArray.append("state=\(value.state!)")}
                        else {argsArray.append("state=NULL")}
                        if startDate != "" { argsArray.append("startDate=\(startDate)")}
                        else { argsArray.append("startDate=NULL")}
                        if endDate != "" {argsArray.append("endDate=\(endDate)")}
                        else {argsArray.append("endDate=NULL")}
                        if value.hasTime != nil {argsArray.append("hasTime=\(value.hasTime!)")}
                        else {argsArray.append("hasTime=NULL")}
                        if value.info != nil {argsArray.append("info=\(value.info!)")}
                        else {argsArray.append("info=NULL")}
                        if value.link != nil {argsArray.append("link=\(value.link!)")}
                        else {argsArray.append("link=NULL")}
                        if value.imageLink != nil {argsArray.append("imageLink=\(value.imageLink!)")}
                        else {argsArray.append("imageLink=NULL")}
                
                        DatabaseLoader.getJSONArray(requestType: "POST", link: "http://gorrick.tech/antfiles/hackathon_op/addhackathon.php",argsArray: argsArray)
                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
  
    //Public Scraping functions
    func scrapeData(URLString:String, label:String)
    {
        Alamofire.request(URLString).responseString(completionHandler: {response in
            if let html = response.result.value
            {
                //I wonder if anyone is acutally reading these comments...
                if label == "MLH"      { self.parseMLH(html: html) }
                else if label == "NYH" { self.parseNYH(html: html) }
            }
        })
    }
    
    //functions that scrapes from the major league hacking website
    func parseMLH(html: String)
    {
        let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8)
        
        for event in (doc?.xpath("//div[@class=\"event-wrapper\"]"))!
        {
            let eventHTML = try? Kanna.HTML(html: event.toHTML!, encoding: String.Encoding.utf8)
            
            //scrape date
            let name      =  eventHTML?.xpath("//h3")[0].text
            let date      =  eventHTML?.xpath("//p")[0].text
            let city      =  eventHTML?.xpath("//span")[0].text
            let state     =  eventHTML?.xpath("//span")[1].text
            let imageLink =  eventHTML?.xpath("//img/@src")[0].text
            let link      =  eventHTML?.xpath("//a/@href")[0].text
            
            //clean the date to the proper format from format like: AUG 27TH - 28TH
            let fullDateArray = date?.split(separator: "-") //split by to get: ["AUG 27TH", "28TH"]
            let firstHalfArray = fullDateArray![0].split(separator: " ") //split the first half to get ["AUG", "27TH"]
            
            let month = firstHalfArray[0].trimmingCharacters(in: NSCharacterSet.whitespaces)    //trim whitespace from month to get "AUG"
            var startDay = firstHalfArray[1].trimmingCharacters(in: NSCharacterSet.whitespaces) //trim whitespace from day to get "27TH"
            startDay = cleanDay(day: startDay) //remove "TH" from "27TH" to get "27"
            
            var endDay:String
            if(fullDateArray!.count > 1) //if there is an end date, process
            {
                endDay = fullDateArray![1].trimmingCharacters(in: NSCharacterSet.whitespaces)
                endDay = cleanDay(day: endDay)
            }
            
            //get current date
            let currentDate = Date()
            //get year to use later
            let calendar = Calendar.current
            let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
            
            var year:Int = 0
            switch(month)
            {
                //If the hackathon month is January - July AND the current month is after July, then
                //the hackathon is most likely taking place in the next year
                case "Jan": fallthrough
                case "Feb": fallthrough
                case "Mar": fallthrough
                case "Apr": fallthrough
                case "May": fallthrough
                case "Jun": fallthrough
                case "Jul":
                    if let currentMonth = currentComponents.month, let currentYear = currentComponents.year
                    {
                        if currentMonth > 7 { year = currentYear + 1 }
                        else { year = currentYear }
                    }
                //If the hackathon month is August - December AND the current month is after July, then the hackathon is most likely taking place in the previous year
                case "Aug": fallthrough
                case "Sep": fallthrough
                case "Oct": fallthrough
                case "Nov": fallthrough
                case "Dec":
                    if let currentMonth = currentComponents.month, let currentYear = currentComponents.year
                    {
                        if currentMonth > 7 { year = currentYear }
                        else { year = currentYear - 1 }
                    }
                default: //error
                    year = 0
            }
            
            //make the date string formatter to process date strings
            let dateStringFormatter = Date.getDateFormatter()
            let d = dateStringFormatter.date(from: "\(year)-\(DateEnum.getDateFromString(dateString: month))-\(startDay)")
            
            
            //check if the date is greater than the current date
            if let hackDate = d, hackDate >= currentDate
            {
                if let hackName = name, let hackCity = city, let hackState = state
                {
                    self.sortedAddToHackathonList(value: HackathonData(name: hackName, description: nil, prizeText: nil, city: hackCity, state:hackState, startDate: hackDate, endDate: nil, info: nil, link: link, imageLink: imageLink, hackathonImage: nil, hasTime: false))
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    //eliminate unneeded letters from date
    func cleanDay(day:String) -> String
    {
        var newDay = day
        
        newDay = newDay.replacingOccurrences(of: "th", with: "")
        newDay = newDay.replacingOccurrences(of: "rd", with: "")
        newDay = newDay.replacingOccurrences(of: "nd", with: "")
        newDay = newDay.replacingOccurrences(of: "st", with: "")
        
        return newDay
    }
    
    //this function parses the data from the new yrok hackathon websites
    func parseNYH(html:String)
    {
        let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8)
        
        for event in (doc?.xpath("//article"))!
        {
            let eventHTML = try? Kanna.HTML(html: event.toHTML!, encoding: String.Encoding.utf8)
            
            //this website contains JSON data, so we parse pbased on that
            let script = eventHTML?.xpath("//script")[0].text
            let jsonString = script?.parseJSONString
 
            if let jsonString = jsonString
            {
                //get simple data
                let name        =  jsonString["name"]      as? String
                var date        =  jsonString["startDate"] as? String
                let imageLink   =  jsonString["image"]     as? String
                
                //get dictionary data
                let locationDict = jsonString["location"]  as? [String:Any]
                
                if let locationDict = locationDict
                {
                    let addressDict = locationDict["address"] as? [String:Any]
                    
                    if let addressDict = addressDict
                    {
                        //get data from the dictionarys
                        let state = addressDict["addressRegion"] as? String
                        let link  = locationDict["url"] as? String
                        date = date?.substring(to: (date?.characters.index(of: "T"))!)
                        
                        //get current date
                        let currentDate = Date()
                        
                        //make the date string formatter to process date strings
                        let dateStringFormatter = Date.getDateFormatter()
                        if let date = date
                        {
                            let d = dateStringFormatter.date(from: date)
                            
                            //check if the date is greater than the current date
                            if let hackDate = d, hackDate >= currentDate
                            {
                                self.sortedAddToHackathonList(value: HackathonData(name: name , description: nil, prizeText: nil, city: nil, state: state , startDate: d, endDate: nil, info: nil, link: link, imageLink: imageLink, hackathonImage: nil, hasTime: false))
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    //This functions parses data from the Hackathon List API
    func parseHL(startURL:String, yearString:String, monthString:String, endURL:String)
    {
        //the variables that hold the date information
        let monthInt  = Int(monthString)
        let yearInt   = Int(yearString)

        if let yearInt = yearInt, let monthInt = monthInt
        {
            Alamofire.request(startURL + "\(yearInt)" + "/" + zeroPad(monthInt) + endURL).responseJSON(completionHandler: {response in
                if let json = response.result.value as? [String:Any]
                {
                    if let monthArray = json[DateEnum.getNameFromNumber(self.zeroPad(monthInt))] as? NSArray
                    {
                        for value in monthArray
                        {
                            if let dict = value as? [String:Any]
                            {
                                //get values from JSON data
                                let name           = dict["title"]     as? String
                                let hasPrize       = dict["title"]     as? String
                                let locationString = dict["city"]      as? String
                                let startString    = dict["startDate"] as? String
                                let endString      = dict["endDate"]   as? String
                                let info           = dict["notes"]     as? String
                                let link           = dict["url"]       as? String
                                
                                //get prizeString value from response
                                let prizeString = hasPrize == "yes" ? "See link for prize": nil
                                
                                //parse the location string into usable city and state data
                                if let locationString  = locationString
                                {
                                    let locationStringArray = locationString.split(separator: ",")
                                    let city = locationStringArray[0].trimmingCharacters(in: CharacterSet.whitespaces)
                                    
                                    var state:String = ""
                                    if locationStringArray.count > 1
                                    {
                                      if locationStringArray[1].trimmingCharacters(in: CharacterSet.whitespaces).count == 2
                                      {
                                        state = locationStringArray[1].trimmingCharacters(in: CharacterSet.whitespaces).uppercased()
                                      }
                                      else
                                      {
                                        state = StateEnum.getStateAbbreviation(stateString: locationStringArray[1].trimmingCharacters(in: CharacterSet.whitespaces))
                                      }
                                      
                                      //if there was no known state given, just give the string that was given
                                      if state == "Error"
                                      {
                                        state = locationStringArray[1].trimmingCharacters(in: CharacterSet.whitespaces)
                                      }
                                    }
                             
                                  
                                    //get current date
                                    let currentDate = Date()
                                    
                                    //split the date into usable data
                                    if let startString = startString
                                    {
                                        let startDateStringArray = startString.split(separator: " ")
                                        let startMonthString = DateEnum.getDateFromString(dateString: String(startDateStringArray[0].prefix(3)))
                                        
                                        let startDay  = startDateStringArray[1]
                                        let startYear = "\(yearInt)"
                                        
                                        let date = "\(startYear)-\(startMonthString)-\(startDay)"
                                        
                                        let dateStringFormatter = Date.getDateFormatter()
                                        let d = dateStringFormatter.date(from: date)
                                        
                                        var dEnd:Date?
                                        if let endString = endString
                                        {
                                            let endDateStringArray = endString.split(separator: " ")
                                            let endMonthString = DateEnum.getDateFromString(dateString: String(endDateStringArray[0].prefix(3)))
                                            
                                            let endDay  = endDateStringArray[1]
                                            let endYear = "\(yearInt)"
                                            
                                            let dateEnd = "\(endYear)-\(endMonthString)-\(endDay)"
                                            
                                            dEnd = dateStringFormatter.date(from: dateEnd)
                                        }
                                        //check if the date is greater than the current date
                                        if let d = d, d >= currentDate
                                        {
                                            self.sortedAddToHackathonList(value: HackathonData(name: name, description: nil, prizeText: prizeString, city: city, state: state, startDate: d, endDate: dEnd, info: info, link: link, imageLink: nil, hackathonImage: nil, hasTime: false))
                                            self.collectionView.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    //increment the month/year and then continue
                    var newMonth = monthInt + 1
                    var newYear  = yearInt
                    if newMonth == 13
                    {
                        newYear += 1
                        newMonth = 1
                    }
                    
                    self.parseHL(startURL: startURL, yearString: "\(newYear)", monthString: "\(newMonth)", endURL: endURL)
                }
            })
        }
    }
    
    //pad the month with the appropriate amount of zeros
    public func zeroPad(_ monthInt: Int) -> String
    {
        if monthInt < 10 { return "0\(monthInt)" }
        else { return "\(monthInt)" }
    }
    
    public func sortedAddToHackathonList(value:HackathonData)
    {
        let inTheArray = self.dbHackathonDataList.contains(where: {
            let calendar = Calendar.current
            var year1:Int?, month1:Int?, day1:Int?, year2:Int?, month2:Int?, day2:Int?
            
            if let startDate1 = $0.startDate, let startDate2 = value.startDate
            {
                year1 = calendar.component(.year, from: startDate1)
                month1 = calendar.component(.month, from: startDate1)
                day1 = calendar.component(.day, from: startDate1)
                
                year2 = calendar.component(.year, from: startDate2)
                month2 = calendar.component(.month, from: startDate2)
                day2 = calendar.component(.day, from: startDate2)
            }
            
            
            return $0.name  == value.name  &&
                $0.city  == value.city  &&
                $0.state == value.state &&
                month1   == month2      &&
                day1     == day2        &&
                year1    == year2
        })
        
        let inTheArray2 = self.hackathonDataList.contains(where: {
            let calendar = Calendar.current
            var year1:Int?, month1:Int?, day1:Int?, year2:Int?, month2:Int?, day2:Int?
            
            if let startDate1 = $0.startDate, let startDate2 = value.startDate
            {
                year1 = calendar.component(.year, from: startDate1)
                month1 = calendar.component(.month, from: startDate1)
                day1 = calendar.component(.day, from: startDate1)
                
                year2 = calendar.component(.year, from: startDate2)
                month2 = calendar.component(.month, from: startDate2)
                day2 = calendar.component(.day, from: startDate2)
            }
            
            return $0.name  == value.name  &&
                   $0.city  == value.city  &&
                   $0.state == value.state &&
                   month1   == month2      &&
                   day1     == day2        &&
                   year1    == year2
        })
        
        //if this is not duplicate data
        if !inTheArray && !inTheArray2
        {
            var endIndex = 0
            
            for i in 0..<hackathonDataList.count
            {
                if let currentState = hackathonDataList[i].state, let newState = value.state
                {
                    if let currentRawState = StateEnum.getStateValue(stateString: newState)?.rawValue, let newRawState = StateEnum.getStateValue(stateString: currentState)?.rawValue
                    {
                        endIndex = i
                        if newRawState > currentRawState
                        {
                            break
                        }
                    }
                }
            }
            
            self.hackathonDataList.insert(value, at: endIndex)
            self.collectionView.reloadData()
        }
    }
}

extension String
{
    var parseJSONString: AnyObject?
    {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data
        {
            // Will return an object or nil if JSON decoding fails
            return try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
        } else
        {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}

extension Date
{
    public static func getDateFormatter() -> DateFormatter
    {
        //make the date string formatter to process date strings
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        
        return dateStringFormatter
    }
}
