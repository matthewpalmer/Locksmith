//
//  ViewController.swift
//  Locksmith iOS Example
//
//  Created by Matthew Palmer on 12/09/2015.
//  Copyright © 2015 Matthew Palmer. All rights reserved.
//

import UIKit
import Locksmith

let passwordKey = "passwordKey"

class ViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var retrieveUsernameField: UITextField!
    @IBOutlet weak var retrievedPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveToKeychain(sender: UIButton) {
        if let username = usernameField.text, password = passwordField.text {
            do {
                try Locksmith.updateData([passwordKey: password], forUserAccount: username)
            } catch {
                
            }
        }
    }
    
    @IBAction func retrievePasswordForUsername(sender: AnyObject) {
        if let username = retrieveUsernameField.text {
            if let dictionary = Locksmith.loadDataForUserAccount(username),
                password = dictionary[passwordKey] as? String {
                    retrievedPassword.text = password
            }
        }
    }
}

