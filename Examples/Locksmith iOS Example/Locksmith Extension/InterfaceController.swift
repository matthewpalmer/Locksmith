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

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        
        struct TwitterAccount: ReadableSecureStorable, CreateableSecureStorable, DeleteableSecureStorable, GenericPasswordSecureStorable {
            let username: String
            let password: String
            
            let service = "Twitter"
            
            var account: String { return username }
            
            var data: [String: Any] {
                return ["password": password]
            }
        }
        
        let account = TwitterAccount(username: "_matthewpalmer", password: "my_password")
        
        // CreateableSecureStorable lets us create the account in the keychain
        try! account.createInSecureStore()
        
        // ReadableSecureStorable lets us read the account from the keychain
        let result = account.readFromSecureStore()
        
        print("Watch app: \(result), \(result?.data)")
        
        // DeleteableSecureStorable lets us delete the account from the keychain
        try! account.deleteFromSecureStore()
    }
    
    @available(watchOSApplicationExtension 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
}
