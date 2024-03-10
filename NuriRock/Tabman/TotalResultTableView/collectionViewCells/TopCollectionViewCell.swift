//
//  TopCollectionViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/9/24.
//

import UIKit

class TopCollectionViewCell: BaseCollectionViewCell {

	let imageView = UIImageView(frame: .zero)
	let titleLabel = UILabel()
	let addressLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	override func configureHierarchy() {
		contentView.addSubview(imageView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(addressLabel)
	}

	override func configureLayout() {
		imageView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalToSuperview()
			make.height.equalTo(144) //192 - 24 - 24
		}

		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(imageView.snp.bottom)
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(24)
		}

		addressLabel.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom)
			make.horizontalEdges.equalToSuperview()
			make.height.lessThanOrEqualTo(24)
		}
	}

	override func configureCell() {
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 20

		titleLabel.text = "title"
		titleLabel.font = .boldSystemFont(ofSize: 14)

		addressLabel.text = "address"
		addressLabel.font = .systemFont(ofSize: 10)
		addressLabel.numberOfLines = 0

		
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
