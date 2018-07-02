//
//  DatabaseLoader.swift
//  
//
//  Created by Jesse Seidman on 12/19/17.
//

import UIKit
import Alamofire

class DatabaseLoader: NSObject
{
    public static func getJSONArray(requestType:String, link:String, argsArray:[String]) -> [String:Any]
    {
        var jsonArray:[String:Any] = [:]
        
        //get URL
        if let url = URL(string: link)
        {
            //start request
            var request = URLRequest(url: url)
            
            request.httpMethod = requestType
            
            if !argsArray.isEmpty
            {
                var postString = ""
                for i in 0 ..< argsArray.count
                {
                    if i == 0
                    {
                        postString += argsArray[i]
                    }
                    else
                    {
                        postString += "&\(argsArray[i])"
                    }
                }

                request.httpBody = postString.data(using: .utf8)
            }
            
            let semaphore = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                
                if let array = jsonData as? [String:Any]
                {
                    print(jsonArray)
                    jsonArray = array
                }
                semaphore.signal()
            }
            
            task.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        }
        
        return jsonArray
    }

    public static func getHackathonDataList(requestType:String, link:String, argsArray:[String]) -> [HackathonData]
    {
        var hackArray:[HackathonData] = []
        
        //get URL
        if let url = URL(string: link)
        {
            //start request
            var request = URLRequest(url: url)
            
            request.httpMethod = requestType
            
            if !argsArray.isEmpty
            {
                var postString = ""
                for i in 0 ..< argsArray.count
                {
                    if i == 0
                    {
                        postString += argsArray[i]
                    }
                    else
                    {
                        postString += "&\(argsArray[i])"
                    }
                }
                
                request.httpBody = postString.data(using: .utf8)
            }
            
            let semaphore = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                print("response=\(response)")
                print("data=\(data)")
                let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                if let jsonArray = jsonArray
                {
                    print(jsonArray)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    for value in jsonArray!
                    {
                        var myImage:UIImage? = nil
                        let imageString = value["imageLink"] as? String
                        if let imageData = NSData(base64Encoded: imageString!, options: [])
                        {
                            if let decodedImage = UIImage(data: imageData as Data)
                            {
                                myImage = decodedImage
                            }
                        }
                        hackArray.append(HackathonData(
                            name: value["name"] as! String == "NULL" ? nil : value["name"] as! String,
                            description: value["description"] as! String == "NULL" ? nil : value["description"] as! String,
                            prizeText: value["prize"] as! String == "NULL" ? nil : value["prize"] as! String,
                            city: value["city"] as! String == "NULL" ? nil : value["city"] as! String,
                            state: value["state"] as! String == "NULL" ? nil : value["state"] as! String,
                            startDate: value["startDate"] as! String == "NULL" ? nil : dateFormatter.date(from: value["startDate"] as! String),
                            endDate: value["endDate"] as! String == "NULL" ? nil : dateFormatter.date(from: value["endDate"] as! String),
                            info: value["info"] as! String == "NULL" ? nil : value["info"] as! String,
                            link: value["link"] as! String == "NULL" ? nil : value["link"] as! String,
                            imageLink: value["imageLink"] as! String == "NULL" ? nil : value["imageLink"] as! String,
                            hackathonImage: myImage,
                            hasTime: false))
                    }
                }
                semaphore.signal()
            }
            
            task.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        }
        
        return hackArray
    }
    
    static func uploadImage(link:String, argsDict:[String:String], hackImage:UIImage) -> [String:Any]
    {
        var jsonArray:[String:Any] = [:]
        
        let imgData = UIImageJPEGRepresentation(hackImage, 0.2)!
        
        let semaphore = DispatchSemaphore(value: 0)
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "hackathonImage",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in argsDict
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:link)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    if let data = response.result.value
                    {
                        print(response)
                        print(data)
                        if let array = data as? [String:Any]
                        {
                            jsonArray = array
                        }
                    }
                    semaphore.signal()
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
        return jsonArray
    }
}

