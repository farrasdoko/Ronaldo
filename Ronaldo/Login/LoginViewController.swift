//
//  LoginViewController.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MBProgressHUD

class LoginViewController: UIViewController {
    
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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
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
    
    private let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account? Register"
        label.textColor = .blue
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(messageLabel)
        view.addSubview(registerLabel)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func bindViewModel() {
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordText)
            .disposed(by: disposeBag)
        
        viewModel.isLoginEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.login()
            })
            .disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        registerLabel.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                let registerVC = RegisterViewController()
                self?.navigationController?.pushViewController(registerVC, animated: true)
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
        
        viewModel.loginResult
            .subscribe(onNext: { [weak self] success in
                if success {
                    self?.hideErrorMessage()
                    self?.navigateToLanding()
                } else {
                    self?.showErrorMessage("Invalid email or password")
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
