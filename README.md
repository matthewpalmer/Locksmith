# Locksmith

A protocol-oriented way to work with the iOS Keychain in Swift.

[![Version](https://img.shields.io/cocoapods/v/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)
[![Platform](https://img.shields.io/cocoapods/p/Locksmith.svg?style=flat)](http://cocoadocs.org/docsets/Locksmith)

 
## Installation

### CocoaPods

Locksmith is available through [CocoaPods](http://cocoapods.org). To install
Locksmith for Swift 2, simply add the following line to your Podfile:

    pod 'Locksmith'

Swift 1.2 support is available via the `1.2` branch.

## Quick and easy to use

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

Locksmith works perfectly when it’s used this way, but you might be wondering…

## Where are the protocols!?

> Bonus functionality, for free

Locksmith has been designed with Swift 2, protocols, and protocol extensions in mind.

Why do this? It means that you can *add keychain functionality to your existing types* with only the slightest change!

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

  let service = "Twitter"
  var account = { username }

  var data {
    return [ "password": password ]
  }
}
```

Then, all we’ve got to do is create the account and save it to the keychain

```swift
let account = TwitterAccount(username: "_matthewpalmer", password: "my_password")
try account.createInSecureStore()
```

This is a crazy, different, and insanely powerful way to add capabilities to your existing types.

Creating, reading, and deleting are done similarly. Right now, it’s not possible to declare `CreateableSecureStorable`, `ReadableSecureStorable`, and `DeleteableSecureStorable` on the same type, but we’re working towards that.

**Reading**

```swift
struct SavedTwitterAccount: ReadableSecureStorable, GenericPasswordSecureStorable {
  let service = "Twitter"
  let username: String

  var account = { username }
}

let dictionary = SavedTwitterAccount(username: "_matthewpalmer").readFromSecureStore()
```

**Deleting**

```swift
struct ExistingTwitterAccount: DeleteableSecureStorable, GenericPasswordSecureStorable {
  let service = "Twitter"
  let username: String

  var account = { username }
}

try ExistingTwitterAccount(username: "_matthewpalmer").deleteFromSecureStore()
```

### The details

> Diving deep on protocols

There are a couple of key protocols that you will need to conform to in order to use the keychain (or any other secure storage container!)—each to indicate that your type is capable of being created in, read from, or deleted from the keychain.

#### `CreateableSecureStorable`

* Conformance to this protocol indicates that your type is able to be created and saved to a secure storage container.

**Required**

* `var data: [String: AnyObject]` is what will be saved to the keychain for your type

**Optional** (override to change functionality)

* `func createInSecureStore() throws` by default loads an item from the iOS keychain. 
  This can be overridden for testing or if you would like to save to somewhere other than the keychain

#### `ReadableSecureStorable`

* Conformance to this protocol indicates that your type is able to be read from a secure storage container.

**Required**
* Nothing!

**Optional** (override to change functionality)

* `func readFromSecureStore() -> SecurelyStoredData?` by default reads an item from the iOS keychain. `SecurelyStoredData` is a typealias for `[String: AnyObject]`.

#### `DeleteableSecureStorable`

* Conformance to this protocol indicates that your type is able to be deleted from a secure storage container.

**Required**
* Nothing!

**Optional** (override to change functionality)
* `func deleteFromSecureStore() throws`

## Powerful support for the Cocoa Keychain

> The coolest part of being protocol oriented

Many wrappers around the keychain (including previous and current implementations of this library) have limited support for the keychain. They usually support only the critical parts, and ignore the rest. This is because there are so many options and variations on the way you can query the keychain that it’s almost impossible to do it reliably, or in a way that is easy for users to adopt.

Locksmith tries to include as much of the keychain as possible, using protocols and protocol extensions to minimize the complexity. You can mix-and-match your generic passwords with your read requests while staying completely type-safe.

Please refer to the [Keychain Services Reference](https://developer.apple.com/library/ios/documentation/Security/Reference/keychainservices/) for full information on what each of the attributes means and what they can do.

### `GenericPasswordSecureStorable`

Generic passwords are probably the most common use-case of the keychain, and are great for storing usernames and passwords.

Properties listed under ‘Required’ have to be implemented by any types that conform; those listed under ‘Optional’ can be implemented to add additional information to what is saved or read if desired.

**Required**

```swift
var service: String { get }
var account: String { get }
```

**Optional**

```swift
var creationDate: NSDate? { get }?
var modificationDate: NSDate? { get }
var description: String? { get }
var comment: String? { get }
var creator: UInt? { get }
var label: String? { get }
var type: UInt? { get }
var isInvisible: Bool? { get }
var isNegative: Bool? { get }
```

### `InternetPasswordSecureStorable`

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
 
## `CertificateSecureStorable` and `KeySecureStorable`

*Right now, Locksmith only supports generic passwords and internet passwords. The other types of items can be slotted into the library pretty easily, it’s simply a matter of adding tests and translating all the `kSecBlahBlahBlah` constants. I guess we shouldn’t have thrown shade earlier…*

## Enumerations

> `kSecGoodByeStringConstants`

Locksmith provides a bunch of handy enums for configuring your requests.

* `LocksmithAccessibleOption` is used to configure when an item can be accesse—you might want to only have stuff available when the device is unlocked, after a passcode has been entered, etc.
* `LocksmithError` provides Swift-friendly translations of common keychain error codes. These are thrown from methods throughout the library.
* `LocksmithSecurityClass` lists out all the different types of requests you can make, including `.GenericPassword` and `.InternetPassword`
* `LocksmithInternetAuthenticationType` lets you pick out the type of authentication you want to store alongside your `.InternetPassword`s
* `LocksmithInternetProtocol` is used with `.InternetPassword` to choose which protocol was used for the interaction with the web service, including `.HTTP`, `.SMB`, and a whole bunch more

## Author

[Matthew Palmer](http://matthewpalmer.net), matt@matthewpalmer.net

## License

Locksmith is available under the MIT license. See the LICENSE file for more info.
