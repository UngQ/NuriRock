//
//  TopCollectionViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/9/24.
//

import UIKit

final class TopCollectionViewCell: BaseCollectionViewCell {


	let imageView = UIImageView(frame: .zero)
	let titleLabel = UILabel()
	let addressLabel = UILabel()

	let bookmarkButtonBackView = UIView()
	let bookmarkButton = UIButton()

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	override func configureHierarchy() {

		contentView.addSubview(imageView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(addressLabel)
		contentView.addSubview(bookmarkButtonBackView)
		bookmarkButtonBackView.addSubview(bookmarkButton)
	}

	override func configureLayout() {

//		view.snp.makeConstraints { make in
//			make.edges.equalToSuperview()
//		}

		imageView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalToSuperview()
			make.height.equalTo(144) //192 - 24 - 24
		}

		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(imageView.snp.bottom).offset(4)
			make.horizontalEdges.equalToSuperview().inset(4)
			make.height.greaterThanOrEqualTo(0)
		}

		addressLabel.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom)
			make.horizontalEdges.equalToSuperview().inset(4)
			make.height.lessThanOrEqualTo(24)
		}
		bookmarkButtonBackView.snp.makeConstraints { make in
			make.bottom.trailing.equalTo(imageView).inset(4)
			make.size.equalTo(24)
		}
		bookmarkButton.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
			make.size.equalTo(16)
		}
	}

	override func configureCell() {
		backgroundColor = .background
		layer.shadowColor = UIColor.lightGray.cgColor
		 layer.shadowOpacity = 0.2
		 layer.shadowRadius = 2
		layer.shadowOffset = CGSize(width: 2, height: 2)
		layer.cornerRadius = 10
		layer.masksToBounds = false

		contentView.layer.cornerRadius = 10
		contentView.layer.masksToBounds = true

//		view.setViewShadow(backView: view)

		imageView.clipsToBounds = true
//		imageView.layer.cornerRadius = 10
		imageView.contentMode = .scaleAspectFill



		titleLabel.font = .boldSystemFont(ofSize: 14)


		addressLabel.font = .systemFont(ofSize: 10)
		addressLabel.textColor = .lightGray
		addressLabel.numberOfLines = 2
		addressLabel.layer.cornerRadius = 10


		bookmarkButtonBackView.layer.cornerRadius = 12
		bookmarkButtonBackView.backgroundColor = .background

		bookmarkButton.tintColor = .point


	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
