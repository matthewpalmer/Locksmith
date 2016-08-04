import Foundation

// With thanks to http://iosdeveloperzone.com/2014/10/22/taming-foundation-constants-into-swift-enums/
// MARK: Security Class
public enum LocksmithSecurityClass: RawRepresentable {
    case GenericPassword, InternetPassword, Certificate, Key, Identity
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecClassGenericPassword):
            self = LocksmithSecurityClass.GenericPassword
        case String(kSecClassInternetPassword):
            self = LocksmithSecurityClass.InternetPassword
        case String(kSecClassCertificate):
            self = LocksmithSecurityClass.Certificate
        case String(kSecClassKey):
            self = LocksmithSecurityClass.Key
        case String(kSecClassIdentity):
            self = LocksmithSecurityClass.Identity
        default:
            self = LocksmithSecurityClass.GenericPassword
        }
    }
    
    public var rawValue: String {
        switch self {
        case .GenericPassword:
            return String(kSecClassGenericPassword)
        case .InternetPassword:
            return String(kSecClassInternetPassword)
        case .Certificate:
            return String(kSecClassCertificate)
        case .Key:
            return String(kSecClassKey)
        case .Identity:
            return String(kSecClassIdentity)
        }
    }
}
