import Foundation

public enum LocksmithInternetAuthenticationType: RawRepresentable {
    case NTLM, MSN, DPA, RPA, HTTPBasic, HTTPDigest, HTMLForm, Default
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAuthenticationTypeNTLM):
            self = LocksmithInternetAuthenticationType.NTLM
        case String(kSecAttrAuthenticationTypeMSN):
            self = LocksmithInternetAuthenticationType.MSN
        case String(kSecAttrAuthenticationTypeDPA):
            self = LocksmithInternetAuthenticationType.DPA
        case String(kSecAttrAuthenticationTypeRPA):
            self = LocksmithInternetAuthenticationType.RPA
        case String(kSecAttrAuthenticationTypeHTTPBasic):
            self = LocksmithInternetAuthenticationType.HTTPBasic
        case String(kSecAttrAuthenticationTypeHTTPDigest):
            self = LocksmithInternetAuthenticationType.HTTPDigest
        case String(kSecAttrAuthenticationTypeHTMLForm):
            self = LocksmithInternetAuthenticationType.HTMLForm
        case String(kSecAttrAuthenticationTypeDefault):
            self = LocksmithInternetAuthenticationType.Default
        default:
            self = LocksmithInternetAuthenticationType.Default
        }
    }
    
    public var rawValue: String {
        switch self {
        case .NTLM:
            return String(kSecAttrAuthenticationTypeNTLM)
        case .MSN:
            return String(kSecAttrAuthenticationTypeMSN)
        case .DPA:
            return String(kSecAttrAuthenticationTypeDPA)
        case .RPA:
            return String(kSecAttrAuthenticationTypeRPA)
        case .HTTPBasic:
            return String(kSecAttrAuthenticationTypeHTTPBasic)
        case .HTTPDigest:
            return String(kSecAttrAuthenticationTypeHTTPDigest)
        case .HTMLForm:
            return String(kSecAttrAuthenticationTypeHTMLForm)
        case .Default:
            return String(kSecAttrAuthenticationTypeDefault)
        }
    }
}
