//
//  HomeViewController.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import UIKit
import SnapKit
import XLPagerTabStrip
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    var itemInfo: IndicatorInfo = "Home"
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.pokemonList
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, item, cell in
                cell.textLabel?.text = item.name.capitalized
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            viewModel.fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedPokemon = viewModel.pokemonList.value[indexPath.row]
        
        let detailVC = PokemonDetailViewController(pokemonURL: selectedPokemon.url)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
