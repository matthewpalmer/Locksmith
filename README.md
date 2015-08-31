<h1><span style='color:red;'>Locksmith</span></h1>

A powerful, protocol-oriented library for working with the iOS Keychain in Swift.

[![Version](https://img.shields.io/cocoapods/v/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)
[![Platform](https://img.shields.io/cocoapods/p/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)

**What makes Locksmith different to other keychain wrappers?**

* Locksmith is both super-simple and deeply powerful
* Provides access to all of the keychain’s metadata in a type-useful way via `ResultType` protocols—save an `NSDate`, get an `NSDate` back (without typecasting!)
* Add functionality to your existing types for free
* Useful enums and Swift-native types

## Installation

### CocoaPods

Locksmith is available through [CocoaPods](http://cocoapods.org). To install
Locksmith for Swift 2, simply add the following line to your Podfile:

    pod 'Locksmith'

> Swift 1.2 support is available via the `1.2` branch.

## Quick start

**Save data**

```swift
try Locksmith.saveData(["some key": "some value"], forUserAccount: "myUserAccount")
```

**Load data**

```swift
let dictionary = Locksmith.loadDataForUserAccount("myUserAccount")
```

**Update data**

```swift
try Locksmith.updateData(["some key": "another value"], forUserAccount: "myUserAccount")
```

**Delete data**

```swift
try Locksmith.deleteDataForUserAccount("myUserAccount")
```

## Power to the protocols

Locksmith has been designed with Swift 2, protocols, and protocol extensions in mind.

Why do this? Because you can add existing functionality to your types with only the slightest changes!

Say we have a Twitter account

```swift
struct TwitterAccount {
  let username: String
  let password: String
}
```

and we want to save it to the keychain as a generic password. All we need to do is conform to the right protocols in Locksmith and we get that functionality for free.

```swift
struct TwitterAccount: CreateableSecureStorable, GenericPasswordSecureStorable {
  let username: String
  let password: String

  // Required by GenericPasswordSecureStorable
  let service = "Twitter"
  var account: String { return username }

  // Required by CreateableSecureStorable
  var data: [String: AnyObject] {
    return ["password": password]
  }
}
```

Then, all we’ve got to do is create the account and save it to the keychain

```swift
let account = TwitterAccount(username: "_matthewpalmer", password: "my_password")
try account.createInSecureStore()
```

Creating, reading, and deleting are done similarly. And the best part?

*You can conform to all three protocols on the same type!*

```swift
struct TwitterAccount: ReadableSecureStorable, CreateableSecureStorable, DeleteableSecureStorable, GenericPasswordSecureStorable {
  let username: String
  let password: String

  let service = "Twitter"
  var account: String { return username }
  var data: [String: AnyObject] {
    return ["password": password]
  }
}

let account = TwitterAccount(username: "_matthewpalmer", password: "my_password")

// CreateableSecureStorable lets us create in the keychain
try account.createInSecureStore()

// ReadableSecureStorable lets us read from the keychain
let result = account.readFromSecureStore()

// DeleteableSecureStorable lets us delete from the keychain
try account.deleteFromSecureStore()
```

So. cool.

### The details

By declaring that your type adopts these protocols—which is what we did above with `struct TwitterAccount: CreateableSecureStorable, ...`—you get a bunch of functionality for free.

I like to think about protocols with extensions in terms of “what you get,” “what you’ve gotta do,” and ”what’s optional.” Most of the stuff under ‘optional’ should only be implemented if you want to change existing functionality.

#### `CreateableSecureStorable`

**What you get**

```swift
// Saves a type to the keychain
func createInSecureStore() throws
```

**Required**

```swift
// The data to save to the keychain
var data: [String: AnyObject] { get }
```

**Optional**

```swift
// Perform the request in this closure
var performCreateRequestClosure: PerformRequestClosureType { get }
```

#### `ReadableSecureStorable`

**What you get**

```swift
// Read from the keychain
func readFromSecureStore() -> SecureStorableResultType?
```

**Required**

> Nothing!

**Optional**

```swift
// Perform the request in this closure
var performReadRequestClosure: PerformRequestClosureType { get }
```

#### `DeleteableSecureStorable`

**What you get**

```swift
// Read from the keychain
func deleteFromSecureStore() throws
```

**Required**

> Nothing!

**Optional**

```swift
// Perform the request in this closure
var performDeleteRequestClosure: PerformRequestClosureType { get }
```

## Powerful support for the Cocoa Keychain

> The coolest part of being protocol oriented

Many wrappers around the keychain have only partial support for the keychain. They usually support only the critical parts, and ignore the rest. This is because there are so many options and variations on the way you can query the keychain that it’s almost impossible to do it reliably, or in a way that is easy for users to adopt.

Locksmith tries to include as much of the keychain as possible, using protocols and protocol extensions to minimize the complexity. You can mix-and-match your generic passwords with your read requests while staying completely type-safe.

Please refer to the [Keychain Services Reference](https://developer.apple.com/library/ios/documentation/Security/Reference/keychainservices/) for full information on what each of the attributes mean and what they can do.

> Certificates, keys, and identities are coming soon—it’s just a matter of translating the `kSec...` constants!

#### `GenericPasswordSecureStorable`

Generic passwords are probably the most common use-case of the keychain, and are great for storing usernames and passwords.

Properties listed under ‘Required’ have to be implemented by any types that conform; those listed under ‘Optional’ can be implemented to add additional information to what is saved or read if desired.

One thing to note: if you implement an optional property, its type annotation must match the type specified in the protocol *exactly*. If you implement `description: String?` it has to be that, and it can’t be `var description: String`.

**Required**

```swift
var service: String { get }
var account: String { get }
```

**Optional**

```swift
var description: String? { get }
var comment: String? { get }
var creator: UInt? { get }
var label: String? { get }
var type: UInt? { get }
var isInvisible: Bool? { get }
var isNegative: Bool? { get }
```

#### `InternetPasswordSecureStorable`

Types that conform to `InternetPasswordSecureStorable` typically come from web services and have certain associated metadata.

**Required**

```swift
var server: String { get }
var port: String { get }
var internetProtocol: LocksmithInternetProtocol { get }
var authenticationType: LocksmithInternetAuthenticationType { get }
```

**Optional**

```swift
var securityDomain: String? { get }
var path: String? { get }
```

## Result types

By adopting a protocol-oriented design from the ground up, Locksmith can provide access to the result of your keychain queries *with type annotations included*—store an `NSDate`, get an `NSDate` back with no type-casting!

Let’s start with an example—the Twitter account from before, except it’s now an `InternetPasswordSecureStorable`, which lets us store a bit more metadata.

```swift
struct TwitterAccount: InternetPasswordSecureStorable, ReadableSecureStorable, CreateableSecureStorable {
  let username: String
  let password: String

  var account: String { return username }
  var data: [String: AnyObject] {
    return ["password": password]
  }

  let server = "com.twitter"
  let port = 80
  let internetProtocol = .HTTPS
  let authenticationType = .HTTPBasic
}

let account = TwitterAccount(username: "_matthewpalmer", password: "my_password")

// Save all this to the keychain
account.createInSecureStore()

// Now let’s get it back
let result: InternetPasswordSecureStorableResultType = account.readFromSecureStore()

result?.port // Gives us an Int directly!
result?.internetProtocol // Gives us a LocksmithInternetProtocol enum case directly!
```

This is *awesome*. No more typecasting.

#### `GenericPasswordSecureStorableResultType`

Everything listed here can be set on a type conforming to `GenericPasswordSecureStorable`, and gotten back from the result returned from `readFromSecureStore()` on that type.

```swift
var service: String { get }
var account: String { get }
var description: String? { get }
var comment: String? { get }
var creator: UInt? { get }
var label: String? { get }
var type: UInt? { get }
var isInvisible: Bool? { get }
var isNegative: Bool? { get }
var generic: NSData? { get }
```

#### `InternetPasswordSecureStorableResultType`

Everything listed here can be set on a type conforming to `InternetPasswordSecureStorable`, and gotten back from the result returned from `readFromSecureStore()` on that type.

```swift
var account: String { get }
var server: String { get }
var port: Int { get }
var internetProtocol: LocksmithInternetProtocol { get }
var authenticationType: LocksmithInternetAuthenticationType { get }
var description: String? { get }
var comment: String? { get }
var creator: UInt? { get }
var type: UInt? { get }
var isInvisible: Bool? { get }
var isNegative: Bool? { get }
var securityDomain: String? { get }
var path: String? { get }
```

## Enumerations

Locksmith provides a bunch of handy enums for configuring your requests, so you can say `kSecGoodByeStringConstants`.

#### `LocksmithAccessibleOption`

`LocksmithAccessibleOption` configures when an item can be accessed—you might require that stuff is available when the device is unlocked, after a passcode has been entered, etc.

```swift
public enum LocksmithAccessibleOption {
  case WhenUnlocked
  case AfterFirstUnlock
  case Always
  case WhenPasscodeSetThisDeviceOnly
  case WhenUnlockedThisDeviceOnly
  case AfterFirstUnlockThisDeviceOnly
  case AlwaysThisDeviceOnly
```

#### `LocksmithError`

`LocksmithError` provides Swift-friendly translations of common keychain error codes. These are thrown from methods throughout the library.

```swift
public enum LocksmithError: ErrorType {
  case Allocate
  case AuthFailed
  case Decode
  case Duplicate
  case InteractionNotAllowed
  case NoError
  case NotAvailable
  case NotFound
  case Param
  case RequestNotSet
  case TypeNotFound
  case UnableToClear
  case Undefined
  case Unimplemented
}
```

#### `LocksmithInternetAuthenticationType`

`LocksmithInternetAuthenticationType` lets you pick out the type of authentication you want to store alongside your `.InternetPassword`s—anything from `.MSN` to `.HTTPDigest`.

```swift
public enum LocksmithInternetAuthenticationType {
  case NTLM
  case MSN
  case DPA
  case RPA
  case HTTPBasic
  case HTTPDigest
  case HTMLForm
  case Default
}
```

#### `LocksmithInternetProtocol`

`LocksmithInternetProtocol` is used with `.InternetPassword` to choose which protocol was used for the interaction with the web service, including `.HTTP`, `.SMB`, and a whole bunch more.

public enum {
  case FTP
  case FTPAccount
  case HTTP
  case IRC
  case NNTP
  case POP3
  case SMTP
  case SOCKS
  case IMAP
  case LDAP
  case AppleTalk
  case AFP
  case Telnet
  case SSH
  case FTPS
  case HTTPS
  case HTTPProxy
  case HTTPSProxy
  case FTPProxy
  case SMB
  case RTSP
  case RTSPProxy
  case DAAP
  case EPPC
  case IPP
  case NNTPS, LDAPS
  case TelnetS
  case IMAPS
  case IRCS
  case POP3S
}
```

## Author

[Matthew Palmer](http://matthewpalmer.net), matt@matthewpalmer.net

## License

Locksmith is available under the MIT license. See the LICENSE file for more info.
