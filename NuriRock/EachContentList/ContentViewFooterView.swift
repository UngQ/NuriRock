//
//  ContentViewFooterView.swift
//  NuriRock
//
//  Created by ungQ on 3/17/24.
//

import UIKit

final class ContentViewFooterView: UICollectionReusableView {
	static let identifier = "SectionFooterView"

	let seeMoreButton: UIButton = {
		let label = UIButton()
		label.setTitle(NSLocalizedString(LocalString.seemore.rawValue, comment: ""), for: .normal)
		return label
	}()


	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(seeMoreButton)
		seeMoreButton.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
			make.width.equalTo(100)
			make.height.equalTo(40)
		}
		seeMoreButton.backgroundColor = .blue

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
