//
//  LocksmithRequest.swift
//  Locksmith-Demo
//
//  Created by Matthew Palmer on 26/10/2014.
//  Copyright (c) 2014 Colour Coding. All rights reserved.
//

import UIKit

public enum SecurityClass: Int {
    case GenericPassword, InternetPassword, Certificate, Key, Identity
}

public enum MatchLimit: Int {
    case One, Many
}

public enum RequestType: Int {
    case Create, Read, Update, Delete
}

public class LocksmithRequest: NSObject, DebugPrintable {
    // Keychain Options
    // Required
    var service = NSBundle.mainBundle().infoDictionary![kCFBundleIdentifierKey] as String
    var userAccount: String
    var type: RequestType = .Read  // Default to non-destructive
    
    // Optional
    var securityClass: SecurityClass = .GenericPassword  // Default to password lookup
    var group: String?
    var data: NSDictionary?
    var matchLimit: MatchLimit = .One
    var synchronizable = false
    
    // Debugging
    override public var debugDescription: String {
        return "service: \(self.service), type: \(self.type.rawValue), userAccount: \(self.userAccount)"
    }
    
    required public init(service: String = LocksmithDefaultService, userAccount: String) {
        self.service = service
        self.userAccount = userAccount
    }
    
    convenience init(service: String = LocksmithDefaultService, userAccount: String, requestType: RequestType) {
        self.init(service: service, userAccount: userAccount)
        self.type = requestType
    }
    
    convenience init(service: String = LocksmithDefaultService, userAccount: String, requestType: RequestType, data: NSDictionary) {
        self.init(service: service, userAccount: userAccount, requestType: requestType)
        self.data = data
    }
}
