//
//  LocalCollectionViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/8/24.
//

import UIKit

final class LocalCollectionViewCell: BaseCollectionViewCell {

	let imageView = UIImageView(frame: .zero)
	let cityLabel = UILabel()

	override func configureHierarchy() {
		contentView.addSubview(imageView)
		contentView.addSubview(cityLabel)
	}

	override func configureLayout() {
		imageView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalToSuperview()
//			make.width.equalTo(32)
			make.height.equalTo(imageView.snp.width)
		}
		cityLabel.snp.makeConstraints { make in
			make.top.equalTo(imageView.snp.bottom).offset(4)
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(16)

		}
	}

	override func configureCell() {
		imageView.backgroundColor = .clear
		cityLabel.backgroundColor = .clear
		cityLabel.font = .boldSystemFont(ofSize: 8)
		cityLabel.textAlignment = .center

	}
}