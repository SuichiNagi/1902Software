//
//  KeychainService.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/18/24.
//

import Foundation
import Security

class KeychainService {
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query)
        return SecItemAdd(query, nil)
    }

    class func load(key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
}

class AuthService {
    static let shared = AuthService()
    
    func saveLoginDetails(token: String, rememberMe: Bool) {
        if rememberMe {
            UserDefaults.standard.set(true, forKey: "rememberMe")
            let tokenData = Data(token.utf8)
            _ = KeychainService.save(key: "sessionToken", data: tokenData)
        }
    }
    
    func isUserLoggedIn() -> Bool {
        let rememberMe = UserDefaults.standard.bool(forKey: "rememberMe")
        if rememberMe, let _ = KeychainService.load(key: "sessionToken") {
            return true
        }
        return false
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "rememberMe")
        let tokenData = Data()
        _ = KeychainService.save(key: "sessionToken", data: tokenData)
    }
}
