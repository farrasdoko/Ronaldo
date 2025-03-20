//
//  ProfileViewModel.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel {
    
    // MARK: - Outputs
    let userProfile = BehaviorRelay<UserProfile?>(value: nil)
    
    // MARK: - Init
    init() {
        fetchUserProfile()
    }
    
    private func fetchUserProfile() {
        if let currentUser = SessionManager.shared.getUser() {
            userProfile.accept(currentUser)
        }
    }
    
    func logout() {
        SessionManager.shared.logout()
    }
}
