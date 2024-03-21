//
//  ResultCollectionViewSectionHeaderView.swift
//  NuriRock
//
//  Created by ungQ on 3/15/24.
//

import UIKit

final class ResultCollectionViewSectionHeaderView: UICollectionReusableView {
	static let identifier = "SectionHeaderView"

	let titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .text
		label.font = UIFont.boldSystemFont(ofSize: 16)
		return label
	}()
//
//	public func configure(title: String) {
//		titleLabel.text = title
//	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(titleLabel)
		titleLabel.frame = bounds
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
