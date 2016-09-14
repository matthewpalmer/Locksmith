//
//  AppDelegate.swift
//  Locksmith iOS Example
//
//  Created by Matthew Palmer on 12/09/2015.
//  Copyright © 2015 Matthew Palmer. All rights reserved.
//

import UIKit
import Locksmith

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
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
        
        print("iOS app: \(result), \(result?.data)")
        
        // DeleteableSecureStorable lets us delete the account from the keychain
        try! account.deleteFromSecureStore()
        
        
        return true
    }
}

