//
//  PokemonDetailHeaderView.swift
//  Ronaldo
//
//  Created by Doko Farras on 21/03/25.
//

import UIKit
import SnapKit
import Kingfisher

class PokemonDetailHeaderView: UIView {
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        
        imageView.contentMode = .scaleAspectFit
        
        addSubview(imageView)
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
    }
    
    func configure(with pokemon: PokemonDetail) {
        nameLabel.text = pokemon.name.capitalized
        if let imageUrl = URL(string: pokemon.sprites.other.officialArtwork.frontDefault) {
            imageView.kf.setImage(with: imageUrl)
        }
    }
}
