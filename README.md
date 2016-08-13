# Locksmith

A powerful, protocol-oriented library for working with the keychain in Swift.

- [x] 📱 iOS 8.0+
- [x] 💻 Mac OS X 10.10+
- [x] ⌚️ watchOS 2
- [x] 📺 tvOS

## Something you might like

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">I made Rocket, an app that gives you Slack-style emoji everywhere on your Mac. <a href="https://t.co/kNfHNxSZcb">https://t.co/kNfHNxSZcb</a> <a href="https://t.co/i8ry8nNAkI">pic.twitter.com/i8ry8nNAkI</a></p>&mdash; Matthew Palmer (@_matthewpalmer) <a href="https://twitter.com/_matthewpalmer/status/753343252573462528">July 13, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## Details

How is Locksmith different to other keychain wrappers?

* Locksmith’s API is both super-simple and deeply powerful
* Provides access to all of the keychain’s metadata with strongly typed results
* Add functionality to your existing types for free
* Useful enums and Swift-native types

> Want to read more about Locksmith’s design? I wrote a blog post on [protocol oriented programming in Swift](http://matthewpalmer.net/blog/2015/08/30/protocol-oriented-programming-in-the-real-world/).

## Installation

[![Version](https://img.shields.io/cocoapods/v/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/matthewpalmer/Locksmith.svg?branch=master)](https://travis-ci.org/matthewpalmer/Locksmith)

### CocoaPods

Locksmith is available through [CocoaPods](http://cocoapods.org).

    pod 'Locksmith'

### Carthage

Locksmith is available through [Carthage](https://github.com/Carthage/Carthage).

    github "matthewpalmer/Locksmith"

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

- as well as replacing existing data, this writes data to the keychain if it does not exist already

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

Now we get the ability to save our account in the keychain.

```swift
let account = TwitterAccount(username: "_matthewpalmer", password: "my_password")
try account.createInSecureStore()
```

Creating, reading, and deleting each have their own protocols: `CreateableSecureStorable`, `ReadableSecureStorable`, and `DeleteableSecureStorable`. And the best part?

**You can conform to all three protocols on the same type!**

```swift
struct TwitterAccount: ReadableSecureStorable, 
                       CreateableSecureStorable,
                       DeleteableSecureStorable,
                       GenericPasswordSecureStorable {
  let username: String
  let password: String

  let service = "Twitter"
  var account: String { return username }
  var data: [String: AnyObject] {
    return ["password": password]
  }
}

let account = TwitterAccount(username: "_matthewpalmer", password: "my_password")

// CreateableSecureStorable lets us create the account in the keychain
try account.createInSecureStore()

// ReadableSecureStorable lets us read the account from the keychain
let result = account.readFromSecureStore()

// DeleteableSecureStorable lets us delete the account from the keychain
try account.deleteFromSecureStore()
```

So. cool.

### The details

By declaring that your type adopts these protocols—which is what we did above with `struct TwitterAccount: CreateableSecureStorable, ...`—you get a bunch of functionality for free.

I like to think about protocols with extensions in terms of “what you get,” “what you’ve gotta do,” and “what’s optional.” Most of the stuff under ‘optional’ should only be implemented if you want to change existing functionality.

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

Many wrappers around the keychain have only support certain parts of the API.  This is because there are so many options and variations on the way you can query the keychain that it’s almost impossible to abstract effectively.

Locksmith tries to include as much of the keychain as possible, using protocols and protocol extensions to minimize the complexity. You can mix-and-match your generic passwords with your read requests while staying completely type-safe.

Please refer to the [Keychain Services Reference](https://developer.apple.com/library/ios/documentation/Security/Reference/keychainservices/) for full information on what each of the attributes mean and what they can do.

> Certificates, keys, and identities are possible—it’s just a matter of translating the `kSec...` constants!

#### `GenericPasswordSecureStorable`

Generic passwords are probably the most common use-case of the keychain, and are great for storing usernames and passwords.

Properties listed under ‘Required’ have to be implemented by any types that conform; those listed under ‘Optional’ can be implemented to add additional information to what is saved or read if desired.

One thing to note: if you implement an optional property, its type annotation must match the type specified in the protocol *exactly*. If you implement `description: String?` it can’t be declared as `var description: String`.

**Required**

```swift
var account: String { get }
var service: String { get }
```

**Optional**

```swift
var comment: String? { get }
var creator: UInt? { get }
var description: String? { get }
var generic: NSData? { get }
var isInvisible: Bool? { get }
var isNegative: Bool? { get }
var label: String? { get }
var type: UInt? { get }
```

#### `InternetPasswordSecureStorable`

Types that conform to `InternetPasswordSecureStorable` typically come from web services and have certain associated metadata.

**Required**

```swift
var account: String { get }
var authenticationType: LocksmithInternetAuthenticationType { get }
var internetProtocol: LocksmithInternetProtocol { get }
var port: String { get }
var server: String { get }
```

**Optional**

```swift
var comment: String? { get }
var creator: UInt? { get }
var description: String? { get }
var isInvisible: Bool? { get }
var isNegative: Bool? { get }
var path: String? { get }
var securityDomain: String? { get }
var type: UInt? { get }
```

## Result types

By adopting a protocol-oriented design from the ground up, Locksmith can provide access to the result of your keychain queries *with type annotations included*—store an `NSDate`, get an `NSDate` back with no type-casting!

Let’s start with an example: the Twitter account from before, except it’s now an `InternetPasswordSecureStorable`, which lets us store a bit more metadata.

```swift
struct TwitterAccount: InternetPasswordSecureStorable, 
                       ReadableSecureStorable,
                       CreateableSecureStorable {
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
  let path: String? = "/api/2.0/"
}

let account = TwitterAccount(username: "_matthewpalmer", password: "my_password")

// Save all this to the keychain
account.createInSecureStore()

// Now let’s get it back
let result: InternetPasswordSecureStorableResultType = account.readFromSecureStore()

result?.port // Gives us an Int directly!
result?.internetProtocol // Gives us a LocksmithInternetProtocol enum case directly!
result?.data // Gives us a [String: AnyObject] of what was saved
// and so on...
```

This is *awesome*. No more typecasting.

#### `GenericPasswordSecureStorableResultType`

Everything listed here can be set on a type conforming to `GenericPasswordSecureStorable`, and gotten back from the result returned from `readFromSecureStore()` on that type.

```swift
var account: String { get }
var service: String { get }
var comment: String? { get }
var creator: UInt? { get }
var description: String? { get }
var data: [String: AnyObject]? { get }
var generic: NSData? { get }
var isInvisible: Bool? { get }
var isNegative: Bool? { get }
var label: String? { get }
var type: UInt? { get }
```

#### `InternetPasswordSecureStorableResultType`

Everything listed here can be set on a type conforming to `InternetPasswordSecureStorable`, and gotten back from the result returned from `readFromSecureStore()` on that type.

```swift
var account: String { get }
var authenticationType: LocksmithInternetAuthenticationType { get }
var internetProtocol: LocksmithInternetProtocol { get }
var port: Int { get }
var server: String { get }
var comment: String? { get }
var creator: UInt? { get }
var data: [String: AnyObject]? { get }
var description: String? { get }
var isInvisible: Bool? { get }
var isNegative: Bool? { get }
var path: String? { get }
var securityDomain: String? { get }
var type: UInt? { get }
```

## Enumerations

Locksmith provides a bunch of handy enums for configuring your requests, so you can say `kSecGoodByeStringConstants`.

#### `LocksmithAccessibleOption`

`LocksmithAccessibleOption` configures when an item can be accessed—you might require that stuff is available when the device is unlocked, after a passcode has been entered, etc.

```swift
public enum LocksmithAccessibleOption {
  case AfterFirstUnlock
  case AfterFirstUnlockThisDeviceOnly
  case Always
  case AlwaysThisDeviceOnly
  case WhenPasscodeSetThisDeviceOnly
  case WhenUnlocked
  case WhenUnlockedThisDeviceOnly
}
```

#### `LocksmithError`

`LocksmithError` provides Swift-friendly translations of common keychain error codes. These are thrown from methods throughout the library. [Apple’s documentation](https://developer.apple.com/library/ios/documentation/Security/Reference/keychainservices/#//apple_ref/c/econst/errSecSuccess) provides more information on these errors.

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

`LocksmithInternetAuthenticationType` lets you pick out the type of authentication you want to store alongside your `.InternetPassword`s—anything from `.MSN` to `.HTTPDigest`. [Apple’s documentation](https://developer.apple.com/library/ios/documentation/Security/Reference/keychainservices/#//apple_ref/doc/constant_group/Authentication_Type_Values) provides more information on these values. 

```swift
public enum LocksmithInternetAuthenticationType {
  case Default
  case DPA
  case HTMLForm
  case HTTPBasic
  case HTTPDigest
  case MSN
  case NTLM
  case RPA
}
```

#### `LocksmithInternetProtocol`

`LocksmithInternetProtocol` is used with `.InternetPassword` to choose which protocol was used for the interaction with the web service, including `.HTTP`, `.SMB`, and a whole bunch more. [Apple’s documentation](https://developer.apple.com/library/ios/documentation/Security/Reference/keychainservices/#//apple_ref/doc/constant_group/Protocol_Values) provides more information on these values. 

```swift
public enum {
  case AFP
  case AppleTalk
  case DAAP
  case EPPC
  case FTP
  case FTPAccount
  case FTPProxy
  case FTPS
  case HTTP
  case HTTPProxy
  case HTTPS
  case HTTPSProxy
  case IMAP
  case IMAPS
  case IPP
  case IRC
  case IRCS
  case LDAP
  case NNTP
  case NNTPS, LDAPS
  case POP3
  case POP3S
  case RTSP
  case RTSPProxy
  case SMB
  case SMTP
  case SOCKS
  case SSH
  case Telnet
  case TelnetS
}
```

## Author

[Matthew Palmer](http://matthewpalmer.net), matt@matthewpalmer.net

## License

Locksmith is available under the MIT license. See the LICENSE file for more info.
