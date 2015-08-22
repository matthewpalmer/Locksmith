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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try! Locksmith.clearKeychain()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveData_Once() {
        try! Locksmith.saveData(["key": "value"], forUserAccount: "myUserAccount")
    }
    
    func testSaveData_Multiple() {
        for i in 0...10 {
            try! Locksmith.saveData(["key": "value \(i)"], forUserAccount: "myAccount\(i)", inService: "myService")
        }
    }
    
    func testSaveData_Duplicate() {
        // Should be successful
        try! Locksmith.saveData(["key": "value"], forUserAccount: "user", inService: "myService")
        
        // Should fail
        do {
            try Locksmith.saveData(["key": "value"], forUserAccount: "user", inService: "myService")
        } catch {
            XCTAssert(true)
        }
    }
    
    // Setup the keychain for requests that use pre-existing values on the keychain (update, read, delete)
    func setupLoads() {
        try! Locksmith.saveData(["key": "value"], forUserAccount: "user1", inService: "myService")
        try! Locksmith.saveData(["anotherkey": "anothervalue"], forUserAccount: "user2", inService: "myService")
        try! Locksmith.saveData(["word": "definition"], forUserAccount: "user3", inService: "myService")
    }
    
    func testLoadData_Once() {
        setupLoads()
        let dictionary = Locksmith.loadDataForUserAccount("user1", inService: "myService")
        XCTAssert(dictionary!.valueForKey("key") as! NSString == "value", "❌: loading one item")
    }
    
    func testLoadData_Multiple() {
        setupLoads()
        
        do {
            let dictionary = Locksmith.loadDataForUserAccount("user1", inService: "myService")
            let dictionary2 = Locksmith.loadDataForUserAccount("user2", inService: "myService")
            let dictionary3 = Locksmith.loadDataForUserAccount("user3", inService: "myService")
            
            XCTAssert(dictionary!.valueForKey("key") as! NSString == "value", "❌: loading multiple items")
            XCTAssert(dictionary2!.valueForKey("anotherkey") as! NSString == "anothervalue", "❌: loading multiple items")
            XCTAssert(dictionary3!.valueForKey("word") as! NSString == "definition", "❌: loading multiple items")
        } catch {
            XCTAssert(false)
        }
    }
    
    func testUpdateData() {
        setupLoads()
        
        try! Locksmith.updateData(["key": "newvalue"], forUserAccount: "user1", inService: "myService")
        let dictionary = Locksmith.loadDataForUserAccount("user1", inService: "myService")
        
        XCTAssert(dictionary!.valueForKey("key") as! NSString == "newvalue", "❌: updating item")
        
        // Updating an item that doesn't exist should create that item (i.e. performs a regular create request)
        try! Locksmith.updateData(["key": "anothervalue"], forUserAccount: "user1", inService: "myService")
        XCTAssert(true, "❌: updating item that doesn't exist")
    }
    
    func testDeleteData() {
        setupLoads()
        
        try! Locksmith.deleteDataForUserAccount("user1", inService: "myService")
        XCTAssert(true, "❌: deleting existing item")
        
        do {
            // Should fail
            try Locksmith.deleteDataForUserAccount("user1", inService: "myService")
            XCTAssert(false, "❌: did not throw error on deleting non existent item")
        } catch {
            XCTAssert(true, "❌: deleting non existent item")
        }
        
    }
}
