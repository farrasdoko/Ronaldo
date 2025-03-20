//
//  LoginViewModel.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    // MARK: Inputs
    let emailText = BehaviorRelay<String>(value: "")
    let passwordText = BehaviorRelay<String>(value: "")
    
    // MARK: Outputs
    var isLoginEnabled: Observable<Bool> {
        return Observable.combineLatest(emailText, passwordText)
            .map { !$0.isEmpty && !$1.isEmpty }
    }
    let loginResult = PublishSubject<Bool>()
    
    // MARK: Progress
    func login() {
        let email = emailText.value
        let password = passwordText.value
        let user = DatabaseManager.shared.getUser(email: email, password: password)
        
        if let user {
            SessionManager.shared.saveUser(user)
        }
        
        loginResult.onNext(user != nil)
    }
}
