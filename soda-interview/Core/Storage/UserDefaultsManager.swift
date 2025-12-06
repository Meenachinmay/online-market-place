import Foundation

protocol UserDefaultsManagerProtocol {
    func markEmailAsUnconfirmed(_ email: String)
    func markEmailAsConfirmed(_ email: String)
    func isEmailUnconfirmed(_ email: String) -> Bool
    func getUnconfirmedEmails() -> Set<String>
    func getLastRegisteredEmail() -> String?
    func clearAll()
}

class UserDefaultsManager: UserDefaultsManagerProtocol {
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    private enum Keys: String {
        case unconfirmedEmails = "unconfirmed_emails"
        case lastRegisteredEmail = "last_registered_email"
    }
    
    // Mark email as unconfirmed
    func markEmailAsUnconfirmed(_ email: String) {
        var unconfirmedEmails = getUnconfirmedEmails()
        unconfirmedEmails.insert(email.lowercased())
        userDefaults.set(Array(unconfirmedEmails), forKey: Keys.unconfirmedEmails.rawValue)
        
        // Also store as last registered email for easy access
        userDefaults.set(email.lowercased(), forKey: Keys.lastRegisteredEmail.rawValue)
    }
    
    // Mark email as confirmed
    func markEmailAsConfirmed(_ email: String) {
        var unconfirmedEmails = getUnconfirmedEmails()
        unconfirmedEmails.remove(email.lowercased())
        userDefaults.set(Array(unconfirmedEmails), forKey: Keys.unconfirmedEmails.rawValue)
        
        // Clear last registered email after confirmation
        userDefaults.removeObject(forKey: Keys.lastRegisteredEmail.rawValue)
    }
    
    // Check if email is unconfirmed
    func isEmailUnconfirmed(_ email: String) -> Bool {
        let unconfirmedEmails = getUnconfirmedEmails()
        return unconfirmedEmails.contains(email.lowercased())
    }
    
    // Get all unconfirmed emails
    func getUnconfirmedEmails() -> Set<String> {
        let emails = userDefaults.stringArray(forKey: Keys.unconfirmedEmails.rawValue) ?? []
        return Set(emails)
    }
    
    // Get last registered email (for pre-filling)
    func getLastRegisteredEmail() -> String? {
        return userDefaults.string(forKey: Keys.lastRegisteredEmail.rawValue)
    }
    
    // Clear all stored data
    func clearAll() {
        userDefaults.removeObject(forKey: Keys.unconfirmedEmails.rawValue)
        userDefaults.removeObject(forKey: Keys.lastRegisteredEmail.rawValue)
    }
}
