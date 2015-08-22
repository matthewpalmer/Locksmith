//
//  LocksmithRequest.swift
//
//  Created by Matthew Palmer on 26/10/2014.
//  Copyright (c) 2014 Colour Coding. All rights reserved.
//

import UIKit
import Security

public enum SecurityClass: Int {
    case GenericPassword, InternetPassword, Certificate, Key, Identity
    
    static let allClasses = [GenericPassword, InternetPassword, Certificate, Key, Identity]
}

public enum MatchLimit: Int {
    case One, All
    @available(*, deprecated=1.1.2, message="Use .All instead.") case Many
}

public enum RequestType: Int {
    case Create, Read, Update, Delete
}

public enum Accessible: Int {
    case WhenUnlock, AfterFirstUnlock, Always, WhenPasscodeSetThisDeviceOnly,
    WhenUnlockedThisDeviceOnly, AfterFirstUnlockThisDeviceOnly, AlwaysThisDeviceOnly
}

public class LocksmithRequest: NSObject {
    // Keychain Options
    // Required
    public var service: String = LocksmithDefaultService
    public var userAccount: String?
    public var type: RequestType = .Read  // Default to non-destructive
    
    // Optional
    public var securityClass: SecurityClass = .GenericPassword  // Default to password lookup
    public var group: String?
    public var data: NSDictionary?
    public var matchLimit: MatchLimit = .One
    public var synchronizable = false
    public var accessible: Accessible?
    
    required public init(userAccount: String?, service: String = LocksmithDefaultService) {
        self.service = service
        self.userAccount = userAccount
    }
    
    public convenience init(userAccount: String?, requestType: RequestType, service: String = LocksmithDefaultService) {
        self.init(userAccount: userAccount, service: service)
        self.type = requestType
    }
    
    public convenience init(userAccount: String?, requestType: RequestType, data: NSDictionary, service: String = LocksmithDefaultService) {
        self.init(userAccount: userAccount, requestType: requestType, service: service)
        self.data = data
    }
}
