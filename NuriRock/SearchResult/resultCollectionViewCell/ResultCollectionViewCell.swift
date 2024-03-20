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
		 view.layer.cornerRadius = 12
		 return view
	 }()



	 let mainLabel = {
		 let view = UILabel()
//		 view.text = "테스트"
		 view.textColor = .black
		 view.font = .boldSystemFont(ofSize: 14)
		 view.numberOfLines = 0
		 return view
	 }()

	let lineView = {
		let view = UIView()
		view.backgroundColor = .systemBlue
		return view
	}()

	let addrLabel = {
		let view = UILabel()
		view.textColor = .darkGray
		view.font = .systemFont(ofSize: 13)
		view.numberOfLines = 0
		return view
	}()

	let bookmarkButton = {
		let view = UIButton()
		view.backgroundColor = .green
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
			 make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-4)
			 make.bottom.equalTo(lineView.snp.top).offset(-2)
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

	 }

	 override func prepareForReuse() {
		 super.prepareForReuse()

		 mainImageView.image = nil
	 }

	 func updateUI(_ itemIdentifier: Item) {
		 //이전에 cellForItemAt 부분

 //			var content = UIListContentConfiguration.subtitleCell()
 //			content.text = itemIdentifier.author

//		 backgroundColor = .lightGray

		 let fullTitle = itemIdentifier.title
		 let searchText = searchKeyword

		 let searchKeyword = NSAttributedString.highlight(searchText: searchText, in: fullTitle, highlightColor: .systemBlue, textColor: .black, font: .boldSystemFont(ofSize: 14))
		 mainLabel.attributedText = searchKeyword

		 let url = URL(string: itemIdentifier.firstimage)
		 mainImageView.kf.setImage(with: url)


		 addrLabel.text = itemIdentifier.addr1


		 //string > URL > Data > UIImage

		 
//		 DispatchQueue.global().async {
//
//			 let url = URL(string: itemIdentifier.firstimage)!
//
//			 //동기처리되어 계속 기다림
//			 guard let data = try? Data(contentsOf: url) else {
//
//				 DispatchQueue.main.async {
//
//					 self.mainImageView.image = UIImage(systemName: "star.fill")
//
//				 }
//				 return
//			 }
//
//
//			 DispatchQueue.main.async {
// //					content.image = UIImage(data: data!)
// //					content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
// //					print("!1111")
// //
// //					cell.contentConfiguration = content
//				 self.mainImageView.image = UIImage(data: data)
//			 }
//		 } 
	 }

	 required init?(coder: NSCoder) {
		 fatalError("init(coder:) has not been implemented")
	 }

 }
