# Locksmith

> A sane way to work with the iOS Keychain in Swift.

# Usage

Grab two files from the project: Locksmith.swift and LocksmithRequest.swift.

## Quick Start

**Save Data**

    Locksmith.saveData(["some key": "some value"], forKey: key, inService: service, forUserAccount: userAccount)

**Load Data**

    let (dictionary, error) = Locksmith.loadData(forKey: key, inService: service, forUserAccount: userAccount)

**Delete Data**

    Locksmith.deleteData(forKey: key, inService: service, forUserAccount: userAccount)


## Custom Requests
To create custom keychain requests, you first have to instantiate a `LocksmithRequest`. This request can be customised as much as required. Then call`Locksmith.performRequest` on that request.

### Saving

    let saveRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key, data: ["some key": "some value"])
    Locksmith.performRequest(saveRequest)

### Reading

    let readRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key)
    let (dictionary, error) = Locksmith.performRequest(readRequest)

### Deleting

    let deleteRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key, requestType: .Delete)
    Locksmith.performRequest(deleteRequest)

### `LocksmithRequest`
*More to come.*

#### Required
    var service: String
    var key: String
    var userAccount: String
    var type: RequestType  // Defaults to .Read

#### Optional
    var group: String?  // Used for keychain sharing
    var data: NSDictionary?  // Used only for write requests
    var matchLimit: MatchLimit  // Defaults to .One