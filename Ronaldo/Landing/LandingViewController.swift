//
//  LandingViewController.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import UIKit
import XLPagerTabStrip
import SnapKit

class LandingViewController: UIViewController {

    private let tabTitles = ["Home", "Profile"]
    private let viewControllers: [UIViewController] = {
        let homeVC = HomeViewController()
        homeVC.itemInfo = IndicatorInfo(title: "Home")

        let profileVC = ProfileViewController()
        profileVC.itemInfo = IndicatorInfo(title: "Profile")

        return [homeVC, profileVC]
    }()
    
    private let tabBarView = ButtonBarView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let pagerVC = PagerTabStripViewController()
    
    private var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPager()
        setupTabBarView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func setupPager() {
        pagerVC.datasource = self
        pagerVC.delegate = self

        addChild(pagerVC)
        view.addSubview(pagerVC.view)
        pagerVC.didMove(toParent: self)
    }

    private func setupTabBarView() {
        tabBarView.backgroundColor = .white
        tabBarView.selectedBar.backgroundColor = .blue
        tabBarView.delegate = self
        tabBarView.dataSource = self
        tabBarView.register(TabCell.self, forCellWithReuseIdentifier: "TabCell")
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(tabBarView)
        view.addSubview(pagerVC.view)

        tabBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        pagerVC.view.snp.makeConstraints { make in
            make.top.equalTo(tabBarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension LandingViewController: PagerTabStripDelegate, PagerTabStripDataSource {
    func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int) {
        selectedIndex = toIndex
        tabBarView.reloadData()
    }

    func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return viewControllers
    }
}

extension LandingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabTitles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as? TabCell else {
            return UICollectionViewCell()
        }
        cell.configure(title: tabTitles[indexPath.item], isSelected: indexPath.item == selectedIndex)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        pagerVC.moveToViewController(at: indexPath.item)
        tabBarView.reloadData()
    }
}
