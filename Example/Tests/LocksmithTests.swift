//
//  LocksmithTests.swift
//  LocksmithTests
//
//  Created by Matthew Palmer on 27/06/2015.
//  Copyright © 2015 Matthew Palmer. All rights reserved.
//

import XCTest
import Locksmith

class LocksmithTests: XCTestCase {
    let userAccount = "myUser"
    let service = "myService"
    
    typealias TestingDictionaryType = [String: String]
    
    func clear() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount, inService: service)
            try Locksmith.deleteDataForUserAccount(userAccount)
        } catch {
            // no-op
        }
    }
    
    override func setUp() {
        clear()
    }
    
    override func tearDown() {
        clear()
    }
    
    func testStaticMethods() {
        let data = ["some": "data"]
        try! Locksmith.saveData(data, forUserAccount: userAccount, inService: service)
        
        let loaded = Locksmith.loadDataForUserAccount(userAccount, inService: service)! as! TestingDictionaryType
        XCTAssertEqual(loaded, data)
        
        try! Locksmith.deleteDataForUserAccount(userAccount, inService: service)
        
        let otherData: TestingDictionaryType = ["something": "way different"]
        try! Locksmith.saveData(otherData, forUserAccount: userAccount, inService: service)
        
        let loadedAgain = Locksmith.loadDataForUserAccount(userAccount, inService: service)! as! TestingDictionaryType
        XCTAssertEqual(loadedAgain, otherData)
        
        let updatedData = ["this update": "brings the ruckus"]
        try! Locksmith.updateData(updatedData, forUserAccount: userAccount, inService: service)
        
        let loaded3 = Locksmith.loadDataForUserAccount(userAccount, inService: service)! as! TestingDictionaryType
        
        XCTAssertEqual(loaded3, updatedData)
    }
    
    func testStaticMethodsForDefaultService() {
        let data = ["some": "data"]
        try! Locksmith.saveData(data, forUserAccount: userAccount)
        
        let loaded = Locksmith.loadDataForUserAccount(userAccount)! as! TestingDictionaryType
        XCTAssertEqual(loaded, data)
        
        try! Locksmith.deleteDataForUserAccount(userAccount)
        
        let otherData: TestingDictionaryType = ["something": "way different"]
        try! Locksmith.saveData(otherData, forUserAccount: userAccount)
        
        let loadedAgain = Locksmith.loadDataForUserAccount(userAccount)! as! TestingDictionaryType
        XCTAssertEqual(loadedAgain, otherData)
        
        let updatedData = ["this update": "brings the ruckus"]
        try! Locksmith.updateData(updatedData, forUserAccount: userAccount)
        
        let loaded3 = Locksmith.loadDataForUserAccount(userAccount)! as! TestingDictionaryType
        
        XCTAssertEqual(loaded3, updatedData)
    }
    
    func createGenericPasswordWithData(data: SecurelyStoredData) {
        struct CreateGenericPassword: CreateableSecureStorable, GenericPasswordSecureStorable {
            let data: SecurelyStoredData
            let account: String
            let service: String
        }
        
        let create = CreateGenericPassword(data: data, account: userAccount, service: service)
        try! create.createInSecureStore() // make sure it doesn't throw
    }
    
    func testCreateForGenericPassword() {
        let data = ["some": "data"]
        createGenericPasswordWithData(data)
    }
    
    func testLoadForGenericPassword() {
        let data = ["one": "two"]
        createGenericPasswordWithData(data)
        
        struct ReadGenericPassword: ReadableSecureStorable, GenericPasswordSecureStorable {
            let account: String
            let service: String
        }
        
        let read = ReadGenericPassword(account: userAccount, service: service)
        let actual = read.readFromSecureStore()! as! TestingDictionaryType
        XCTAssertEqual(actual, data)
    }
    
    func testDeleteForGenericPassword() {
        let initialData = ["one": "two"]
        
        createGenericPasswordWithData(initialData)
        
        struct DeleteGenericPassword: DeleteableSecureStorable, GenericPasswordSecureStorable {
            let account: String
            let service: String
        }
        
        let delete = DeleteGenericPassword(account: userAccount, service: service)
        try! delete.deleteFromSecureStore()
        
        let d = Locksmith.loadDataForUserAccount(userAccount, inService: service)
        XCTAssert(d == nil)
    }
    
    func assertStringPairsMatchInDictionary(dictionary: NSDictionary, pairs: [(key: CFString, expectedOutput: String)]) {
        for pair in pairs {
            let a = dictionary[String(pair.0)] as! CFStringRef
            XCTAssertEqual(a as String, pair.1)
        }
    }
    
    func testInternetPasswordAttributesAreAppliedForConformingTypes() {
        struct CreateInternetPassword: CreateableSecureStorable, InternetPasswordSecureStorable {
            let account: String
            let service: String
            let data: SecurelyStoredData
            let server: String
            let port: String
            let internetProtocol: LocksmithInternetProtocol
            let authenticationType: LocksmithInternetAuthenticationType
            let path: String?
            let securityDomain: String?
            
            let performRequestClosure: PerformRequestClosureType
        }
        
        let account = "myUser"
        let port = "8080"
        let internetProtocol = LocksmithInternetProtocol.HTTP
        let authenticationType = LocksmithInternetAuthenticationType.HTTPBasic
        let path = "some_path"
        let securityDomain = "secdomain"
        let data = ["some": "data"]
        let server = "server"
        
        let performRequestClosure: PerformRequestClosureType = { (requestReference, result) in
            let dict = requestReference as NSDictionary
            
            self.assertStringPairsMatchInDictionary(dict, pairs: [
                (kSecAttrAccount, account),
                (kSecAttrPort, port),
                (kSecAttrProtocol, internetProtocol.rawValue),
                (kSecAttrAuthenticationType, authenticationType.rawValue),
                (kSecAttrPath, path),
                (kSecAttrSecurityDomain, securityDomain),
                (kSecAttrServer, server),
                (kSecClass, String(kSecClassInternetPassword))
                ])
            
            return errSecSuccess
        }
        
        let create = CreateInternetPassword(account: account, service: service, data: data, server: server, port: port, internetProtocol: internetProtocol, authenticationType: authenticationType, path: path, securityDomain: securityDomain, performRequestClosure: performRequestClosure)
        try! create.createInSecureStore()
    }
    
    func testGenericPasswordOptionalAttributesAreAppliedForConformingTypes() {
        struct CreateGenericPassword: CreateableSecureStorable, GenericPasswordSecureStorable {
            let data: SecurelyStoredData
            let account: String
            let service: String
            let accessGroup: String?
            let description: String?
            let creationDate: NSDate?
            let creator: UInt?
            var performRequestClosure: PerformRequestClosureType
            let accessible: LocksmithAccessibleOption?
            let modificationDate: NSDate?
            let comment: String?
            let type: UInt?
            let isInvisible: Bool?
            let isNegative: Bool?
            let generic: NSData?
        }
        
        let data: SecurelyStoredData = ["some": "data"]
        let account: String = "myUser"
        let service: String = "myService"
        let accessGroup: String = "myAccessGroup"
        let description: String = "myDescription"
        let creationDate: NSDate = NSDate()
        let creator: UInt = 5
        let accessible: LocksmithAccessibleOption = LocksmithAccessibleOption.Always
        let modificationDate: NSDate = NSDate()
        let comment: String = "myComment"
        let type: UInt = 10
        let isInvisible: Bool = false
        let isNegative: Bool = false
        let generic: NSData = NSData()
        
        let performRequestClosure: PerformRequestClosureType = { (requestReference, result) in
            let dict = requestReference as NSDictionary
            
            self.assertStringPairsMatchInDictionary(dict, pairs: [
                (kSecAttrAccount, account),
                (kSecAttrService, service),
                (kSecAttrAccessGroup, accessGroup),
                (kSecAttrDescription, description),
                (kSecAttrComment, comment),
                (kSecAttrAccessible, accessible.rawValue),
                (kSecClass, String(kSecClassGenericPassword))
                ])
            
            let created = dict[String(kSecAttrCreationDate)] as! CFDateRef
            XCTAssertEqual(created, creationDate)
            
            let modified = dict[String(kSecAttrModificationDate)] as! CFDateRef
            XCTAssertEqual(modified, modificationDate)
            
            let cr = dict[String(kSecAttrCreator)] as! CFNumberRef
            XCTAssertEqual(cr as UInt, creator)
            
            let ty = dict[String(kSecAttrType)] as! CFNumberRef
            XCTAssertEqual(ty as UInt, type)
            
            let inv = dict[String(kSecAttrIsInvisible)] as! CFBooleanRef
            XCTAssertEqual(inv as Bool, isInvisible)
            
            let neg = dict[String(kSecAttrIsNegative)] as! CFBooleanRef
            XCTAssertEqual(neg as Bool, isNegative)
            
            let gen = dict[String(kSecAttrGeneric)] as! CFDataRef
            XCTAssertEqual(gen, generic)
            
            return errSecSuccess
        }
        
        let create: CreateGenericPassword = CreateGenericPassword(data: data, account: account, service: service, accessGroup: accessGroup, description: description, creationDate: creationDate, creator: creator, performRequestClosure: performRequestClosure, accessible: accessible, modificationDate: modificationDate, comment: comment, type: type, isInvisible: isInvisible, isNegative: isNegative, generic: generic)
        
        try! create.createInSecureStore()
    }
}
