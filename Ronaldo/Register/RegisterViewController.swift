//
//  RegisterViewController.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MBProgressHUD

class RegisterViewController: UIViewController {
    
    private let fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your full name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm your password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Passwords do not match"
        label.textColor = .red
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    private let viewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(fullNameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(passwordErrorLabel)
        view.addSubview(registerButton)
        view.addSubview(messageLabel)
        
        fullNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(fullNameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordErrorLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func bindViewModel() {
        fullNameTextField.rx.text.orEmpty
            .bind(to: viewModel.fullNameText)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordText)
            .disposed(by: disposeBag)
        
        confirmPasswordTextField.rx.text.orEmpty
            .bind(to: viewModel.confirmPasswordText)
            .disposed(by: disposeBag)
        
        viewModel.isPasswordMatching
            .subscribe(onNext: { [weak self] isMatching in
                self?.passwordErrorLabel.isHidden = isMatching
            })
            .disposed(by: disposeBag)
        
        viewModel.isRegisterEnabled
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.register()
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.showLoading()
                } else {
                    self.hideLoading()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.registerResult
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.hideErrorMessage()
                    self?.navigateToLanding()
                } else {
                    self?.showErrorMessage("Email already registered or invalid data")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showLoading() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Logging in..."
    }
    
    private func hideLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    private func showErrorMessage(_ message: String) {
        messageLabel.isHidden = false
        messageLabel.text = message
        messageLabel.textColor = .red
    }
    
    private func hideErrorMessage() {
        messageLabel.isHidden = true
    }
    
    private func navigateToLanding() {
        let landingVC = LandingViewController()
        let navController = UINavigationController(rootViewController: landingVC)
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        
        window.rootViewController = navController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}
