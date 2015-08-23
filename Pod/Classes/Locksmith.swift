//
//  Locksmith.swift
//
//  Created by Matthew Palmer on 26/10/2014.
//  Copyright (c) 2014 Colour Coding. All rights reserved.
//

import CoreFoundation
import UIKit
import Security

public let LocksmithDefaultService = NSBundle.mainBundle().infoDictionary![String(kCFBundleIdentifierKey)] as? String ?? "com.locksmith.defaultService"
/// This key is used to index the result of `performRequest` when there are multiple results.
/// An NSArray of the matching `[String: AnyObject]`s will be provided under this key.
public let LocksmithMultipleResultsKey = "locksmith_multiple_results_key"

// MARK: Locksmith Error
public enum LocksmithError: String, ErrorType {
    case Allocate = "Failed to allocate memory."
    case AuthFailed = "Authorization/Authentication failed."
    case Decode = "Unable to decode the provided data."
    case Duplicate = "The item already exists."
    case InteractionNotAllowed = "Interaction with the Security Server is not allowed."
    case NoError = "No error."
    case NotAvailable = "No trust results are available."
    case NotFound = "The item cannot be found."
    case Param = "One or more parameters passed to the function were not valid."
    case RequestNotSet = "The request was not set"
    case TypeNotFound = "The type was not found"
    case UnableToClear = "Unable to clear the keychain"
    case Undefined = "An undefined error occurred"
    case Unimplemented = "Function or operation not implemented."
    
    init?(fromStatusCode code: Int) {
        switch code {
        case Int(errSecAllocate):
            self = Allocate
        case Int(errSecAuthFailed):
            self = AuthFailed
        case Int(errSecDecode):
            self = Decode
        case Int(errSecDuplicateItem):
            self = Duplicate
        case Int(errSecInteractionNotAllowed):
            self = InteractionNotAllowed
        case Int(errSecItemNotFound):
            self = NotFound
        case Int(errSecNotAvailable):
            self = NotAvailable
        case Int(errSecParam):
            self = Param
        case Int(errSecUnimplemented):
            self = Unimplemented
        default:
            return nil
        }
    }
}

// MARK: Locksmith
public class Locksmith: NSObject {
    // MARK: Perform request
    public class func performRequest(request: LocksmithRequest) throws -> [String: AnyObject]? {
        let type = request.type
        var result: AnyObject?
        var optionalStatus: OSStatus?
        let parsedRequest: NSMutableDictionary = parseRequest(request)
        let requestReference = parsedRequest as CFDictionaryRef

        switch type {
        case .Create:
            optionalStatus = withUnsafeMutablePointer(&result) { SecItemAdd(requestReference, UnsafeMutablePointer($0)) }
        case .Read:
            optionalStatus = withUnsafeMutablePointer(&result) { SecItemCopyMatching(requestReference, UnsafeMutablePointer($0)) }
        case .Delete:
            optionalStatus = SecItemDelete(requestReference)
        case .Update:
            optionalStatus =  Locksmith.performUpdate(requestReference, result: &result)
        }
        
        guard let unwrappedStatus = optionalStatus else {
            throw LocksmithError.TypeNotFound
        }
        
        let statusCode = Int(unwrappedStatus)
        if let error = LocksmithError(fromStatusCode: statusCode) {
            throw error
        }
        
        var resultsDictionary: [String: AnyObject]?
        
        if type == .Read && unwrappedStatus == errSecSuccess {
            if request.matchLimit == .All {
                if let results = result as? NSArray {
                    resultsDictionary = [String: AnyObject]()
                    
                    let convertedResults = results.map({ (i) -> [String: AnyObject]? in
                        return Locksmith.dataToDictionary(i)
                    }).flatMap { $0 }
                    
                    resultsDictionary![LocksmithMultipleResultsKey] = convertedResults
                }
            } else {
                resultsDictionary = Locksmith.dataToDictionary(result)
            }
        }
        
        return resultsDictionary
    }
    
    private class func dataToDictionary(data: AnyObject?) -> [String: AnyObject]? {
        var resultsDictionary: [String: AnyObject]?
        if let data = data as? NSData {
            // Convert the retrieved data to a dictionary
            resultsDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String: AnyObject]
        }
        return resultsDictionary
    }
    
    // MARK: Private methods
    private class func performUpdate(request: CFDictionaryRef, inout result: AnyObject?) -> OSStatus {
        // We perform updates to the keychain by first deleting the matching object, then writing to it with the new value.
        SecItemDelete(request)
        
        // Even if the delete request failed (e.g. if the item didn't exist before), still try to save the new item.
        // If we get an error saving, we'll tell the user about it.
        let status: OSStatus = withUnsafeMutablePointer(&result) { SecItemAdd(request, UnsafeMutablePointer($0)) }
        return status
    }
    
    private class func parseRequest(request: LocksmithRequest) -> NSMutableDictionary {
        var parsedRequest = NSMutableDictionary()
        
        var options = [String: AnyObject?]()
        options[String(kSecAttrAccount)] = request.userAccount
        options[String(kSecAttrAccessGroup)] = request.group
        options[String(kSecAttrService)] = request.service
        options[String(kSecAttrSynchronizable)] = request.synchronizable
        options[String(kSecClass)] = request.securityClass.rawValue
        
        if let accessibleMode = request.accessible {
            options[String(kSecAttrAccessible)] = accessibleMode.rawValue
        }
        
        for (key, option) in options {
            parsedRequest.setOptional(option, forKey: key)
        }
        
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
        case .Many, .All:
            dictionary.setObject(kSecMatchLimitAll, forKey: String(kSecMatchLimit))
        }
        
        return dictionary
    }
    
    private class func parseDeleteRequest(request: LocksmithRequest, inDictionary dictionary: NSMutableDictionary) -> NSMutableDictionary {
        return dictionary
    }
}

// MARK: Convenient Class Methods
extension Locksmith {
    public class func saveData(data: [String: AnyObject], forUserAccount userAccount: String, inService service: String = LocksmithDefaultService) throws {
        let saveRequest = LocksmithRequest(userAccount: userAccount, requestType: .Create, data: data, service: service)
        try Locksmith.performRequest(saveRequest)
    }
    
    public class func loadDataForUserAccount(userAccount: String, inService service: String = LocksmithDefaultService) -> [String: AnyObject]? {
        let readRequest = LocksmithRequest(userAccount: userAccount, service: service)
        
        do {
            let dictionary = try Locksmith.performRequest(readRequest)
            return dictionary
        } catch {
            return nil
        }
    }
    
    public class func deleteDataForUserAccount(userAccount: String, inService service: String = LocksmithDefaultService) throws {
        let deleteRequest = LocksmithRequest(userAccount: userAccount, requestType: .Delete, service: service)
        try Locksmith.performRequest(deleteRequest)
    }
    
    public class func updateData(data: [String: AnyObject], forUserAccount userAccount: String, inService service: String = LocksmithDefaultService) throws {
        let updateRequest = LocksmithRequest(userAccount: userAccount, requestType: .Update, data: data, service: service)
        try Locksmith.performRequest(updateRequest)
    }
    
    public class func clearKeychain() throws {
        // Delete all of the keychain data of the given class
        func deleteDataForSecClass(secClass: CFTypeRef) throws {
            let request = NSMutableDictionary()
            request.setObject(secClass, forKey: String(kSecClass))
            
            let status: OSStatus? = SecItemDelete(request as CFDictionaryRef)
            
            if let status = status {
                let statusCode = Int(status)
                if let error = LocksmithError(fromStatusCode: statusCode) {
                    throw error
                }
            }
        }
        
        // For each of the sec class types, delete all of the saved items of that type
        let classes = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        
        for classType in classes {
            do {
                try deleteDataForSecClass(classType)
            } catch let error as LocksmithError {
                // There was an error
                // If the error indicates that there was no item with that security class, that's fine.
                // Some of the sec classes will have nothing in them in most cases.
                if error != LocksmithError.NotFound {
                    throw LocksmithError.UnableToClear
                }
            }
        }
    }
    
    /// Returns all the data for a given service.
    /// :param: service The service to load data for. This may be omitted, and the default service will be used.
    /// :return: An array of dictionaries corresponding to all of the results for this service.
    public class func loadAllDataForService(service: String = LocksmithDefaultService) throws -> [[String: AnyObject]]? {
        var resultForAllSecurityClasses = [[String: AnyObject]?]()
        
        // TODO: Switch to `allClasses`
        let classes = [SecurityClass.GenericPassword]
        
        for classType in classes {
            let request = LocksmithRequest(userAccount: nil, service: "myService")
            request.matchLimit = .All
            request.securityClass = classType
            
            if let result = try Locksmith.performRequest(request) {
                let array = result[LocksmithMultipleResultsKey] as? [[String: AnyObject]]
                array?.forEach({ (dict) -> () in
                    resultForAllSecurityClasses.append(dict)
                })
            }
        }
        
        return resultForAllSecurityClasses.flatMap{ $0 }
    }
}

// MARK: Dictionary Extension
extension NSMutableDictionary {
    func setOptional(optional: AnyObject?, forKey key: NSCopying) {
        if let object: AnyObject = optional {
            self.setObject(object, forKey: key)
        }
    }
}
