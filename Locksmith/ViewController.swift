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
    let saveRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key, data: ["some key": "some value"])
    Locksmith.performRequest(saveRequest)
  }
  
  @IBAction func loadData(sender: AnyObject) {
    let readRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key)
    let (dictionary, error) = Locksmith.performRequest(readRequest)
    
    if let dictionary = dictionary {
      println("Dictionary: \(dictionary)")
    }
    
    if let error = error {
      println("Error: \(error)")
    }
  }
  
  @IBAction func deleteData(sender: AnyObject) {
    let deleteRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key, requestType: .Delete)
    Locksmith.performRequest(deleteRequest)
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

