//
//  BaseCollectionViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/8/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
	override init(frame: CGRect) {
		super.init(frame: frame)

		configureHierarchy()
		configureLayout()
		configureCell()
	}

	func configureHierarchy() {

	}

	func configureLayout() {


	}

	func configureCell() {

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
