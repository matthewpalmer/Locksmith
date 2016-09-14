import Foundation

// MARK: Locksmith Error
public enum LocksmithError: String, Error {
    case allocate = "Failed to allocate memory."
    case authFailed = "Authorization/Authentication failed."
    case decode = "Unable to decode the provided data."
    case duplicate = "The item already exists."
    case interactionNotAllowed = "Interaction with the Security Server is not allowed."
    case noError = "No error."
    case notAvailable = "No trust results are available."
    case notFound = "The item cannot be found."
    case param = "One or more parameters passed to the function were not valid."
    case requestNotSet = "The request was not set"
    case typeNotFound = "The type was not found"
    case unableToClear = "Unable to clear the keychain"
    case undefined = "An undefined error occurred"
    case unimplemented = "Function or operation not implemented."
    
    init?(fromStatusCode code: Int) {
        switch code {
        case Int(errSecAllocate):
            self = .allocate
        case Int(errSecAuthFailed):
            self = .authFailed
        case Int(errSecDecode):
            self = .decode
        case Int(errSecDuplicateItem):
            self = .duplicate
        case Int(errSecInteractionNotAllowed):
            self = .interactionNotAllowed
        case Int(errSecItemNotFound):
            self = .notFound
        case Int(errSecNotAvailable):
            self = .notAvailable
        case Int(errSecParam):
            self = .param
        case Int(errSecUnimplemented):
            self = .unimplemented
        default:
            return nil
        }
    }
}
