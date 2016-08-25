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
            try Locksmith.deleteDataForUserAccount(userAccount: userAccount, inService: service)
            try Locksmith.deleteDataForUserAccount(userAccount: userAccount)
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
        try! Locksmith.saveData(data: data, forUserAccount: userAccount, inService: service)
        
        let loaded = Locksmith.loadDataForUserAccount(userAccount: userAccount, inService: service)! as! TestingDictionaryType
        XCTAssertEqual(loaded, data)
        
        try! Locksmith.deleteDataForUserAccount(userAccount: userAccount, inService: service)
        
        let otherData: TestingDictionaryType = ["something": "way different"]
        try! Locksmith.saveData(data: otherData, forUserAccount: userAccount, inService: service)
        
        let loadedAgain = Locksmith.loadDataForUserAccount(userAccount: userAccount, inService: service)! as! TestingDictionaryType
        XCTAssertEqual(loadedAgain, otherData)
        
        let updatedData = ["this update": "brings the ruckus"]
        try! Locksmith.updateData(data: updatedData, forUserAccount: userAccount, inService: service)
        
        let loaded3 = Locksmith.loadDataForUserAccount(userAccount: userAccount, inService: service)! as! TestingDictionaryType
        
        XCTAssertEqual(loaded3, updatedData)
        
        try! Locksmith.deleteDataForUserAccount(userAccount: userAccount, inService: service)
        
        try! Locksmith.updateData(data: ["some update": "data"], forUserAccount: userAccount, inService: service)
        let updateResult = Locksmith.loadDataForUserAccount(userAccount: userAccount, inService: service)! as! [String: String]
        XCTAssertEqual(updateResult, ["some update": "data"])
    }
    
    func testStaticMethodsForDefaultService() {
        let data = ["some": "data"]
        try! Locksmith.saveData(data: data, forUserAccount: userAccount)
        
        let loaded = Locksmith.loadDataForUserAccount(userAccount: userAccount)! as! TestingDictionaryType
        XCTAssertEqual(loaded, data)
        
        try! Locksmith.deleteDataForUserAccount(userAccount: userAccount)
        
        let otherData: TestingDictionaryType = ["something": "way different"]
        try! Locksmith.saveData(data: otherData, forUserAccount: userAccount)
        
        let loadedAgain = Locksmith.loadDataForUserAccount(userAccount: userAccount)! as! TestingDictionaryType
        XCTAssertEqual(loadedAgain, otherData)
        
        let updatedData = ["this update": "brings the ruckus"]
        try! Locksmith.updateData(data: updatedData, forUserAccount: userAccount)
        
        let loaded3 = Locksmith.loadDataForUserAccount(userAccount: userAccount)! as! TestingDictionaryType
        
        XCTAssertEqual(loaded3, updatedData)
    }
    
    func createGenericPasswordWithData(_ data: [String: Any]) {
        struct CreateGenericPassword: CreateableSecureStorable, GenericPasswordSecureStorable {
            let data: [String: Any]
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
    
    func testUpdateCreatesIfNotExists() {
        let data = ["some": "data"]
        
        struct CreateGenericPassword: CreateableSecureStorable, GenericPasswordSecureStorable, ReadableSecureStorable {
            var data: [String: Any]
            let account: String
            let service: String
        }
        
        let update = CreateGenericPassword(data: data, account: userAccount, service: service)
        try! update.updateInSecureStore()
        
        let read = update.readFromSecureStore()!.data as! [String: String]
        XCTAssertEqual(read, ["some": "data"])
    }
    
    func testUpdateForGenericPassword() {
        let data = ["some": "data"]
        
        struct CreateGenericPassword: CreateableSecureStorable, GenericPasswordSecureStorable, ReadableSecureStorable {
            var data: [String: Any]
            let account: String
            let service: String
        }
        
        var create = CreateGenericPassword(data: data, account: userAccount, service: service)
        try! create.createInSecureStore() // make sure it doesn't throw
        create.data = ["other": "data"]
        try! create.updateInSecureStore()
        
        let read = create.readFromSecureStore()!.data as! [String: String]
        XCTAssertEqual(read, ["other": "data"])
    }
    
    func testLoadForGenericPassword() {
        let data = ["one": "two"]
        createGenericPasswordWithData(data)
        
        struct ReadGenericPassword: ReadableSecureStorable, GenericPasswordSecureStorable {
            let account: String
            let service: String
        }
        
        let read = ReadGenericPassword(account: userAccount, service: service)
        let actual = read.readFromSecureStore()!.data as! TestingDictionaryType
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
        
        let d = Locksmith.loadDataForUserAccount(userAccount: userAccount, inService: service)
        XCTAssertNil(d)
    }
    
    func testForConformanceToAll3Protocols() {
        struct Omnivore: ReadableSecureStorable, CreateableSecureStorable, DeleteableSecureStorable, GenericPasswordSecureStorable {
            let account: String
            let service: String
            let data: [String: Any]
        }
        
        let data: [String: String] = ["something": "else"]
        let omni = Omnivore(account: userAccount, service: service, data: data)
        
        try! omni.createInSecureStore()
        
        let result = omni.readFromSecureStore()
        let resultData = result?.data as! [String: String]

        XCTAssertEqual(result?.account, userAccount)
        XCTAssertEqual(result?.service, service)
        XCTAssertEqual(resultData, data)
        
        try! omni.deleteFromSecureStore()
        
        let noResult = omni.readFromSecureStore()
        XCTAssertNil(noResult?.service)
        
        try! omni.createInSecureStore()
        XCTAssertEqual(result?.account, userAccount)
        XCTAssertEqual(result?.service, service)
        XCTAssertEqual(resultData, data)
    }
    
    func testDeleteForInternetPassword() {
        struct Create : CreateableSecureStorable, InternetPasswordSecureStorable {
            let account: String
            let server: String
            let data: [String: Any]
            let port: Int
            let internetProtocol: LocksmithInternetProtocol
            let authenticationType: LocksmithInternetAuthenticationType
        }
        
        let server = "server"
        let initialData = ["one": "two"]
        let port = 8080
        let internetProtocol = LocksmithInternetProtocol.https
        let authenticationType = LocksmithInternetAuthenticationType.dpa
        
        struct Delete: DeleteableSecureStorable, InternetPasswordSecureStorable {
            let account: String
            let server: String
            let port: Int
            let internetProtocol: LocksmithInternetProtocol
            let authenticationType: LocksmithInternetAuthenticationType
        }

        struct Read: ReadableSecureStorable, InternetPasswordSecureStorable {
            let account: String
            let server: String
            let port: Int
            let internetProtocol: LocksmithInternetProtocol
            let authenticationType: LocksmithInternetAuthenticationType
        }
        
        let c = Create(account: userAccount, server: server, data: initialData, port: port, internetProtocol: internetProtocol, authenticationType: authenticationType)
        try! c.createInSecureStore()
        let r1 = Read(account: userAccount, server: server, port: port, internetProtocol: internetProtocol, authenticationType: authenticationType)
        let result1 = r1.readFromSecureStore()
        XCTAssertEqual(result1?.server, server)

        let d = Delete(account: userAccount, server: server, port: port, internetProtocol: internetProtocol, authenticationType: authenticationType)
        try! d.deleteFromSecureStore()

        let result2 = r1.readFromSecureStore()
        XCTAssertNil(result2?.server)
    }
    
    func testGenericPasswordMetaAttributesAreCreatedAndReturned() {
        struct Create: CreateableSecureStorable, GenericPasswordSecureStorable {
            let account: String
            let service: String
            let comment: String?
            let description: String?
            let creator: UInt?
            let data: [String: Any]
        }
        
        let initialData = ["one": "two"]
        let creator: UInt = 5
        let comment = "this is a comment"
        let description = "this is the description"
        let c = Create(account: userAccount, service: service, comment: comment, description: description, creator: creator, data: initialData)
        try! c.createInSecureStore()
        
        struct Read: ReadableSecureStorable, GenericPasswordSecureStorable {
            let account: String
            let service: String
        }
        
        let r = Read(account: userAccount, service: service)
        let d = r.readFromSecureStore()
        
        XCTAssertEqual(d?.account, userAccount)
        XCTAssertEqual(d?.service, service)
        XCTAssertEqual(d!.data as! [String: String], initialData)
        XCTAssertEqual(d?.creator, creator)
        XCTAssertEqual(d?.comment, comment)
        XCTAssertEqual(d?.description, description)
        
        XCTAssertNil(d?.generic)
        XCTAssertNil(d?.isInvisible)
    }
    
    func testInternetPasswordMetaAttributesAreCreatedAndReturned() {
        struct CreateInternetPassword: CreateableSecureStorable, InternetPasswordSecureStorable {
            let account: String
            var data: [String: Any]
            let server: String
            let port: Int
            let internetProtocol: LocksmithInternetProtocol
            let authenticationType: LocksmithInternetAuthenticationType
            let path: String?
            let securityDomain: String?
        }
        
        let userAccount = "user \(Date())"
        let initialData = ["internet": "data"]
        let server = "net.matthewpalmer"
        let port = 8080
        let internetProtocol = LocksmithInternetProtocol.ftp
        let authenticationType = LocksmithInternetAuthenticationType.httpBasic
        let path = "somePath"
        let securityDomain = "someDomain"
        
        struct ReadInternetPassword: ReadableSecureStorable, InternetPasswordSecureStorable {
            let account: String
            let server: String
            let port: Int
            let internetProtocol: LocksmithInternetProtocol
            let authenticationType: LocksmithInternetAuthenticationType
        }
        
        var c = CreateInternetPassword(account: userAccount, data: initialData, server: server, port: port, internetProtocol: internetProtocol, authenticationType: authenticationType, path: path, securityDomain: securityDomain)
        try! c.createInSecureStore()

        func assertResultMetadataIsOk(_ result: InternetPasswordSecureStorableResultType?) {
            XCTAssertEqual(result?.account, userAccount)
            XCTAssertEqual(result?.server, server)
            XCTAssertEqual(result?.port, port)
            XCTAssertEqual(result?.internetProtocol, internetProtocol)
            XCTAssertEqual(result?.authenticationType, authenticationType)
            XCTAssertEqual(result?.securityDomain, securityDomain)
            XCTAssertEqual(result?.path, path)
        }
        
        let r = ReadInternetPassword(account: userAccount, server: server, port: port, internetProtocol: internetProtocol, authenticationType: authenticationType)
        let result = r.readFromSecureStore()
        XCTAssertEqual(result!.data as! [String: String], initialData)
        assertResultMetadataIsOk(result)
        
        // Assert that metadata is maintained after an update
        c.data = ["other internet": "junk"]
        try! c.updateInSecureStore()
        
        let result2 = r.readFromSecureStore()
        XCTAssertEqual(result2!.data as! [String: String], ["other internet": "junk"])
        assertResultMetadataIsOk(result2)
    }
    
    func assertStringPairsMatchInDictionary(_ dictionary: NSDictionary, pairs: [(key: CFString, expectedOutput: String)]) {
        for pair in pairs {
            let a = dictionary[String(pair.0)] as! CFString
            XCTAssertEqual(a as String, pair.1)
        }
    }
    
    func testInternetPasswordAttributesAreAppliedForConformingTypes() {
        struct CreateInternetPassword: CreateableSecureStorable, InternetPasswordSecureStorable, DeleteableSecureStorable {
            let account: String
            let service: String
            let data: [String: Any]
            let server: String
            let port: Int
            let internetProtocol: LocksmithInternetProtocol
            let authenticationType: LocksmithInternetAuthenticationType
            let path: String?
            let securityDomain: String?
            let performCreateRequestClosure: PerformRequestClosureType
        }
        
        let account = "myUser"
        let port = 8080
        let internetProtocol = LocksmithInternetProtocol.http
        let authenticationType = LocksmithInternetAuthenticationType.httpBasic
        let path = "some_path"
        let securityDomain = "secdomain"
        let data = ["some": "data"]
        let server = "server"
        
        let expect = expectation(description: "Must enter the closure")
        
        let performRequestClosure: PerformRequestClosureType = { (requestReference, result) in
            let dict = requestReference as NSDictionary
            
            self.assertStringPairsMatchInDictionary(dict, pairs: [
                (kSecAttrAccount, account),
                (kSecAttrProtocol, internetProtocol.rawValue),
                (kSecAttrAuthenticationType, authenticationType.rawValue),
                (kSecAttrPath, path),
                (kSecAttrSecurityDomain, securityDomain),
                (kSecAttrServer, server),
                (kSecClass, String(kSecClassInternetPassword))
                ])
            
            let p = dict[String(kSecAttrPort)] as! CFNumber
            XCTAssertEqual(p as Int, port)
            
            expect.fulfill()
            
            return errSecSuccess
        }
        
        let create = CreateInternetPassword(account: account, service: service, data: data, server: server, port: port, internetProtocol: internetProtocol, authenticationType: authenticationType, path: path, securityDomain: securityDomain, performCreateRequestClosure: performRequestClosure)
        do { try create.deleteFromSecureStore() } catch {}
        try! create.createInSecureStore()
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testGenericPasswordOptionalAttributesAreAppliedForConformingTypes() {
        struct CreateGenericPassword: CreateableSecureStorable, GenericPasswordSecureStorable {
            let data: [String: Any]
            let account: String
            let service: String
            let accessGroup: String?
            let description: String?
            let creator: UInt?
            var performCreateRequestClosure: PerformRequestClosureType
            let accessible: LocksmithAccessibleOption?
            let comment: String?
            let type: UInt?
            let isInvisible: Bool?
            let isNegative: Bool?
            let generic: Data?
        }
        
        let data: [String: Any] = ["some": "data"]
        let account: String = "myUser"
        let service: String = "myService"
        let accessGroup: String = "myAccessGroup"
        let description: String = "myDescription"
        let creator: UInt = 5
        let accessible: LocksmithAccessibleOption = LocksmithAccessibleOption.always
        let comment: String = "myComment"
        let type: UInt = 10
        let isInvisible: Bool = false
        let isNegative: Bool = false
        let generic: Data = Data()
        
        let expect = expectation(description: "Must enter the closure")
        
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
            
            let cr = dict[String(kSecAttrCreator)] as! CFNumber
            XCTAssertEqual(cr as UInt, creator)
            
            let ty = dict[String(kSecAttrType)] as! CFNumber
            XCTAssertEqual(ty as UInt, type)
            
            let inv = dict[String(kSecAttrIsInvisible)] as! CFBoolean
            XCTAssertEqual(inv as Bool, isInvisible)
            
            let neg = dict[String(kSecAttrIsNegative)] as! CFBoolean
            XCTAssertEqual(neg as Bool, isNegative)
            
            let gen = dict[String(kSecAttrGeneric)]
            XCTAssertNil(gen)
            
            expect.fulfill()
            
            return errSecSuccess
        }
        
        let create: CreateGenericPassword = CreateGenericPassword(data: data, account: account, service: service, accessGroup: accessGroup, description: description, creator: creator, performCreateRequestClosure: performRequestClosure, accessible: accessible, comment: comment, type: type, isInvisible: isInvisible, isNegative: isNegative, generic: generic)
        
        try! create.createInSecureStore()

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
