//
//  BaseTableViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/9/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
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
