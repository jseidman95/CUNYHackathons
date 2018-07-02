//
//  ViewController.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 11/29/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit

/*
 * This is the main view controller the user sees when he/she first opens the app.  It gives the user the option to sign in
 * and also has a create user button.  The user authentication and create new user is handled almost exclusively
 * by the backend.
 */
class ViewController: UIViewController
{
    //outlets
    @IBOutlet weak var usernameField:       UITextField!
    @IBOutlet weak var passwordField:       UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var signInButton:        UIButton!
    
    //vars
    public var isAdmin = false
    
    //automatically generated functions
    override func viewDidLoad() { super.viewDidLoad() }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }

    //the touches began function is overriden so that the keyboard can be dismissed when
    //the user clicks anywhere on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if usernameField.isFirstResponder || passwordField.isFirstResponder
        {
            usernameField.resignFirstResponder() //resign keyboard
            passwordField.resignFirstResponder() //resign keyboard
        }
    }
    
    //action functions
    @IBAction func signInAction(_ sender: Any)
    {
        //if the user has left fields blank, give user alert and force to resubmit
        if usernameField.text == "" || passwordField.text == ""
        {
            usernameField.text = ""
            passwordField.text = ""
            
            usernameField.resignFirstResponder()
            passwordField.resignFirstResponder()
            
            // create the alert
            let alert = UIAlertController(title: "Blank Fields", message: "Username and Password fields must have values", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        // if the user has not submitted a cuny email (and is not an admin), force user to resubmit and display alert
        else if !(usernameField.text?.hasSuffix(".cuny.edu"))! && usernameField.text != "admin"
        {
            usernameField.text = ""
            passwordField.text = ""
            
            usernameField.resignFirstResponder()
            passwordField.resignFirstResponder()
            
            // create the alert
            let alert = UIAlertController(title: "CUNY Email", message: "Enter a valid CUNY email", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        //if the user entered correct data, perform login
        else
        {
            usernameField.resignFirstResponder()
            passwordField.resignFirstResponder()
            
            performLogin(username:usernameField.text!, password: passwordField.text!)
        }
    }
    
    func performLogin(username:String, password:String)
    {
        let jsonArray = DatabaseLoader.getJSONArray(requestType: "POST", link: "http://gorrick.tech/antfiles/user_op/signin.php", argsArray: ["email=\(usernameField.text!)","password=\(passwordField.text!)"])
        
        if let jsonArray = jsonArray as? [String:String]
        {
            if jsonArray["user"] == "Regular user is logged in."
            {
                self.performSegue(withIdentifier: "goToTabSegue", sender: nil)
            }
            else if jsonArray["user"] == "Admin is logged in."
            {
                self.isAdmin = true
                self.performSegue(withIdentifier: "goToTabSegue", sender: nil)
            }
            else
            {
                print(jsonArray)
                // create the alert
                let alert = UIAlertController(title: "Error", message: "Username or Password incorrect", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    //This function passes the isAdmin boolean value to the next window
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goToTabSegue"
        {
            if let mainTabVC = segue.destination as? MainTabViewController
            {
                if let hackLandingVC = mainTabVC.viewControllers![0] as? HackathonViewController
                {
                    hackLandingVC.isAdmin = self.isAdmin
                }
            }
        }
    }
}

