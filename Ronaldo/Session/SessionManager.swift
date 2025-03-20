//
//  SessionManager.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    private let userKey = "loggedInUser"
    
    private init() {}
    
    func saveUser(_ user: UserProfile) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: userKey)
        } catch {
            print("Error encoding user: \(error)")
        }
    }
    
    func getUser() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: userKey) else { return nil }
        do {
            return try JSONDecoder().decode(UserProfile.self, from: data)
        } catch {
            print("Error decoding user: \(error)")
            return nil
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
    
    func isLoggedIn() -> Bool {
        return getUser() != nil
    }
}
