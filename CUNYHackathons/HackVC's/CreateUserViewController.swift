//
//  CreateUserViewController.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 11/29/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit
/*
 * This view controller gives the option for the user to create a new account.
 */
class CreateUserViewController: UIViewController
{
    //outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordOneField: UITextField!
    @IBOutlet weak var passwordTwoField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    //automatically generated functions
    override func viewDidLoad() { super.viewDidLoad() }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    //action outlets
    @IBAction func cancelAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAction(_ sender: Any)
    {
        //if fields are left blank, display alert and reset fields
        if usernameField.text! == "" || passwordOneField.text! == "" || passwordTwoField.text! == ""
        {
            //end editing on all text fields
            self.usernameField.endEditing(true)
            self.passwordOneField.endEditing(true)
            self.passwordTwoField.endEditing(true)
            
            // create the alert
            let alert = UIAlertController(title: "Blank Fields", message: "Username and Password fields must have values", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        //if the username is not a cuny email, display alert and reset fields
        else if usernameField.text!.range(of: ".cuny.edu") == nil
        {
            self.usernameField.endEditing(true)
            self.passwordOneField.endEditing(true)
            self.passwordTwoField.endEditing(true)
            
            self.usernameField.text = ""
            self.passwordTwoField.text = ""
            self.passwordOneField.text = ""
            
            // create the alert
            let alert = UIAlertController(title: "CUNY Email", message: "Username must be a cuny email", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        //if the passwords dont match, display alert and reset fields
        else if passwordTwoField.text! != passwordOneField.text!
        {
            self.usernameField.endEditing(true)
            self.passwordOneField.endEditing(true)
            self.passwordTwoField.endEditing(true)
            
            self.passwordTwoField.text = ""
            self.passwordOneField.text = ""
            // create the alert
            let alert = UIAlertController(title: "Mismatched Passwords", message: "Passwords must match", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        //otherwise, perform signup and display alert that email will be sent and go back to login screen
        else
        {
            self.usernameField.endEditing(true)
            self.passwordOneField.endEditing(true)
            self.passwordTwoField.endEditing(true)
            
            performSignUp(username: usernameField.text!, password1: passwordOneField.text!, password2: passwordTwoField.text!)
        }
    }
    
    func performSignUp(username:String, password1:String, password2:String)
    {
        let jsonArray = DatabaseLoader.getJSONArray(requestType: "POST", link: "http://gorrick.tech/antfiles/user_op/signup.php", argsArray: ["email=\(usernameField.text!)","password=\(passwordOneField.text!)","password2=\(passwordTwoField.text!)"])
        
        if jsonArray["user_created"] != nil
        {
            // create the alert
            let alert = UIAlertController(title: "User Created", message: "Your account has been created", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            var message = ""
            for (_, value) in jsonArray
            {
                message = value as! String
            }
            
            // create the alert
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //override touches becan to dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if      usernameField.isFirstResponder    { usernameField.resignFirstResponder() }
        else if passwordOneField.isFirstResponder { passwordOneField.resignFirstResponder() }
        else if passwordTwoField.isFirstResponder { passwordTwoField.resignFirstResponder() }
    }
}
