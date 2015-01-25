//
//  LocksmithTests.swift
//  LocksmithTests
//
//  Copyright (c) 2014 Mathew Palmer. All rights reserved.
//

import UIKit
import XCTest
import Locksmith

class LocksmithTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Locksmith.clearKeychain()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // public class func saveData(data: Dictionary<String, String>, inService service: String, forUserAccount userAccount: String) -> NSError?
    func testSaveData_Once() {
        var error = Locksmith.saveData(["key": "value"], inService: "myService", forUserAccount: "myUserAccount")
        XCTAssert(error == nil, "❌: saving data")
    }
    
    func testSaveData_Multiple() {
        var errors: [NSError?] = []
        for i in 0...10 {
            errors.append(Locksmith.saveData(["key": "value \(i)"], inService: "myService", forUserAccount: "myAccount\(i)"))
        }
        XCTAssert(errors.filter({ $0 != nil }).isEmpty, "❌: saving multiple items")
    }
    
    func testSaveData_Duplicate() {
        // Should be successful
        let error1 = Locksmith.saveData(["key": "value"], inService: "myService", forUserAccount: "user")
        
        // Should fail
        let error2 = Locksmith.saveData(["key": "value"], inService: "myService", forUserAccount: "user")
        
        XCTAssert(error1 == nil && error2 != nil, "❌: saving duplicate data")
    }
    
    // Setup the keychain for requests that use pre-existing values on the keychain (update, read, delete)
    func setupLoads() {
        Locksmith.saveData(["key": "value"], inService: "myService", forUserAccount: "user1")
        Locksmith.saveData(["anotherkey": "anothervalue"], inService: "myService", forUserAccount: "user2")
        Locksmith.saveData(["word": "definition"], inService: "myService", forUserAccount: "user3")
    }
    
    // public class func loadDataInService(service: String, forUserAccount userAccount: String) -> (NSDictionary?, NSError?)
    func testLoadData_Once() {
        setupLoads()
        
        let (dictionary, error) = Locksmith.loadDataInService("myService", forUserAccount: "user1")
        XCTAssert(dictionary!.valueForKey("key")! as NSString == "value" && error == nil, "❌: loading one item")
    }
    
    func testLoadData_Multiple() {
        setupLoads()
        
        let (dictionary, error) = Locksmith.loadDataInService("myService", forUserAccount: "user1")
        let (dictionary2, error2) = Locksmith.loadDataInService("myService", forUserAccount: "user2")
        let (dictionary3, error3) = Locksmith.loadDataInService("myService", forUserAccount: "user3")
        
        XCTAssert(dictionary!.valueForKey("key")! as NSString == "value" && error == nil, "❌: loading multiple items")
        XCTAssert(dictionary2!.valueForKey("anotherkey")! as NSString == "anothervalue" && error == nil, "❌: loading multiple items")
        XCTAssert(dictionary3!.valueForKey("word")! as NSString == "definition" && error == nil, "❌: loading multiple items")
    }
    
    // public class func updateData(data: Dictionary<String, String>, inService service: String, forUserAccount userAccount: String) -> NSError?
    func testUpdateData() {
        setupLoads()
        
        let error = Locksmith.updateData(["key": "newvalue"], inService: "myService", forUserAccount: "user1")
        let (dictionary, err) = Locksmith.loadDataInService("myService", forUserAccount: "user1")
        XCTAssert(dictionary!.valueForKey("key")! as NSString == "newvalue" && error == nil, "❌: updating item")
        
        // Updating an item that doesn't exist should create that item (i.e. performs a regular create request)
        let error2 = Locksmith.updateData(["key": "anothervalue"], inService: "myService", forUserAccount: "user1")
        XCTAssert(error2 == nil, "❌: updating item that doesn't exist")
    }
    
    // public class func deleteDataInService(service: String, forUserAccount userAccount: String) -> NSError?
    func testDeleteData() {
        setupLoads()
        
        let error = Locksmith.deleteDataInService("myService", forUserAccount: "user1")
        XCTAssert(error == nil, "❌: deleting existing item")
        
        let error2 = Locksmith.deleteDataInService("myService", forUserAccount: "user1")
        XCTAssert(error2 != nil, "❌: deleting non existent item")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}