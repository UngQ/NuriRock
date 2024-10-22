//
//  ResultCollectionViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/15/24.
//

import UIKit


final class ResultCollectionViewCell: UICollectionViewCell {

	 let mainImageView = {
		 let view = UIImageView(frame: .zero)
		 view.contentMode = .scaleAspectFill
		 view.clipsToBounds = true
		 view.layer.cornerRadius = 10
		 return view
	 }()



	 let mainLabel = {
		 let view = UILabel()
//		 view.text = "테스트"
		 view.textColor = .text
		 view.font = .boldSystemFont(ofSize: 14)
		 view.numberOfLines = 0
		 return view
	 }()

	let lineView = {
		let view = UIView()
		view.backgroundColor = .point
		return view
	}()

	let addrLabel = {
		let view = UILabel()
		view.textColor = .lightGray
		view.font = .systemFont(ofSize: 13)
		view.numberOfLines = 0
		return view
	}()

	let bookmarkButton = {
		let view = IndexedButton()
		view.tintColor = .point
		return view
	}()

	let mapButton = {
		let view = IndexedButton()
		view.setImage(UIImage(systemName: "map"), for: .normal)
		view.tintColor = .point
		return view
	}()

	var searchKeyword: String = ""

	 override init(frame: CGRect) {
		 super.init(frame: frame)

		 contentView.addSubview(mainImageView)
		 contentView.addSubview(lineView)
		 contentView.addSubview(mainLabel)
		 contentView.addSubview(addrLabel)
		 contentView.addSubview(bookmarkButton)
		 contentView.addSubview(mapButton)

		 mainImageView.snp.makeConstraints { make in
			 make.size.equalTo(72)
			 make.leading.centerY.equalTo(self.safeAreaLayoutGuide)

		 }

		 lineView.snp.makeConstraints { make in
			 make.leading.equalTo(mainImageView.snp.trailing).offset(4)
			 make.centerY.equalToSuperview()
			 make.trailing.equalToSuperview()
			 make.height.equalTo(1)
		 }



		 bookmarkButton.snp.makeConstraints { make in
			 make.top.equalToSuperview()
			 make.trailing.equalTo(self.safeAreaLayoutGuide)
			 make.bottom.equalTo(lineView.snp.top).offset(-2)
			 make.width.equalTo(bookmarkButton.snp.height)
		 }

		 mapButton.snp.makeConstraints { make in
			 make.bottom.equalToSuperview()
			 make.trailing.equalTo(self.safeAreaLayoutGuide)
			 make.top.equalTo(lineView.snp.top).offset(2)
			 make.width.equalTo(bookmarkButton.snp.height)
		 }

		 mainLabel.snp.makeConstraints { make in
			 make.leading.equalTo(mainImageView.snp.trailing).offset(4)
			 make.trailing.equalTo(bookmarkButton.snp.leading).offset(-4)
			 make.bottom.equalTo(lineView.snp.top).offset(-2)
			 make.height.greaterThanOrEqualTo(0)
//			 make.top.equalToSuperview()

		 }
		 addrLabel.snp.makeConstraints { make in
			 make.top.equalTo(lineView.snp.bottom).offset(2)
			 make.leading.equalTo(mainImageView.snp.trailing).offset(4)
			 make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-4)
			 make.height.greaterThanOrEqualTo(0)

		 }

		 backgroundColor = .background
		 layer.shadowColor = UIColor.lightGray.cgColor
		  layer.shadowOpacity = 0.2
		  layer.shadowRadius = 2
		 layer.shadowOffset = CGSize(width: 2, height: 2)
		 layer.cornerRadius = 10
		 layer.masksToBounds = false

		 contentView.layer.cornerRadius = 10
		 contentView.layer.masksToBounds = true

	 }

	 override func prepareForReuse() {
		 super.prepareForReuse()

		 mainImageView.image = nil
	 }

	 func updateUI(_ itemIdentifier: Item) {
		 //이전에 cellForItemAt 부분

		 let fullTitle = itemIdentifier.title
		 let searchText = searchKeyword

		 let searchKeyword = NSAttributedString.highlight(searchText: searchText, in: fullTitle, highlightColor: .point, textColor: .text, font: .boldSystemFont(ofSize: 14))
		 mainLabel.attributedText = searchKeyword

		 let url = URL(string: itemIdentifier.firstimage)
		 mainImageView.kf.indicatorType = .activity
		 mainImageView.kf.setImage(with: url)


		 addrLabel.text = itemIdentifier.addr1
	 }

	func updateUIInBookmarkVC(_ itemIdentifier: Bookmark) {
		//이전에 cellForItemAt 부분

		let fullTitle = itemIdentifier.title
		let searchText = searchKeyword

		let searchKeyword = NSAttributedString.highlight(searchText: searchText, in: fullTitle, highlightColor: .point, textColor: .text, font: .boldSystemFont(ofSize: 14))
		mainLabel.attributedText = searchKeyword

		let url = URL(string: itemIdentifier.firstimage)
		mainImageView.kf.indicatorType = .activity
		mainImageView.kf.setImage(with: url)


		addrLabel.text = itemIdentifier.addr1
	}

	 required init?(coder: NSCoder) {
		 fatalError("init(coder:) has not been implemented")
	 }

 }
