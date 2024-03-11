//
//  BottomCollectionViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/10/24.
//

import UIKit

class BottomCollectionViewCell: BaseCollectionViewCell {

	let posterImageView = UIImageView(frame: .zero)

	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	

	override func configureHierarchy() {
		contentView.addSubview(posterImageView)
	}

	override func configureLayout() {
		posterImageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}

	override func configureCell() {
		

		posterImageView.clipsToBounds = true
		posterImageView.layer.cornerRadius = 20
		posterImageView.contentMode = .scaleAspectFill
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
