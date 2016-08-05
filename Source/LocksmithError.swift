import Foundation

// MARK: Locksmith Error
public enum LocksmithError: String, Error {
    case Allocate = "Failed to allocate memory."
    case AuthFailed = "Authorization/Authentication failed."
    case Decode = "Unable to decode the provided data."
    case Duplicate = "The item already exists."
    case InteractionNotAllowed = "Interaction with the Security Server is not allowed."
    case NoError = "No error."
    case NotAvailable = "No trust results are available."
    case NotFound = "The item cannot be found."
    case Param = "One or more parameters passed to the function were not valid."
    case RequestNotSet = "The request was not set"
    case TypeNotFound = "The type was not found"
    case UnableToClear = "Unable to clear the keychain"
    case Undefined = "An undefined error occurred"
    case Unimplemented = "Function or operation not implemented."
    
    init?(fromStatusCode code: Int) {
        switch code {
        case Int(errSecAllocate):
            self = LocksmithError.Allocate
        case Int(errSecAuthFailed):
            self = LocksmithError.AuthFailed
        case Int(errSecDecode):
            self = LocksmithError.Decode
        case Int(errSecDuplicateItem):
            self = LocksmithError.Duplicate
        case Int(errSecInteractionNotAllowed):
            self = LocksmithError.InteractionNotAllowed
        case Int(errSecItemNotFound):
            self = LocksmithError.NotFound
        case Int(errSecNotAvailable):
            self = LocksmithError.NotAvailable
        case Int(errSecParam):
            self = LocksmithError.Param
        case Int(errSecUnimplemented):
            self = LocksmithError.Unimplemented
        default:
            return nil
        }
    }
}
