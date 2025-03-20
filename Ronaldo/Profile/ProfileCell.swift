//
//  ProfileCell.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import UIKit

class ProfileCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        valueLabel.text = value
        valueLabel.textColor = .darkGray
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
