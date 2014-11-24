//
//  Locksmith.swift
//  Locksmith-Demo
//
//  Created by Matthew Palmer on 26/10/2014.
//  Copyright (c) 2014 Colour Coding. All rights reserved.
//

import UIKit

public let LocksmithErrorDomain = "com.locksmith.error"

class Locksmith: NSObject {
    // MARK: Perform request
    class func performRequest(request: LocksmithRequest) -> (NSDictionary?, NSError?) {
        let type = request.type
        var result: Unmanaged<AnyObject>? = nil
        var status: OSStatus?
        
        var parsedRequest: NSMutableDictionary = parseRequest(request)
        
        var requestReference = parsedRequest as CFDictionaryRef
        
        switch type {
        case .Create:
            status = SecItemAdd(requestReference, &result)
        case .Read:
            status = SecItemCopyMatching(requestReference, &result)
        case .Delete:
            status = SecItemDelete(requestReference)
        case .Update:
            status = Locksmith.performUpdate(requestReference, result: &result)
        default:
            status = nil
        }
        
        if let status = status {
            var statusCode = Int(status)
            let error = Locksmith.keychainError(forCode: statusCode)
            var resultsDictionary: NSDictionary?
            
            if result != nil {
                if type == .Read && status == errSecSuccess {
                    if let data = result?.takeUnretainedValue() as? NSData {
                        // Convert the retrieved data to a dictionary
                        resultsDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary
                    }
                }
            }
            
            return (resultsDictionary, error)
        } else {
            let code = LocksmithErrorCode.TypeNotFound.rawValue
            let message = internalErrorMessage(forCode: code)
            
            
            return (nil, NSError(domain: LocksmithErrorDomain, code: code, userInfo: ["message": message]))
        }
    }
    
    private class func performUpdate(request: CFDictionaryRef, result: UnsafeMutablePointer<Unmanaged<AnyObject>?>) -> OSStatus {
        // We perform updates to the keychain by first deleting the matching object, then writing to it with the new value.
        SecItemDelete(request)
        // Even if the delete request failed (e.g. if the item didn't exist before), still try to save the new item. 
        // If we get an error saving, we'll tell the user about it.
        var status: OSStatus = SecItemAdd(request, result)
        return status
    }
    
    // MARK: Error Lookup
    enum ErrorMessage: String {
        case Allocate = "Failed to allocate memory."
        case AuthFailed = "Authorization/Authentication failed."
        case Decode = "Unable to decode the provided data."
        case Duplicate = "The item already exists."
        case InteractionNotAllowed = "Interaction with the Security Server is not allowed."
        case NoError = "No error."
        case NotAvailable = "No trust results are available."
        case NotFound = "The item cannot be found."
        case Param = "One or more parameters passed to the function were not valid."
        case Unimplemented = "Function or operation not implemented."
    }
    
    enum LocksmithErrorCode: Int {
        case RequestNotSet = 1
        case TypeNotFound = 2
    }
    
    enum LocksmithErrorMessage: String {
        case RequestNotSet = "keychainRequest was not set."
        case TypeNotFound = "The type of request given was undefined."
    }
    
    class func keychainError(forCode statusCode: Int) -> NSError? {
        var error: NSError?
        
        if statusCode != Int(errSecSuccess) {
            let message = errorMessage(statusCode)
            println("Keychain request failed. Code: \(statusCode). Message: \(message)")
            error = NSError(domain: LocksmithErrorDomain, code: statusCode, userInfo: ["message": message])
        }
        
        return error
    }
    
    // MARK: Private methods
    
    private class func internalErrorMessage(forCode statusCode: Int) -> NSString {
        switch statusCode {
        case LocksmithErrorCode.RequestNotSet.rawValue:
            return LocksmithErrorMessage.RequestNotSet.rawValue
        default:
            return "Error message for code \(statusCode) not set"
        }
    }
    
    private class func parseRequest(request: LocksmithRequest) -> NSMutableDictionary {
        var parsedRequest = NSMutableDictionary()
        
        parsedRequest.setOptional(request.userAccount, forKey: String(kSecAttrAccount))
        parsedRequest.setOptional(request.group, forKey: String(kSecAttrAccessGroup))
        parsedRequest.setOptional(request.service, forKey: String(kSecAttrService))
        
        // parsedRequest.setOptional(Locksmith.securityCode(request.securityClass), forKey: String(kSecClass))
        parsedRequest.setOptional(kSecClassGenericPassword, forKey: String(kSecClass))
        
        switch request.type {
        case .Create:
            parsedRequest = parseCreateRequest(request, inDictionary: parsedRequest)
        case .Delete:
            parsedRequest = parseDeleteRequest(request, inDictionary: parsedRequest)
        case .Update:
            parsedRequest = parseCreateRequest(request, inDictionary: parsedRequest)
        default: // case .Read:
            parsedRequest = parseReadRequest(request, inDictionary: parsedRequest)
        }
        
        return parsedRequest
    }
    
    private class func parseCreateRequest(request: LocksmithRequest, inDictionary dictionary: NSMutableDictionary) -> NSMutableDictionary {
        
        if let data = request.data {
            let encodedData = NSKeyedArchiver.archivedDataWithRootObject(data)
            dictionary.setObject(encodedData, forKey: String(kSecValueData))
        }
        
        return dictionary
    }
    
    
    private class func parseReadRequest(request: LocksmithRequest, inDictionary dictionary: NSMutableDictionary) -> NSMutableDictionary {
        dictionary.setOptional(kCFBooleanTrue, forKey: String(kSecReturnData))
        
        switch request.matchLimit {
        case .One:
            dictionary.setObject(kSecMatchLimitOne, forKey: String(kSecMatchLimit))
        case .Many:
            dictionary.setObject(kSecMatchLimitAll, forKey: String(kSecMatchLimit))
        }
        
        return dictionary
    }
    
    private class func parseDeleteRequest(request: LocksmithRequest, inDictionary dictionary: NSMutableDictionary) -> NSMutableDictionary {
        return dictionary
    }
    
    private class func errorMessage(code: Int) -> NSString {
        switch code {
        case Int(errSecAllocate):
            return ErrorMessage.Allocate.rawValue
        case Int(errSecAuthFailed):
            return ErrorMessage.AuthFailed.rawValue
        case Int(errSecDecode):
            return ErrorMessage.Decode.rawValue
        case Int(errSecDuplicateItem):
            return ErrorMessage.Duplicate.rawValue
        case Int(errSecInteractionNotAllowed):
            return ErrorMessage.InteractionNotAllowed.rawValue
        case Int(errSecItemNotFound):
            return ErrorMessage.NotFound.rawValue
        case Int(errSecNotAvailable):
            return ErrorMessage.NotAvailable.rawValue
        case Int(errSecParam):
            return ErrorMessage.Param.rawValue
        case Int(errSecSuccess):
            return ErrorMessage.NoError.rawValue
        case Int(errSecUnimplemented):
            return ErrorMessage.Unimplemented.rawValue
        default:
            return "Undocumented error with code \(code)."
        }
    }
    
    private class func securityCode(securityClass: SecurityClass) -> CFStringRef {
        switch securityClass {
        case .GenericPassword:
            return kSecClassGenericPassword
        default:
            return kSecClassGenericPassword
        }
    }
}

// MARK: Convenient Class Methods
extension Locksmith {
    class func saveData(data: Dictionary<String, String>, forKey key: String, inService service: String, forUserAccount userAccount: String) -> (NSDictionary?, NSError?) {
        let saveRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key, requestType: .Create, data: data)
        return Locksmith.performRequest(saveRequest)
    }
    
    class func loadData(forKey key: String, inService service: String, forUserAccount userAccount: String) -> (NSDictionary?, NSError?) {
        let readRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key)
        return Locksmith.performRequest(readRequest)
    }
    
    class func deleteData(forKey key: String, inService service: String, forUserAccount userAccount: String) -> (NSDictionary?, NSError?) {
        let deleteRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key, requestType: .Delete)
        return Locksmith.performRequest(deleteRequest)
    }
    
    class func updateData(data: Dictionary<String, String>, forKey key: String, inService service: String, forUserAccount userAccount: String) -> (NSDictionary?, NSError?) {
        let updateRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key, requestType: .Update, data: data)
        return Locksmith.performRequest(updateRequest)
    }
}

// MARK: Dictionary Extensions
extension NSMutableDictionary {
    func setOptional(optional: AnyObject?, forKey key: NSCopying) {
        if let object: AnyObject = optional {
            self.setObject(object, forKey: key)
        }
    }
}
