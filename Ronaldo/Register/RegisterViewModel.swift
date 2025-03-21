//
//  RegisterViewModel.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
    
    let fullNameText = BehaviorRelay<String>(value: "")
    let emailText = BehaviorRelay<String>(value: "")
    let passwordText = BehaviorRelay<String>(value: "")
    let confirmPasswordText = BehaviorRelay<String>(value: "")
    
    var isPasswordMatching: Observable<Bool> {
        return Observable.combineLatest(passwordText, confirmPasswordText)
            .map { password, confirmPassword in
                return password == confirmPassword
            }
    }
    
    var isRegisterEnabled: Observable<Bool> {
        return Observable.combineLatest(fullNameText, emailText, passwordText, confirmPasswordText, isPasswordMatching)
            .map { fullName, email, password, confirmPassword, passwordsMatch in
                return !fullName.isEmpty && !email.isEmpty && !password.isEmpty && passwordsMatch
            }
    }
    
    let registerResult = PublishSubject<Bool>()
    let isLoading = PublishSubject<Bool>()
    
    func register() {
        isLoading.onNext(true)
        
        DispatchQueue.global().asyncAfter(deadline: .now()) {
            let fullName = self.fullNameText.value
            let email = self.emailText.value
            let password = self.passwordText.value
            let user = DatabaseManager.shared.insertUser(fullName: fullName, email: email, password: password)
            
            DispatchQueue.main.async {
                self.isLoading.onNext(false)
                if let user {
                    SessionManager.shared.saveUser(user)
                }
                self.registerResult.onNext(user != nil)
            }
        }
    }
}
