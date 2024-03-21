//
//  BottomCollectionViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/10/24.
//

import UIKit

final class BottomCollectionViewCell: BaseCollectionViewCell {

	let posterImageView = UIImageView(frame: .zero)
	let emptyLabel = UILabel()
	let detailView = UIView()

	let titleLabel = UILabel()
	let addrLabel = UILabel()
	let dateLabel = UILabel()

	let bookmarkButton = UIButton()

	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	override func prepareForReuse() {
		posterImageView.image = .none
		detailView.isHidden = false
		emptyLabel.isHidden = true
	}


	override func configureHierarchy() {
		contentView.addSubview(posterImageView)
		contentView.addSubview(emptyLabel)
		posterImageView.addSubview(detailView)
		detailView.addSubview(titleLabel)
		detailView.addSubview(addrLabel)
		detailView.addSubview(dateLabel)

		contentView.addSubview(bookmarkButton)
	}

	override func configureLayout() {
		posterImageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		emptyLabel.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

		detailView.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(100)
		}

		addrLabel.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
			make.horizontalEdges.equalToSuperview().inset(4)
			make.height.greaterThanOrEqualTo(20)
		}
		titleLabel.snp.makeConstraints { make in
			make.bottom.equalTo(addrLabel.snp.top).offset(-4)
			make.horizontalEdges.equalToSuperview().inset(4)
			make.height.greaterThanOrEqualTo(20)
		}


		dateLabel.snp.makeConstraints { make in
			make.top.equalTo(addrLabel.snp.bottom).offset(4)
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(20)
		}

		bookmarkButton.snp.makeConstraints { make in
			make.top.trailing.equalTo(posterImageView).inset(12)
			make.size.equalTo(20)
		}

	}

	override func configureCell() {
		backgroundColor = .background
		layer.shadowColor = UIColor.lightGray.cgColor
		 layer.shadowOpacity = 0.2
		 layer.shadowRadius = 2
		layer.shadowOffset = CGSize(width: 2, height: 2)
		layer.cornerRadius = 20
		layer.masksToBounds = false

		contentView.layer.cornerRadius = 10
		contentView.layer.masksToBounds = true

		posterImageView.clipsToBounds = true
		posterImageView.layer.cornerRadius = 20
		posterImageView.contentMode = .scaleAspectFill

		emptyLabel.font = .boldSystemFont(ofSize: 20)
		emptyLabel.textAlignment = .center
		emptyLabel.numberOfLines = 0
		emptyLabel.text = "이 날은 행사가 없습니다. 다른 날짜를 선택해보세요."
		emptyLabel.isHidden = true
		emptyLabel.textColor = .text


		detailView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)


		titleLabel.textColor = .white
		titleLabel.textAlignment = .center
		titleLabel.font = .boldSystemFont(ofSize: 12)
		titleLabel.numberOfLines = 0


		addrLabel.textColor = .white
		addrLabel.textAlignment = .center
		addrLabel.font = .systemFont(ofSize: 10)
		addrLabel.numberOfLines = 0


		dateLabel.textColor = .white
		dateLabel.textAlignment = .center
		dateLabel.font = .systemFont(ofSize: 10)

		bookmarkButton.tintColor = .point

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
