import Foundation

// MARK: Accessible
public enum LocksmithAccessibleOption: RawRepresentable {
    case whenUnlocked, afterFirstUnlock, always, whenUnlockedThisDeviceOnly, afterFirstUnlockThisDeviceOnly, alwaysThisDeviceOnly, whenPasscodeSetThisDeviceOnly
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAccessibleWhenUnlocked):
            self = .whenUnlocked
        case String(kSecAttrAccessibleAfterFirstUnlock):
            self = .afterFirstUnlock
        case String(kSecAttrAccessibleAlways):
            self = .always
        case String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly):
            self = .whenUnlockedThisDeviceOnly
        case String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly):
            self = .afterFirstUnlockThisDeviceOnly
        case String(kSecAttrAccessibleAlwaysThisDeviceOnly):
            self = .alwaysThisDeviceOnly
        case String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly):
            self = .whenPasscodeSetThisDeviceOnly
        default:
            self = .whenUnlocked
        }
    }
    
    public var rawValue: String {
        switch self {
        case .whenUnlocked:
            return String(kSecAttrAccessibleWhenUnlocked)
        case .afterFirstUnlock:
            return String(kSecAttrAccessibleAfterFirstUnlock)
        case .always:
            return String(kSecAttrAccessibleAlways)
        case .whenPasscodeSetThisDeviceOnly:
            return String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
        case .whenUnlockedThisDeviceOnly:
            return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
        case .afterFirstUnlockThisDeviceOnly:
            return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        case .alwaysThisDeviceOnly:
            return String(kSecAttrAccessibleAlwaysThisDeviceOnly)
        }
    }
}
