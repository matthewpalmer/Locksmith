//
//  LocksmithRequest.swift
//
//  Created by Matthew Palmer on 26/10/2014.
//  Copyright (c) 2014 Colour Coding. All rights reserved.
//

import Foundation
import Security

// With thanks to http://iosdeveloperzone.com/2014/10/22/taming-foundation-constants-into-swift-enums/

// MARK: Security Class
public enum SecurityClass: RawRepresentable {
    case GenericPassword, InternetPassword, Certificate, Key, Identity
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecClassGenericPassword):
            self = GenericPassword
        case String(kSecClassInternetPassword):
            self = InternetPassword
        case String(kSecClassCertificate):
            self = Certificate
        case String(kSecClassKey):
            self = Key
        case String(kSecClassIdentity):
            self = Identity
        default:
            print("SecurityClass: Invalid raw value provided. Defaulting to .GenericPassword")
            self = GenericPassword
        }
    }
    
    public var rawValue: String {
        switch self {
        case .GenericPassword:
            return String(kSecClassGenericPassword)
        case .InternetPassword:
            return String(kSecClassInternetPassword)
        case .Certificate:
            return String(kSecClassCertificate)
        case .Key:
            return String(kSecClassKey)
        case .Identity:
            return String(kSecClassIdentity)
        }
    }
}

// MARK: Accessible
public enum Accessible: RawRepresentable {
    case WhenUnlocked, AfterFirstUnlock, Always, WhenUnlockedThisDeviceOnly, AfterFirstUnlockThisDeviceOnly, AlwaysThisDeviceOnly
    @available (iOS 8,*)
    case WhenPasscodeSetThisDeviceOnly
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAccessibleWhenUnlocked):
            self = WhenUnlocked
        case String(kSecAttrAccessibleAfterFirstUnlock):
            self = AfterFirstUnlock
        case String(kSecAttrAccessibleAlways):
            self = Always
        case String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly):
            self = WhenUnlockedThisDeviceOnly
        case String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly):
            self = AfterFirstUnlockThisDeviceOnly
        case String(kSecAttrAccessibleAlwaysThisDeviceOnly):
            self = AlwaysThisDeviceOnly
        default:
            if #available(iOS 8,*) {
                if rawValue == String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly) {
                    self = WhenPasscodeSetThisDeviceOnly
                } else {
                    print("Accessible: invalid rawValue provided. Defaulting to Accessible.WhenUnlocked.")
                    self = WhenUnlocked
                }
            } else {
                print("Accessible: invalid rawValue provided. Defaulting to Accessible.WhenUnlocked.")
                self = WhenUnlocked
            }
        }
    }
    
    public var rawValue: String {
        switch self {
        case .WhenUnlocked:
            return String(kSecAttrAccessibleWhenUnlocked)
        case .AfterFirstUnlock:
            return String(kSecAttrAccessibleAfterFirstUnlock)
        case .Always:
            return String(kSecAttrAccessibleAlways)
        case .WhenPasscodeSetThisDeviceOnly:
            if #available(iOS 8.0, *) {
                return String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
            } else {
                fatalError("Accessible.WhenPasscodeSetThisDeviceOnly has no raw representation in iOS 7.")
            }
        case .WhenUnlockedThisDeviceOnly:
            return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
        case .AfterFirstUnlockThisDeviceOnly:
            return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        case .AlwaysThisDeviceOnly:
            return String(kSecAttrAccessibleAlwaysThisDeviceOnly)
        }
    }
}

// MARK: Match Limit
public enum MatchLimit {
    case One, Many
}

// MARK: Request Type
public enum RequestType {
    case Create, Read, Update, Delete
}

// MARK: Locksmith Request
public class LocksmithRequest: NSObject, CustomDebugStringConvertible {
    // Keychain Options
    // Required
    public var service: String = LocksmithDefaultService
    public var userAccount: String
    public var type: RequestType = .Read  // Default to non-destructive
    
    // Optional
    public var securityClass: SecurityClass = .GenericPassword  // Default to password lookup
    public var group: String?
    public var data: NSDictionary?
    public var matchLimit: MatchLimit = .One
    public var synchronizable = false
    public var accessible: Accessible?
    
    // Debugging
    override public var debugDescription: String {
        return "service: \(self.service), type: \(self.type), userAccount: \(self.userAccount)"
    }
    
    required public init(userAccount: String, service: String = LocksmithDefaultService) {
        self.service = service
        self.userAccount = userAccount
    }
    
    public convenience init(userAccount: String, requestType: RequestType, service: String = LocksmithDefaultService) {
        self.init(userAccount: userAccount, service: service)
        self.type = requestType
    }
    
    public convenience init(userAccount: String, requestType: RequestType, data: NSDictionary, service: String = LocksmithDefaultService) {
        self.init(userAccount: userAccount, requestType: requestType, service: service)
        self.data = data
    }
}
