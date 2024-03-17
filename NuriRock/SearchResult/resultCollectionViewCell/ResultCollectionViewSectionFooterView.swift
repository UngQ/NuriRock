//
//  ResultCollectionViewSectionFooterView.swift
//  NuriRock
//
//  Created by ungQ on 3/16/24.
//

import UIKit

class ResultCollectionViewSectionFooterView: UICollectionReusableView {
	static let identifier = "SectionFooterView"

	let seeMoreButton: UIButton = {
		let label = UIButton()
		label.setTitle(NSLocalizedString(LocalString.seemore.rawValue, comment: ""), for: .normal)
		label.layer.cornerRadius = 8
		label.layer.masksToBounds = true
		label.titleLabel?.font = .boldSystemFont(ofSize: 12)
		label.backgroundColor = .systemBlue
		return label
	}()


	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(seeMoreButton)
		seeMoreButton.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
			make.width.equalTo(100)
			make.height.equalTo(20)
		}
		

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
