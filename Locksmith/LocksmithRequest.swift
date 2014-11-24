//
//  LocksmithRequest.swift
//  Locksmith-Demo
//
//  Created by Matthew Palmer on 26/10/2014.
//  Copyright (c) 2014 Colour Coding. All rights reserved.
//

enum SecurityClass: Int {
    case GenericPassword, InternetPassword, Certificate, Key, Identity
}

import UIKit

enum MatchLimit: Int {
    case One, Many
}

enum RequestType: Int {
    case Create, Read, Update, Delete
}

class LocksmithRequest: NSObject, DebugPrintable {
    // Keychain Options
    // Required
    var service: String
    var key: String
    var userAccount: String
    var type: RequestType = .Read  // Default to non-destructive
    
    // Optional
    // var securityClass: SecurityClass = .GenericPassword  // Default to password lookup
    var group: String?
    var data: NSDictionary?
    var matchLimit: MatchLimit = .One  // Default to one
    
    // Debugging
    override var debugDescription: String {
        
        return "service: \(self.service), key: \(self.key), type: \(self.type.rawValue), userAccount: \(self.userAccount)"
    }
    
    required init(service: String, userAccount: String, key: String) {
        self.service = service
        self.userAccount = userAccount
        self.key = key
    }
    
    convenience init(service: String, userAccount: String, key: String, requestType: RequestType) {
        self.init(service: service, userAccount: userAccount, key: key)
        self.type = requestType
    }
    
    convenience init(service: String, userAccount: String, key: String, requestType: RequestType, data: NSDictionary) {
        self.init(service: service, userAccount: userAccount, key: key, requestType: requestType)
        self.data = data
    }
}
