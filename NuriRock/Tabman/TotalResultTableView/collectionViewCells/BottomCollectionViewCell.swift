//
//  BottomCollectionViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/10/24.
//

import UIKit

class BottomCollectionViewCell: BaseCollectionViewCell {

	let posterImageView = UIImageView(frame: .zero)
	let emptyLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	override func prepareForReuse() {
		posterImageView.image = .none
		emptyLabel.text = ""
	}


	override func configureHierarchy() {
		contentView.addSubview(posterImageView)
		contentView.addSubview(emptyLabel)
	}

	override func configureLayout() {
		posterImageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		emptyLabel.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}

	override func configureCell() {
		

		posterImageView.clipsToBounds = true
		posterImageView.layer.cornerRadius = 20
		posterImageView.contentMode = .scaleAspectFill

		emptyLabel.font = .boldSystemFont(ofSize: 20)
		emptyLabel.textAlignment = .center
		emptyLabel.numberOfLines = 0

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
