//
//  User.swift
//
//  Created by Sam Kington on 27/01/2016.
//  Copyright © 2016 \(work). All rights reserved.
//

class User: ReadableSecureStorable,
            CreateableSecureStorable,
            DeleteableSecureStorable,
            GenericPasswordSecureStorable
{
    // MARK: Properties
    var username: String?
    var password: String?

    // Locksmith protocol properties
    let service = "Work thing"
    let account = "Default work thing login details"
    var data: [String: AnyObject] {
        get {
            return ["username": username!, "password": password!]
        }
        set(keychainData) {
            self.username = keychainData["username"] as? String
            self.password = keychainData["password"] as? String
        }
    }

    // MARK: Initialiser
    init() { }
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    func fetch() -> User? {
        guard let result = self.readFromSecureStore() else { return nil }
        let newUser = User()
        newUser.data = result.data!
        return newUser
    }
    
    func store() -> Bool {
        do { try self.createInSecureStore() }
        catch let error { print("Couldn't store: \(error)"); return false }
        return true
    }
    
    func delete() -> Bool {
        do { try self.deleteFromSecureStore() }
        catch let error { print("Couldn't delete: \(error)"); return false }
        return true
    }
}
