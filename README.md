# Locksmith

A sane way to work with the iOS Keychain in Swift.

[![CI Status](http://img.shields.io/travis/matthewpalmer/Locksmith.svg?style=flat)](https://travis-ci.org/matthewpalmer/Locksmith)
[![Version](https://img.shields.io/cocoapods/v/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)
[![License](https://img.shields.io/cocoapods/l/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)
[![Platform](https://img.shields.io/cocoapods/p/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)

## Installation

Locksmith is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "Locksmith"


## Quick Start

**Save Data**

```swift
Locksmith.saveData(["some key": "some value"], inService: "myService", forUserAccount: "myUserAccount")
```

**Load Data**

```swift
let (dictionary, error) = Locksmith.loadData(inService: "myService", forUserAccount: "myUserAccount")
```

**Update Data**

```swift
Locksmith.updateData(["some key": "another value"], inService: "myService", forUserAccount: "myUserAccount")
```

**Delete Data**
```swift
Locksmith.deleteData(inService: "myService", forUserAccount: "myUserAccount")
```

## Custom Requests
To create custom keychain requests, you first have to instantiate a `LocksmithRequest`. This request can be customised as much as required. Then call`Locksmith.performRequest` on that request.

**Saving**
```swift
let saveRequest = LocksmithRequest(service: service, userAccount: userAccount, data: ["some key": "some value"])
// Customize the request
saveRequest.synchronizable = true
Locksmith.performRequest(saveRequest)
```

**Reading**
```swift
let readRequest = LocksmithRequest(service: service, userAccount: userAccount)
let (dictionary, error) = Locksmith.performRequest(readRequest)
```

**Deleting**
```swift
let deleteRequest = LocksmithRequest(service: service, userAccount: userAccount, requestType: .Delete)
Locksmith.performRequest(deleteRequest)
```

## LocksmithRequest
Use these attributes to customize your `LocksmithRequest` instance.

If you need any more custom attributes, either create a pull request or open an issue.

**Required**
```swift
var service: String
var userAccount: String
var type: RequestType             // Defaults to .Read
```

**Optional**
```swift
var group: String?                // Used for keychain sharing
var data: NSDictionary?           // Used only for write requests
var matchLimit: MatchLimit        // Defaults to .One
var securityClass: SecurityClass  // Defaults to .GenericPassword
var synchronizable: Bool          // Defaults to false
```

## Author

[Matthew Palmer](http://matthewpalmer.net), matt@matthewpalmer.net

## License

Locksmith is available under the MIT license. See the LICENSE file for more info.
