//
//  InterfaceController.swift
//  LocksmithExample WatchKit Extension
//
//  Created by Tai Heng on 05/09/2015.
//  Copyright © 2015 matthewpalmer. All rights reserved.
//

import WatchKit
import Foundation
import Locksmith
import WatchConnectivity

// The username to attempt retrieving a password from keychain for
let hardcodedUsername = "testUser"
let passwordKey = "passwordKey"

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet var retrievedPassword: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func retrievePassword() {
        var passwordText: String?
        if let dictionary = Locksmith.loadDataForUserAccount(hardcodedUsername),
            password = dictionary[passwordKey] as? String {
                passwordText = password
        }
        
        retrievedPassword.setText(passwordText ?? "")
    }
    
    @IBAction func saveHardcodedData() {
        do {
            try Locksmith.updateData([passwordKey: "123456Aa"], forUserAccount: hardcodedUsername)
        } catch {
            
        }
    }
}
