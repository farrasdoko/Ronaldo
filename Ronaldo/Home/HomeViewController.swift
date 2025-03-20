//
//  HomeViewController.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import UIKit
import SnapKit
import XLPagerTabStrip

class HomeViewController: UIViewController {
    
    var itemInfo: IndicatorInfo = "Home"
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome!"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(welcomeLabel)
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.left.right.equalToSuperview().inset(20)
        }
        
        if let user = SessionManager.shared.getUser() {
            welcomeLabel.text = "Welcome, \(user.fullName)!"
        }
    }

}

extension HomeViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
