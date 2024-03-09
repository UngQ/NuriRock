//
//  CountryCollectionViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/7/24.
//

import UIKit

final class CountryCollectionViewCell: UICollectionViewCell {

	let flagLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)


		configureHierarchy()
		configureLayout()
		configureCell()

	}

	func configureHierarchy() {
		contentView.addSubview(flagLabel)
	}
	func configureLayout() {
		flagLabel.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	func configureCell() {
		flagLabel.font = .systemFont(ofSize: 108)
		flagLabel.textAlignment = .center
		flagLabel.backgroundColor = .blue
		flagLabel.layer.masksToBounds = true
		flagLabel.layer.cornerRadius = (UIScreen.main.bounds.width - 36) / 4

	}




	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
