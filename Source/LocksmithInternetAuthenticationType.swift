import Foundation

public enum LocksmithInternetAuthenticationType: RawRepresentable {
    case NTLM, MSN, DPA, RPA, HTTPBasic, HTTPDigest, HTMLForm, Default
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAuthenticationTypeNTLM):
            self = NTLM
        case String(kSecAttrAuthenticationTypeMSN):
            self = MSN
        case String(kSecAttrAuthenticationTypeDPA):
            self = DPA
        case String(kSecAttrAuthenticationTypeRPA):
            self = RPA
        case String(kSecAttrAuthenticationTypeHTTPBasic):
            self = HTTPBasic
        case String(kSecAttrAuthenticationTypeHTTPDigest):
            self = HTTPDigest
        case String(kSecAttrAuthenticationTypeHTMLForm):
            self = HTMLForm
        case String(kSecAttrAuthenticationTypeDefault):
            self = Default
        default:
            self = Default
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
