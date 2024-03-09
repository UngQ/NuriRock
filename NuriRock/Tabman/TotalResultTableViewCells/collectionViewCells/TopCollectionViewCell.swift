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
	

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
