import Foundation

// MARK: Accessible
public enum LocksmithAccessibleOption: RawRepresentable {
    case WhenUnlocked, AfterFirstUnlock, Always, WhenUnlockedThisDeviceOnly, AfterFirstUnlockThisDeviceOnly, AlwaysThisDeviceOnly
    @available (iOS 8,*)
    case WhenPasscodeSetThisDeviceOnly
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAccessibleWhenUnlocked):
            self = WhenUnlocked
        case String(kSecAttrAccessibleAfterFirstUnlock):
            self = AfterFirstUnlock
        case String(kSecAttrAccessibleAlways):
            self = Always
        case String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly):
            self = WhenUnlockedThisDeviceOnly
        case String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly):
            self = AfterFirstUnlockThisDeviceOnly
        case String(kSecAttrAccessibleAlwaysThisDeviceOnly):
            self = AlwaysThisDeviceOnly
        default:
            if #available(iOS 8.0, *) {
                if rawValue == String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly) {
                    self = WhenPasscodeSetThisDeviceOnly
                } else {
                    print("Accessible: invalid rawValue provided. Defaulting to LocksmithAccessibleOption.WhenUnlocked.")
                    self = WhenUnlocked
                }
            } else {
                print("Accessible: invalid rawValue provided. Defaulting to LocksmithAccessibleOption.WhenUnlocked.")
                self = WhenUnlocked
            }
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
            if #available(iOS 8.0, *) {
                return String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
            } else {
                fatalError("LocksmithAccessibleOption.WhenPasscodeSetThisDeviceOnly has no raw representation in iOS 7 or OS X.")
            }
        case .WhenUnlockedThisDeviceOnly:
            return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
        case .AfterFirstUnlockThisDeviceOnly:
            return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        case .AlwaysThisDeviceOnly:
            return String(kSecAttrAccessibleAlwaysThisDeviceOnly)
        }
    }
}
