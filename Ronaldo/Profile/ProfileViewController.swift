//
//  ProfileViewController.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import UIKit
import XLPagerTabStrip
import SnapKit
import RxSwift

class ProfileViewController: UIViewController {
    
    var itemInfo: IndicatorInfo = "Profile"
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        return tableView
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let viewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(profileImageView)
        view.addSubview(tableView)
        view.addSubview(logoutButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupActions() {
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.userProfile
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func logoutTapped() {
        viewModel.logout()
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        window.rootViewController = navController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}

extension ProfileViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

// MARK: - Table View Data Source
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else {
            return UITableViewCell()
        }
        
        guard let userProfile = viewModel.userProfile.value else { return UITableViewCell() }
        
        let titles = ["Email", "Full Name", "Password"]
        let values = [userProfile.email, userProfile.fullName, "********"]
        
        cell.configure(title: titles[indexPath.row], value: values[indexPath.row])
        
        return cell
    }
}
