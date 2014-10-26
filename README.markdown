# Locksmith

> A sane way to work with the iOS Keychain in Swift.

# Usage

Grab two files from the project: Locksmith.swift and LocksmithRequest.swift.

## Saving

    let saveRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key, data: ["some key": "some value"])
    Locksmith.performRequest(saveRequest)

## Reading

    let readRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key)
    let (dictionary, error) = Locksmith.performRequest(readRequest)

## Deleting

    let deleteRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key, requestType: .Delete)
    Locksmith.performRequest(deleteRequest)