//
//  ViewController.swift
//  Locksmith
//
//  Created by Matthew Palmer on 26/10/2014.
//  Copyright (c) 2014 Matthew Palmer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let service = "Locksmith"
    let userAccount = "LocksmithUser"
    let key = "myKey"
    
    @IBAction func save(sender: AnyObject) {
        Locksmith.saveData(["some key": "\(NSDate())"], forKey: key, inService: service, forUserAccount: userAccount)
    }
    
    @IBAction func update(sender: AnyObject) {
        Locksmith.updateData(["some key": "\(NSDate())"], forKey: key, inService: service, forUserAccount: userAccount)
    }
    
    @IBAction func loadData(sender: AnyObject) {
        let (dictionary, error) = Locksmith.loadData(forKey: key, inService: service, forUserAccount: userAccount)
        
        if let dictionary = dictionary {
            println("Dictionary: \(dictionary)")
        }
        
        if let error = error {
            println("Error: \(error)")
        }
    }
    
    @IBAction func deleteData(sender: AnyObject) {
        Locksmith.deleteData(forKey: key, inService: service, forUserAccount: userAccount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

