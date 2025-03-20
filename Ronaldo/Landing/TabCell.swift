//
//  TabCell.swift
//  Ronaldo
//
//  Created by Doko Farras on 20/03/25.
//

import UIKit

class TabCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.textColor = isSelected ? .black : .lightGray
    }
}
