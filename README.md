# Locksmith

A sane way to work with the iOS Keychain in Swift.

<!--[![CI Status](http://img.shields.io/travis/matthewpalmer/Locksmith.svg?style=flat)](https://travis-ci.org/matthewpalmer/Locksmith)-->
[![Version](https://img.shields.io/cocoapods/v/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)
[![Platform](https://img.shields.io/cocoapods/p/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)

 
## Installation

### CocoaPods

Locksmith is available through [CocoaPods](http://cocoapods.org). To install
Locksmith for Swift 2, simply add the following line to your Podfile:

    pod 'Locksmith', :git => 'https://github.com/matthewpalmer/Locksmith.git', :branch => '2.0'

Swift 2 support is available via the `2.0` branch.

### Manual

Alternatively, you can simply drag the two files `Locksmith.swift` and `LocksmithRequest.swift` into your project.

## Quick Start

In the following examples, you can choose not to provide a value for the `inService` parameter, and it will default to your Bundle Identifier.

**Save data**

```swift
try Locksmith.saveData(["some key": "some value"], forUserAccount: "myUserAccount", inService: "myService")
```

**Load data**

```swift
let dictionary = Locksmith.loadDataForUserAccount("myUserAccount", inService: "myService")
```

**Update data**

```swift
try Locksmith.updateData(["some key": "another value"], forUserAccount: "myUserAccount", inService: "myService")
```

**Delete data**

```swift
try Locksmith.deleteDataForUserAccount("myUserAccount", inService: "myService")
```

## Custom Requests
To create custom keychain requests, you first have to instantiate a `LocksmithRequest`. This request can be customised as much as required. Then call`Locksmith.performRequest` on that request.

**Saving**
```swift
// As above, the `service` parameter will default to your Bundle Identifier if omitted.
let saveRequest = LocksmithRequest(userAccount: userAccount, data: ["some key": "some value"], service: service)
// Customize the request
saveRequest.synchronizable = true
try Locksmith.performRequest(saveRequest)
```

**Reading**
```swift
let readRequest = LocksmithRequest(userAccount: userAccount, service: service)
let dictionary = try Locksmith.performRequest(readRequest)
```

**Deleting**
```swift
let deleteRequest = LocksmithRequest(userAccount: userAccount, requestType: .Delete, service: service)
try Locksmith.performRequest(deleteRequest)
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

## Testing
I can't work out why, but opening `Example/Locksmith.xcworkspace` and trying to run the tests from there won't work. (Pull requests greatly appreciated on this!) Instead, you can run the tests by opening `Locksmith.xcodeproj` in the root directory, and doing Product -> Test.
 
## Author

[Matthew Palmer](http://matthewpalmer.net), matt@matthewpalmer.net

## License

Locksmith is available under the MIT license. See the LICENSE file for more info.
