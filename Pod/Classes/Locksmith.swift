import Foundation

public let LocksmithDefaultService = NSBundle.mainBundle().infoDictionary![String(kCFBundleIdentifierKey)] as? String ?? "com.locksmith.defaultService"

public typealias PerformRequestClosureType = (requestReference: CFDictionaryRef, inout result: AnyObject?) -> (OSStatus)


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

// MARK: - SecureStorable
/// The base protocol that indicates conforming types will have the ability to be stored in a secure storage container, such as the iOS keychain.
public protocol SecureStorable {
    var accessible: LocksmithAccessibleOption? { get }
    var accessGroup: String? { get }
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
        
        if dictionary[String(kSecValueData)] as? NSData == nil {
            return nil
        }
        
        return result as? [String: AnyObject]
    }
}

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
    var performCreateRequestClosure: PerformRequestClosureType { get }
    func createInSecureStore() throws
}

// MARK: - ReadableSecureStorable
/// Conformance to this protocol indicates that your type is able to be read from a secure storage container.
public protocol ReadableSecureStorable: SecureStorable {
    var performReadRequestClosure: PerformRequestClosureType { get }
    func readFromSecureStore() -> SecureStorableResultType?
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

public extension ReadableSecureStorable where Self : GenericPasswordSecureStorable {
    var asReadableSecureStoragePropertyDictionary: [String: AnyObject] {
        var old = self.genericPasswordBaseStoragePropertyDictionary
        old[String(kSecReturnData)] = true
        old[String(kSecMatchLimit)] = kSecMatchLimitOne
        old[String(kSecReturnAttributes)] = kCFBooleanTrue
        
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


// MARK: - DeleteableSecureStorable
/// Conformance to this protocol indicates that your type is able to be deleted from a secure storage container.
public protocol DeleteableSecureStorable: SecureStorable {
    var performDeleteRequestClosure: PerformRequestClosureType { get }
    func deleteFromSecureStore() throws
}

// MARK: - Default property dictionaries

public extension CreateableSecureStorable where Self : GenericPasswordSecureStorable {
    var asCreateableSecureStoragePropertyDictionary: [String: AnyObject] {
        var old = self.genericPasswordBaseStoragePropertyDictionary
        old[String(kSecValueData)] = NSKeyedArchiver.archivedDataWithRootObject(self.data)
        return old
    }
}

public extension CreateableSecureStorable where Self : GenericPasswordSecureStorable {
    func createInSecureStore() throws {
        try performSecureStorageAction(performCreateRequestClosure, secureStoragePropertyDictionary: self.asCreateableSecureStoragePropertyDictionary)
    }
}

public extension CreateableSecureStorable where Self : InternetPasswordSecureStorable {
    var asCreateableSecureStoragePropertyDictionary: [String: AnyObject] {
        var old = self.internetPasswordBaseStoragePropertyDictionary
        old[String(kSecValueData)] = NSKeyedArchiver.archivedDataWithRootObject(self.data)
        return old
    }
}

public extension CreateableSecureStorable {
    var performCreateRequestClosure: PerformRequestClosureType {
        return { (requestReference: CFDictionaryRef, inout result: AnyObject?) in
            return withUnsafeMutablePointer(&result) { SecItemAdd(requestReference, UnsafeMutablePointer($0)) }
        }
    }
}

public extension CreateableSecureStorable where Self : InternetPasswordSecureStorable {
    func createInSecureStore() throws {
        try performSecureStorageAction(performCreateRequestClosure, secureStoragePropertyDictionary: self.asCreateableSecureStoragePropertyDictionary)
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
    var asDeleteableSecureStoragePropertyDictionary: [String: AnyObject] {
        return self.genericPasswordBaseStoragePropertyDictionary
    }
}

public extension DeleteableSecureStorable where Self : InternetPasswordSecureStorable {
    var asDeleteableSecureStoragePropertyDictionary: [String: AnyObject] {
        return self.internetPasswordBaseStoragePropertyDictionary
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

// MARK: ResultTypes
public protocol SecureStorableResultType: SecureStorable {
    var resultDictionary: [String: AnyObject] { get }
    var data: [String: AnyObject]? { get }
}

struct InternetPasswordResult: InternetPasswordSecureStorableResultType {
    var resultDictionary: [String: AnyObject]
}

public extension SecureStorableResultType {
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
