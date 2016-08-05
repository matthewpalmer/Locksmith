import Foundation

// MARK: Accessible
public enum LocksmithAccessibleOption: RawRepresentable {
    case WhenUnlocked, AfterFirstUnlock, Always, WhenUnlockedThisDeviceOnly, AfterFirstUnlockThisDeviceOnly, AlwaysThisDeviceOnly, WhenPasscodeSetThisDeviceOnly
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAccessibleWhenUnlocked):
            self = LocksmithAccessibleOption.WhenUnlocked
        case String(kSecAttrAccessibleAfterFirstUnlock):
            self = LocksmithAccessibleOption.AfterFirstUnlock
        case String(kSecAttrAccessibleAlways):
            self = LocksmithAccessibleOption.Always
        case String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly):
            self = LocksmithAccessibleOption.WhenUnlockedThisDeviceOnly
        case String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly):
            self = LocksmithAccessibleOption.AfterFirstUnlockThisDeviceOnly
        case String(kSecAttrAccessibleAlwaysThisDeviceOnly):
            self = LocksmithAccessibleOption.AlwaysThisDeviceOnly
        case String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly):
            self = LocksmithAccessibleOption.WhenPasscodeSetThisDeviceOnly
        default:
            self = LocksmithAccessibleOption.WhenUnlocked
        }
    }
    
    public var rawValue: String {
        switch self {
        case .WhenUnlocked:
            return String(kSecAttrAccessibleWhenUnlocked)
        case .AfterFirstUnlock:
            return String(kSecAttrAccessibleAfterFirstUnlock)
        case .Always:
            return String(kSecAttrAccessibleAlways)
        case .WhenPasscodeSetThisDeviceOnly:
            return String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
        case .WhenUnlockedThisDeviceOnly:
            return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
        case .AfterFirstUnlockThisDeviceOnly:
            return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        case .AlwaysThisDeviceOnly:
            return String(kSecAttrAccessibleAlwaysThisDeviceOnly)
        }
    }
}
