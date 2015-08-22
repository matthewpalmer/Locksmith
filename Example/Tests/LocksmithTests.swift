//
//  LocksmithTests.swift
//  LocksmithTests
//
//  Copyright (c) 2014 Mathew Palmer. All rights reserved.
//

import UIKit
import XCTest
import Locksmith

let myService = "myService"
let sampleData = ["key": "value"]
let myUserAccount = "myUserAccount"

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
    
    func testSaveData_Once() {
        let error = Locksmith.saveData(["key": "value"], forUserAccount: myUserAccount, inService: myService)
        XCTAssert(error == nil, "❌: saving data")
    }
    
    func testSaveData_Multiple() {
        var errors: [NSError?] = []
        for i in 0...10 {
            errors.append(Locksmith.saveData(["key": "value \(i)"], forUserAccount: "myAccount\(i)", inService: "myService"))
        }
        XCTAssert(errors.filter({ $0 != nil }).isEmpty, "❌: saving multiple items")
    }
    
    func testSaveData_Duplicate() {
        // Should be successful
        
        let error1 = Locksmith.saveData(sampleData, forUserAccount: "user", inService: myService)
        
        // Should fail
        let error2 = Locksmith.saveData(sampleData, forUserAccount: "user", inService: "myService")
        
        XCTAssert(error1 == nil && error2 != nil, "❌: saving duplicate data")
    }
    
    // Test using default values for the service
    func testWorkflow_Defaults() {
        let error1 = Locksmith.saveData(sampleData, forUserAccount: "me")
        let error2 = Locksmith.saveData(sampleData, forUserAccount: "me2")
        
        XCTAssert(error1 == nil && error2 == nil, "❌: saving with default service")
        
        let (dict1, err1) = Locksmith.loadDataForUserAccount("me")
        let (dict2, err2) = Locksmith.loadDataForUserAccount("me2")
        
        XCTAssert(dict1 != nil && dict2 != nil && err1 == nil && err2 == nil, "❌: loading with default service")
    }
    
    // Setup the keychain for requests that use pre-existing values on the keychain (update, read, delete)
    func setupLoads() {
        Locksmith.saveData(["key": "value"], forUserAccount: "user1", inService: "myService")
        Locksmith.saveData(["anotherkey": "anothervalue"], forUserAccount: "user2", inService: "myService")
        Locksmith.saveData(["word": "definition"], forUserAccount: "user3", inService: "myService")
    }
    
    // public class func loadDataInService(service: String, forUserAccount userAccount: String) -> (NSDictionary?, NSError?)
    func testLoadData_Once() {
        setupLoads()
        
        let (dictionary, error) = Locksmith.loadDataForUserAccount("user1", inService: "myService")
        XCTAssert(dictionary!.valueForKey("key")! as! NSString == "value" && error == nil, "❌: loading one item")
    }
    
    func testLoadData_Multiple() {
        setupLoads()
        
        let (dictionary, error) = Locksmith.loadDataForUserAccount("user1", inService: "myService")
        let (dictionary2, _) = Locksmith.loadDataForUserAccount("user2", inService: "myService")
        let (dictionary3, _) = Locksmith.loadDataForUserAccount("user3", inService: "myService")
        
        XCTAssert(dictionary!.valueForKey("key")! as! NSString == "value" && error == nil, "❌: loading multiple items")
        XCTAssert(dictionary2!.valueForKey("anotherkey")! as! NSString == "anothervalue" && error == nil, "❌: loading multiple items")
        XCTAssert(dictionary3!.valueForKey("word")! as! NSString == "definition" && error == nil, "❌: loading multiple items")
    }
    
    // public class func updateData(data: Dictionary<String, String>, inService service: String, forUserAccount userAccount: String) -> NSError?
    func testUpdateData() {
        setupLoads()
        
        let error = Locksmith.updateData(["key": "newvalue"], forUserAccount: "user1", inService: "myService")
        let (dictionary, _) = Locksmith.loadDataForUserAccount("user1", inService: "myService")
        XCTAssert(dictionary!.valueForKey("key")! as! NSString == "newvalue" && error == nil, "❌: updating item")
        
        // Updating an item that doesn't exist should create that item (i.e. performs a regular create request)
        let error2 = Locksmith.updateData(["key": "anothervalue"], forUserAccount: "user1", inService: "myService")
        XCTAssert(error2 == nil, "❌: updating item that doesn't exist")
    }
    
    // public class func deleteDataInService(service: String, forUserAccount userAccount: String) -> NSError?
    func testDeleteData() {
        setupLoads()
        
        let error = Locksmith.deleteDataForUserAccount("user1", inService: "myService")
        XCTAssert(error == nil, "❌: deleting existing item")
        
        let error2 = Locksmith.deleteDataForUserAccount("user1", inService: "myService")
        XCTAssert(error2 != nil, "❌: deleting non existent item")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}