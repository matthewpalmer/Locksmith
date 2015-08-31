import UIKit

public let LocksmithDefaultService = NSBundle.mainBundle().infoDictionary![String(kCFBundleIdentifierKey)] as? String ?? "com.locksmith.defaultService"

// MARK: Accessible
public enum LocksmithAccessibleOption: RawRepresentable {
    case WhenUnlocked, AfterFirstUnlock, Always, WhenPasscodeSetThisDeviceOnly, WhenUnlockedThisDeviceOnly, AfterFirstUnlockThisDeviceOnly, AlwaysThisDeviceOnly
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAccessibleWhenUnlocked):
            self = WhenUnlocked
        case String(kSecAttrAccessibleAfterFirstUnlock):
            self = AfterFirstUnlock
        case String(kSecAttrAccessibleAlways):
            self = Always
        case String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly):
            self = WhenPasscodeSetThisDeviceOnly
        case String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly):
            self = WhenUnlockedThisDeviceOnly
        case String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly):
            self = AfterFirstUnlockThisDeviceOnly
        case String(kSecAttrAccessibleAlwaysThisDeviceOnly):
            self = AlwaysThisDeviceOnly
        default:
            print("Accessible: invalid rawValue provided. Defaulting to Accessible.WhenUnlocked.")
            self = WhenUnlocked
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

// MARK: Locksmith Error
public enum LocksmithError: String, ErrorType {
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
            self = Allocate
        case Int(errSecAuthFailed):
            self = AuthFailed
        case Int(errSecDecode):
            self = Decode
        case Int(errSecDuplicateItem):
            self = Duplicate
        case Int(errSecInteractionNotAllowed):
            self = InteractionNotAllowed
        case Int(errSecItemNotFound):
            self = NotFound
        case Int(errSecNotAvailable):
            self = NotAvailable
        case Int(errSecParam):
            self = Param
        case Int(errSecUnimplemented):
            self = Unimplemented
        default:
            return nil
        }
    }
}

// With thanks to http://iosdeveloperzone.com/2014/10/22/taming-foundation-constants-into-swift-enums/
// MARK: Security Class
public enum LocksmithSecurityClass: RawRepresentable {
    case GenericPassword, InternetPassword, Certificate, Key, Identity
    static let allClasses = [GenericPassword, InternetPassword, Certificate, Key, Identity]
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecClassGenericPassword):
            self = GenericPassword
        case String(kSecClassInternetPassword):
            self = InternetPassword
        case String(kSecClassCertificate):
            self = Certificate
        case String(kSecClassKey):
            self = Key
        case String(kSecClassIdentity):
            self = Identity
        default:
            print("SecurityClass: Invalid raw value provided. Defaulting to .GenericPassword")
            self = GenericPassword
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

public enum LocksmithInternetProtocol: RawRepresentable {
    case FTP, FTPAccount, HTTP, IRC, NNTP, POP3, SMTP, SOCKS, IMAP, LDAP, AppleTalk, AFP, Telnet, SSH, FTPS, HTTPS, HTTPProxy, HTTPSProxy, FTPProxy, SMB, RTSP, RTSPProxy, DAAP, EPPC, IPP, NNTPS, LDAPS, TelnetS, IMAPS, IRCS, POP3S
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrProtocolFTP):
            self = FTP
        case String(kSecAttrProtocolFTPAccount):
            self = FTPAccount
        case String(kSecAttrProtocolHTTP):
            self = HTTP
        case String(kSecAttrProtocolIRC):
            self = IRC
        case String(kSecAttrProtocolNNTP):
            self = NNTP
        case String(kSecAttrProtocolPOP3):
            self = POP3
        case String(kSecAttrProtocolSMTP):
            self = SMTP
        case String(kSecAttrProtocolSOCKS):
            self = SOCKS
        case String(kSecAttrProtocolIMAP):
            self = IMAP
        case String(kSecAttrProtocolLDAP):
            self = LDAP
        case String(kSecAttrProtocolAppleTalk):
            self = AppleTalk
        case String(kSecAttrProtocolAFP):
            self = AFP
        case String(kSecAttrProtocolTelnet):
            self = Telnet
        case String(kSecAttrProtocolSSH):
            self = SSH
        case String(kSecAttrProtocolFTPS):
            self = FTPS
        case String(kSecAttrProtocolHTTPS):
            self = HTTPS
        case String(kSecAttrProtocolHTTPProxy):
            self = HTTPProxy
        case String(kSecAttrProtocolHTTPSProxy):
            self = HTTPSProxy
        case String(kSecAttrProtocolFTPProxy):
            self = FTPProxy
        case String(kSecAttrProtocolSMB):
            self = SMB
        case String(kSecAttrProtocolRTSP):
            self = RTSP
        case String(kSecAttrProtocolRTSPProxy):
            self = RTSPProxy
        case String(kSecAttrProtocolDAAP):
            self = DAAP
        case String(kSecAttrProtocolEPPC):
            self = EPPC
        case String(kSecAttrProtocolIPP):
            self = IPP
        case String(kSecAttrProtocolNNTPS):
            self = NNTPS
        case String(kSecAttrProtocolLDAPS):
            self = LDAPS
        case String(kSecAttrProtocolTelnetS):
            self = TelnetS
        case String(kSecAttrProtocolIMAPS):
            self = IMAPS
        case String(kSecAttrProtocolIRCS):
            self = IRCS
        case String(kSecAttrProtocolPOP3S):
            self = POP3S
        default:
            self = HTTP
        }
    }
    
    public var rawValue: String {
        switch self {
        case .FTP:
            return String(kSecAttrProtocolFTP)
        case .FTPAccount:
            return String(kSecAttrProtocolFTPAccount)
        case .HTTP:
            return String(kSecAttrProtocolHTTP)
        case .IRC:
            return String(kSecAttrProtocolIRC)
        case .NNTP:
            return String(kSecAttrProtocolNNTP)
        case .POP3:
            return String(kSecAttrProtocolPOP3)
        case .SMTP:
            return String(kSecAttrProtocolSMTP)
        case .SOCKS:
            return String(kSecAttrProtocolSOCKS)
        case .IMAP:
            return String(kSecAttrProtocolIMAP)
        case .LDAP:
            return String(kSecAttrProtocolLDAP)
        case .AppleTalk:
            return String(kSecAttrProtocolAppleTalk)
        case .AFP:
            return String(kSecAttrProtocolAFP)
        case .Telnet:
            return String(kSecAttrProtocolTelnet)
        case .SSH:
            return String(kSecAttrProtocolSSH)
        case .FTPS:
            return String(kSecAttrProtocolFTPS)
        case .HTTPS:
            return String(kSecAttrProtocolHTTPS)
        case .HTTPProxy:
            return String(kSecAttrProtocolHTTPProxy)
        case .HTTPSProxy:
            return String(kSecAttrProtocolHTTPSProxy)
        case .FTPProxy:
            return String(kSecAttrProtocolFTPProxy)
        case .SMB:
            return String(kSecAttrProtocolSMB)
        case .RTSP:
            return String(kSecAttrProtocolRTSP)
        case .RTSPProxy:
            return String(kSecAttrProtocolRTSPProxy)
        case .DAAP:
            return String(kSecAttrProtocolDAAP)
        case .EPPC:
            return String(kSecAttrProtocolEPPC)
        case .IPP:
            return String(kSecAttrProtocolIPP)
        case .NNTPS:
            return String(kSecAttrProtocolNNTPS)
        case .LDAPS:
            return String(kSecAttrProtocolLDAPS)
        case .TelnetS:
            return String(kSecAttrProtocolTelnetS)
        case .IMAPS:
            return String(kSecAttrProtocolIMAPS)
        case .IRCS:
            return String(kSecAttrProtocolIRCS)
        case .POP3S:
            return String(kSecAttrProtocolPOP3S)
        }
    }
}

public typealias PerformRequestClosureType = (requestReference: CFDictionaryRef, inout result: AnyObject?) -> (OSStatus)

// MARK: - SecureStorable
/// The base protocol that indicates conforming types will have the ability to be stored in a secure storage container, such as the iOS keychain.
public protocol SecureStorable {
//    var performRequestClosure: PerformRequestClosureType { get }
//    var asSecureStoragePropertyDictionary: [String: AnyObject] { get }
    var accessible: LocksmithAccessibleOption? { get }
    var accessGroup: String? { get }
}

public protocol SecureStorableResultType: SecureStorable {
    var resultDictionary: [String: AnyObject] { get }
    var data: [String: AnyObject]? { get }
}

public extension SecureStorableResultType {
    var performRequestClosure: PerformRequestClosureType {
        // TODO: This is pretty bad
        return { (_, _) in
            return errSecSuccess
        }
    }
    
    var asSecureStoragePropertyDictionary: [String: AnyObject] {
        return [String: AnyObject]()
    }
    
    var resultDictionary: [String: AnyObject] {
        return [String: AnyObject]()
    }
    
    var data: [String: AnyObject]? {
        guard let aData = resultDictionary[String(kSecValueData)] as? NSData else {
            return nil
        }
        
        return NSKeyedUnarchiver.unarchiveObjectWithData(aData) as? [String: AnyObject]
    }
}

public extension SecureStorable {
    var accessible: LocksmithAccessibleOption? { return nil }
    var accessGroup: String? { return nil }
    
    var secureStorableBaseStoragePropertyDictionary: [String: AnyObject] {
        let dictionary = [
            String(kSecAttrAccessGroup): self.accessGroup,
            String(kSecAttrAccessible): self.accessible?.rawValue
        ]
        
        return Dictionary(withoutOptionalValues: dictionary)
    }
    
    private func performSecureStorageAction(closure: PerformRequestClosureType, secureStoragePropertyDictionary: [String: AnyObject]) throws -> [String: AnyObject]? {
        var result: AnyObject?
        let request = secureStoragePropertyDictionary
        let requestReference = request as CFDictionaryRef
        
        let status = closure(requestReference: requestReference, result: &result)
        
        let statusCode = Int(status)
        
        if let error = LocksmithError(fromStatusCode: statusCode) {
            throw error
        }
        
        // hmmmm... bit leaky
        if status != errSecSuccess {
            return nil
        }
        
        guard let dictionary = result as? NSDictionary else {
            return nil
        }
        
        guard let data = dictionary[String(kSecValueData)] as? NSData else {
            return nil
        }
        
        return result as? [String: AnyObject]
    }
}

public protocol AccountBasedSecureStorable {
    /// The account that the stored value will belong to
    var account: String { get }
}

public extension AccountBasedSecureStorable {
    private var accountSecureStoragePropertyDictionary: [String: AnyObject] {
        return [String(kSecAttrAccount): self.account]
    }
}

public protocol AccountBasedSecureStorableResultType: AccountBasedSecureStorable, SecureStorableResultType {}

public extension AccountBasedSecureStorableResultType {
    var account: String {
        return self.resultDictionary[String(kSecAttrAccount)] as! String
    }
}

public protocol DescribableSecureStorable {
    /// A description of the item in the secure storage container.
    var description: String? { get }
}

public extension DescribableSecureStorable {
    var description: String? { return nil }
    
    private var describableSecureStoragePropertyDictionary: [String: AnyObject] {
        return Dictionary(withoutOptionalValues: [
            String(kSecAttrDescription): self.description
            ])
    }
}

public protocol DescribableSecureStorableResultType: DescribableSecureStorable, SecureStorableResultType {}

public extension DescribableSecureStorableResultType {
    var description: String? {
        return self.resultDictionary[String(kSecAttrDescription)] as? String
    }
}

public protocol CommentableSecureStorable {
    /// A comment attached to the item in the secure storage container.
    var comment: String? { get }
}

public extension CommentableSecureStorable {
    var comment: String? { return nil }
    
    private var commentableSecureStoragePropertyDictionary: [String: AnyObject] {
        return Dictionary(withoutOptionalValues: [
            String(kSecAttrComment): self.comment
            ])
    }
}

public protocol CommentableSecureStorableResultType: CommentableSecureStorable, SecureStorableResultType {}

public extension CommentableSecureStorableResultType {
    var comment: String? {
        return self.resultDictionary[String(kSecAttrComment)] as? String
    }
}

public protocol CreatorDesignatableSecureStorable {
    /// The creator of the item in the secure storage container.
    var creator: UInt? { get }
}

public extension CreatorDesignatableSecureStorable {
    var creator: UInt? { return nil }
    
    private var creatorDesignatableSecureStoragePropertyDictionary: [String: AnyObject] {
        return Dictionary(withoutOptionalValues: [String(kSecAttrCreator): self.creator])
    }
}

public protocol CreatorDesignatableSecureStorableResultType: CreatorDesignatableSecureStorable, SecureStorableResultType {}

public extension CreatorDesignatableSecureStorableResultType {
    var creator: UInt? {
        return self.resultDictionary[String(kSecAttrCreator)] as? UInt
    }
}

public protocol LabellableSecureStorable {
    /// A label for the item in the secure storage container.
    var label: String? { get }
}

public extension LabellableSecureStorable {
    var label: String? { return nil }
    
    private var labellableSecureStoragePropertyDictionary: [String: AnyObject] {
        return Dictionary(withoutOptionalValues: [String(kSecAttrLabel): self.label])
    }
}

public protocol LabellableSecureStorableResultType: LabellableSecureStorable, SecureStorableResultType {}

public extension LabellableSecureStorableResultType {
    var label: String? {
        return self.resultDictionary[String(kSecAttrLabel)] as? String
    }
}

public protocol TypeDesignatableSecureStorable {
    /// The type of the stored item
    var type: UInt? { get }
}

public extension TypeDesignatableSecureStorable {
    var type: UInt? { return nil }
    
    private var typeDesignatableSecureStoragePropertyDictionary: [String: AnyObject] {
        return Dictionary(withoutOptionalValues: [String(kSecAttrType): self.type])
    }
}

public protocol TypeDesignatableSecureStorableResultType: TypeDesignatableSecureStorable, SecureStorableResultType {}

public extension TypeDesignatableSecureStorableResultType {
    var type: UInt? {
        return self.resultDictionary[String(kSecAttrType)] as? UInt
    }
}

public protocol IsInvisibleAssignableSecureStorable {
    var isInvisible: Bool? { get }
}

public extension IsInvisibleAssignableSecureStorable {
    var isInvisible: Bool? { return nil }
    
    private var isInvisibleSecureStoragePropertyDictionary: [String: AnyObject] {
        return Dictionary(withoutOptionalValues: [String(kSecAttrIsInvisible): self.isInvisible])
    }
}

public protocol IsInvisibleAssignableSecureStorableResultType: IsInvisibleAssignableSecureStorable, SecureStorableResultType {}

public extension IsInvisibleAssignableSecureStorableResultType {
    var isInvisible: Bool? {
        return self.resultDictionary[String(kSecAttrIsInvisible)] as? Bool
    }
}

public protocol IsNegativeAssignableSecureStorable {
    var isNegative: Bool? { get }
}

public extension IsNegativeAssignableSecureStorable {
    var isNegative: Bool? { return nil }
    
    private var isNegativeSecureStoragePropertyDictionary: [String: AnyObject] {
        return Dictionary(withoutOptionalValues: [String(kSecAttrIsNegative): self.isNegative])
    }
}

public protocol IsNegativeAssignableSecureStorableResultType: IsNegativeAssignableSecureStorable, SecureStorableResultType {
}

public extension IsNegativeAssignableSecureStorableResultType {
    var isNegative: Bool? {
        return self.resultDictionary[String(kSecAttrIsNegative)] as? Bool
    }
}

// MARK: - GenericPasswordSecureStorable
/// The protocol that indicates a type conforms to the requirements of a generic password item in a secure storage container.
/// Generic passwords are the most common types of things that are stored securely.
public protocol GenericPasswordSecureStorable: AccountBasedSecureStorable, DescribableSecureStorable, CommentableSecureStorable, CreatorDesignatableSecureStorable, LabellableSecureStorable, TypeDesignatableSecureStorable, IsInvisibleAssignableSecureStorable, IsNegativeAssignableSecureStorable {
    
    /// The service to which the type belongs
    var service: String { get }
    
    // Optional properties
    var generic: NSData? { get }
}

// Add extension to allow for optional properties in protocol
public extension GenericPasswordSecureStorable {
    var generic: NSData? { return nil}
}

// dear god what have i done...
public protocol GenericPasswordSecureStorableResultType: GenericPasswordSecureStorable, SecureStorableResultType, AccountBasedSecureStorableResultType, DescribableSecureStorableResultType, CommentableSecureStorableResultType, CreatorDesignatableSecureStorableResultType, LabellableSecureStorableResultType, TypeDesignatableSecureStorableResultType, IsInvisibleAssignableSecureStorableResultType, IsNegativeAssignableSecureStorableResultType {}

public extension GenericPasswordSecureStorableResultType {
    var service: String {
        return self.resultDictionary[String(kSecAttrService)] as! String
    }
    
    var generic: NSData? {
        return self.resultDictionary[String(kSecAttrGeneric)] as? NSData
    }
}

// MARK: - InternetPasswordSecureStorable
/// A protocol that indicates a type conforms to the requirements of an internet password in a secure storage container.
public protocol InternetPasswordSecureStorable: AccountBasedSecureStorable, DescribableSecureStorable, CommentableSecureStorable, CreatorDesignatableSecureStorable, TypeDesignatableSecureStorable, IsInvisibleAssignableSecureStorable, IsNegativeAssignableSecureStorable {
    var server: String { get }
    var port: Int { get }
    var internetProtocol: LocksmithInternetProtocol { get }
    var authenticationType: LocksmithInternetAuthenticationType { get }
    var securityDomain: String? { get }
    var path: String? { get }
}

public extension InternetPasswordSecureStorable {
    var securityDomain: String? { return nil }
    var path: String? { return nil }
}

public protocol InternetPasswordSecureStorableResultType: AccountBasedSecureStorableResultType, DescribableSecureStorableResultType, CommentableSecureStorableResultType, CreatorDesignatableSecureStorableResultType, TypeDesignatableSecureStorableResultType, IsInvisibleAssignableSecureStorableResultType, IsNegativeAssignableSecureStorableResultType {}

public extension InternetPasswordSecureStorableResultType {
    private func stringFromResultDictionary(key: CFString) -> String? {
        return self.resultDictionary[String(key)] as? String
    }
    
    var server: String {
        return stringFromResultDictionary(kSecAttrServer)!
    }
    
    var port: Int {
        return self.resultDictionary[String(kSecAttrPort)] as! Int
    }
    
    var internetProtocol: LocksmithInternetProtocol {
        return LocksmithInternetProtocol(rawValue: stringFromResultDictionary(kSecAttrProtocol)!)!
    }
    
    var authenticationType: LocksmithInternetAuthenticationType {
        return LocksmithInternetAuthenticationType(rawValue:  stringFromResultDictionary(kSecAttrAuthenticationType)!)!
    }
    
    var securityDomain: String? {
        return stringFromResultDictionary(kSecAttrSecurityDomain)
    }
    
    var path: String? {
        return stringFromResultDictionary(kSecAttrPath)
    }
}

// MARK: - CertificateSecureStorable

public protocol CertificateSecureStorable: SecureStorable {}

// MARK: - KeySecureStorable

public protocol KeySecureStorable: SecureStorable {}

// MARK: - CreateableSecureStorable

/// Conformance to this protocol indicates that your type is able to be created and saved to a secure storage container.
public protocol CreateableSecureStorable: SecureStorable {
    var data: [String: AnyObject] { get }
    func createInSecureStore() throws
}

// MARK: - ReadableSecureStorable
/// Conformance to this protocol indicates that your type is able to be read from a secure storage container.
public protocol ReadableSecureStorable: SecureStorable {
    func readFromSecureStore() -> SecureStorableResultType?
}


// MARK: - DeleteableSecureStorable
/// Conformance to this protocol indicates that your type is able to be deleted from a secure storage container.
public protocol DeleteableSecureStorable: SecureStorable {
    func deleteFromSecureStore() throws
}

public extension Dictionary {
    init(withoutOptionalValues initial: Dictionary<Key, Value?>) {
        self = [Key: Value]()
        for pair in initial {
            if pair.1 != nil {
                self[pair.0] = pair.1!
            }
        }
    }
    
    init(pairs: [(Key, Value)]) {
        self = [Key: Value]()
        pairs.forEach { (k, v) -> () in
            self[k] = v
        }
    }
    
    init(initial: Dictionary<Key, Value>, toMerge: Dictionary<Key, Value>) {
        self = Dictionary<Key, Value>()
        
        for pair in initial {
            self[pair.0] = pair.1
        }
        
        for pair in toMerge {
            self[pair.0] = pair.1
        }
    }
}

// MARK: - Default property dictionaries

public extension SecureStorable where Self : GenericPasswordSecureStorable {
    private var genericPasswordBaseStoragePropertyDictionary: [String: AnyObject] {
        var dictionary = [String: AnyObject?]()
        
        dictionary[String(kSecAttrService)] = self.service
        dictionary[String(kSecAttrGeneric)] = self.generic
        dictionary[String(kSecClass)] = LocksmithSecurityClass.GenericPassword.rawValue
        
        dictionary = Dictionary(initial: dictionary, toMerge: self.describableSecureStoragePropertyDictionary)
        
        let toMergeWith = [
            self.secureStorableBaseStoragePropertyDictionary,
            self.accountSecureStoragePropertyDictionary,
            self.describableSecureStoragePropertyDictionary,
            self.commentableSecureStoragePropertyDictionary,
            self.creatorDesignatableSecureStoragePropertyDictionary,
            self.typeDesignatableSecureStoragePropertyDictionary,
            self.labellableSecureStoragePropertyDictionary,
            self.isInvisibleSecureStoragePropertyDictionary,
            self.isNegativeSecureStoragePropertyDictionary
        ]
        
        for dict in toMergeWith {
            dictionary = Dictionary(initial: dictionary, toMerge: dict)
        }
        
        return Dictionary(withoutOptionalValues: dictionary)
    }
}

public extension CreateableSecureStorable where Self : GenericPasswordSecureStorable {
    var asCreateableSecureStoragePropertyDictionary: [String: AnyObject] {
        var old = self.genericPasswordBaseStoragePropertyDictionary
        old[String(kSecValueData)] = NSKeyedArchiver.archivedDataWithRootObject(self.data)
        return old
    }
}

public extension ReadableSecureStorable where Self : GenericPasswordSecureStorable {
    var asReadableSecureStoragePropertyDictionary: [String: AnyObject] {
        var old = self.genericPasswordBaseStoragePropertyDictionary
        old[String(kSecReturnData)] = true
        old[String(kSecMatchLimit)] = kSecMatchLimitOne
        old[String(kSecReturnAttributes)] = kCFBooleanTrue
        
        return old
    }
}

public extension DeleteableSecureStorable where Self : GenericPasswordSecureStorable {
    var asDeleteableSecureStoragePropertyDictionary: [String: AnyObject] {
        return self.genericPasswordBaseStoragePropertyDictionary
    }
}


// MARK: InternetPasswordSecureStorable

public extension SecureStorable where Self : InternetPasswordSecureStorable {
    private var internetPasswordBaseStoragePropertyDictionary: [String: AnyObject] {
        var dictionary = [String: AnyObject]()
        
        // add in whatever turns out to be required...
        dictionary[String(kSecAttrServer)] = self.server
        dictionary[String(kSecAttrPort)] = self.port
        dictionary[String(kSecAttrProtocol)] = self.internetProtocol.rawValue
        dictionary[String(kSecAttrAuthenticationType)] = self.authenticationType.rawValue
        dictionary[String(kSecAttrSecurityDomain)] = self.securityDomain
        dictionary[String(kSecAttrPath)] = self.path
        dictionary[String(kSecClass)] = LocksmithSecurityClass.InternetPassword.rawValue
        
        let toMergeWith = [
            self.accountSecureStoragePropertyDictionary,
            self.describableSecureStoragePropertyDictionary,
            self.commentableSecureStoragePropertyDictionary,
            self.creatorDesignatableSecureStoragePropertyDictionary,
            self.typeDesignatableSecureStoragePropertyDictionary,
            self.isInvisibleSecureStoragePropertyDictionary,
            self.isNegativeSecureStoragePropertyDictionary
        ]
        
        for dict in toMergeWith {
            dictionary = Dictionary(initial: dictionary, toMerge: dict)
        }
        
        return dictionary
    }
}

public extension CreateableSecureStorable where Self : InternetPasswordSecureStorable {
    var asCreateableSecureStoragePropertyDictionary: [String: AnyObject] {
        var old = self.internetPasswordBaseStoragePropertyDictionary
        old[String(kSecValueData)] = NSKeyedArchiver.archivedDataWithRootObject(self.data)
        return old
    }
}

public extension ReadableSecureStorable where Self : InternetPasswordSecureStorable {
    var asReadableSecureStoragePropertyDictionary: [String: AnyObject] {
        var old = self.internetPasswordBaseStoragePropertyDictionary
        old[String(kSecReturnData)] = true
        old[String(kSecMatchLimit)] = kSecMatchLimitOne
        old[String(kSecReturnAttributes)] = kCFBooleanTrue
        return old
    }
}

public extension DeleteableSecureStorable where Self : InternetPasswordSecureStorable {
    var asDeleteableSecureStoragePropertyDictionary: [String: AnyObject] {
        return self.internetPasswordBaseStoragePropertyDictionary
    }
}

public extension CreateableSecureStorable {
    var performCreateRequestClosure: PerformRequestClosureType {
        return { (requestReference: CFDictionaryRef, inout result: AnyObject?) in
            return withUnsafeMutablePointer(&result) { SecItemAdd(requestReference, UnsafeMutablePointer($0)) }
        }
    }
    
    func createInSecureStore() throws {
//        try performSecureStorageAction(performCreateRequestClosure, secureStoragePropertyDictionary: self.asC)
    }
}

public extension CreateableSecureStorable where Self : InternetPasswordSecureStorable {
    func createInSecureStore() throws {
        try performSecureStorageAction(performCreateRequestClosure, secureStoragePropertyDictionary: self.asCreateableSecureStoragePropertyDictionary)
    }
}

public extension CreateableSecureStorable where Self : GenericPasswordSecureStorable {
    func createInSecureStore() throws {
        try performSecureStorageAction(performCreateRequestClosure, secureStoragePropertyDictionary: self.asCreateableSecureStoragePropertyDictionary)
    }
}

public extension ReadableSecureStorable {
    var performReadRequestClosure: PerformRequestClosureType {
        return { (requestReference: CFDictionaryRef, inout result: AnyObject?) in
            return withUnsafeMutablePointer(&result) { SecItemCopyMatching(requestReference, UnsafeMutablePointer($0)) }
        }
    }
    
    func readFromSecureStore() -> SecureStorableResultType? {
        // This must be implemented here so that we can properly override it in the type-specific implementations
        return nil
    }
}

struct GenericPasswordResult: GenericPasswordSecureStorableResultType {
    var resultDictionary: [String: AnyObject]
}

public extension ReadableSecureStorable where Self : GenericPasswordSecureStorable {
    func readFromSecureStore() -> GenericPasswordSecureStorableResultType? {
        do {
            let result = try performSecureStorageAction(performReadRequestClosure, secureStoragePropertyDictionary: self.asReadableSecureStoragePropertyDictionary)
            return GenericPasswordResult(resultDictionary: result!)
        } catch {
            print(error)
            return nil
        }
    }
}

struct InternetPasswordResult: InternetPasswordSecureStorableResultType {
    var resultDictionary: [String: AnyObject]
}

public extension ReadableSecureStorable where Self : InternetPasswordSecureStorable {
    func readFromSecureStore() -> InternetPasswordSecureStorableResultType? {
        do {
            let result = try performSecureStorageAction(performReadRequestClosure, secureStoragePropertyDictionary: self.asReadableSecureStoragePropertyDictionary)
            return InternetPasswordResult(resultDictionary: result!)
        } catch {
            print(error)
            return nil
        }
    }
}

public extension DeleteableSecureStorable {
    var performDeleteRequestClosure: PerformRequestClosureType {
        return { (requestReference, _) in
            return SecItemDelete(requestReference)
        }
    }
}

public extension DeleteableSecureStorable where Self : GenericPasswordSecureStorable {
    func deleteFromSecureStore() throws {
        try performSecureStorageAction(performDeleteRequestClosure, secureStoragePropertyDictionary: self.asDeleteableSecureStoragePropertyDictionary)
    }
}

public extension DeleteableSecureStorable where Self : InternetPasswordSecureStorable {
    func deleteFromSecureStore() throws {
        try performSecureStorageAction(performDeleteRequestClosure, secureStoragePropertyDictionary: self.asDeleteableSecureStoragePropertyDictionary)
    }
}

// MARK: - Locksmith
public struct Locksmith {
    public static func loadDataForUserAccount(userAccount: String, inService service: String = LocksmithDefaultService) -> [String: AnyObject]? {
        struct ReadRequest: GenericPasswordSecureStorable, ReadableSecureStorable {
            let service: String
            let account: String
        }
        
        let request = ReadRequest(service: service, account: userAccount)
        return request.readFromSecureStore()?.data
    }
    
    public static func saveData(data: [String: AnyObject], forUserAccount userAccount: String, inService service: String = LocksmithDefaultService) throws {
        struct CreateRequest: GenericPasswordSecureStorable, CreateableSecureStorable {
            let service: String
            let account: String
            let data: [String: AnyObject]
        }
        
        let request = CreateRequest(service: service, account: userAccount, data: data)
        return try request.createInSecureStore()
    }
    
    public static func deleteDataForUserAccount(userAccount: String, inService service: String = LocksmithDefaultService) throws {
        struct DeleteRequest: GenericPasswordSecureStorable, DeleteableSecureStorable {
            let service: String
            let account: String
        }
        
        let request = DeleteRequest(service: service, account: userAccount)
        return try request.deleteFromSecureStore()
    }
    
    public static func updateData(data: [String: AnyObject], forUserAccount userAccount: String, inService service: String = LocksmithDefaultService) throws {
        // Delete and then re-save
        do {
            try Locksmith.deleteDataForUserAccount(userAccount, inService: service)
        } catch {
            // Deletion is likely to fail if the piece of data doesn't exist yet.
            // This doesn't matter--we only tell the user about errors on the save request.
        }
        
        return try Locksmith.saveData(data, forUserAccount: userAccount, inService: service)
    }
}
