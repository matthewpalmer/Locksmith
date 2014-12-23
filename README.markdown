# Locksmith

> A sane way to work with the iOS Keychain in Swift.

# Usage

Install the framework ([reference c/o Alamofire](https://github.com/Alamofire/Alamofire))


1. `git submodule add https://github.com/matthewpalmer/Locksmith.git`
2. Open the newly created folder, 'Locksmith', in Finder
3. Drag Locksmith.xcodeproj to the file navigator (left sidebar) of your project
4. Click on your app's target, then click on Build Phases
5. Follow the gif ![Locksmith iOS Keychain Library in Swift](http://i.imgur.com/cwB8tAI.gif)
6. `import Locksmith` wherever you need it

*Note: Due to a bug in Swift, the `Swift Compiler - Code Generation` Optimization Level for release builds has to be set to -Onone. [Go here for more infromation on how to change it.](http://matthewpalmer.net/blog/2014/12/11/change-optimization-level-xcode-swift/)*

## Quick Start

**Save Data**

```swift
Locksmith.saveData(["some key": "some value"], inService: service, forUserAccount: userAccount)
```

**Load Data**

```swift
let (dictionary, error) = Locksmith.loadData(inService: service, forUserAccount: userAccount)
```

**Update Data**

```swift
Locksmith.updateData(["some key": "another value"], inService: service, forUserAccount: userAccount)
```

**Delete Data**
```swift
Locksmith.deleteData(inService: service, forUserAccount: userAccount)
```

## Custom Requests
To create custom keychain requests, you first have to instantiate a `LocksmithRequest`. This request can be customised as much as required. Then call`Locksmith.performRequest` on that request.

### Saving
```swift
let saveRequest = LocksmithRequest(service: service, userAccount: userAccount, data: ["some key": "some value"])
Locksmith.performRequest(saveRequest)
```

### Reading
```swift
let readRequest = LocksmithRequest(service: service, userAccount: userAccount)
let (dictionary, error) = Locksmith.performRequest(readRequest)
```

### Deleting
```swift
let deleteRequest = LocksmithRequest(service: service, userAccount: userAccount, requestType: .Delete)
Locksmith.performRequest(deleteRequest)
```

### `LocksmithRequest`
*More to come.*

#### Required
```swift
var service: String
var userAccount: String
var type: RequestType  // Defaults to .Read
```

#### Optional
```swift
var group: String?  // Used for keychain sharing
var data: NSDictionary?  // Used only for write requests
var matchLimit: MatchLimit  // Defaults to .One
```
