//
//  ResultCollectionViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/15/24.
//

import UIKit


class ResultCollectionViewCell: UICollectionViewCell {

	 private let mainImageView = {
		 let view = UIImageView(frame: .zero)
		 view.contentMode = .scaleAspectFill
		 view.clipsToBounds = true
		 view.layer.cornerRadius = 12
		 view.backgroundColor = .green
		 return view
	 }()

	 private let mainLabel = {
		 let view = UILabel()
		 view.text = "테스트"
		 view.backgroundColor = .black
		 view.textColor = .white
		 view.font = .boldSystemFont(ofSize: 30)
		 return view
	 }()

	 override init(frame: CGRect) {
		 super.init(frame: frame)

		 contentView.addSubview(mainImageView)
		 contentView.addSubview(mainLabel)

		 mainImageView.snp.makeConstraints { make in
			 make.size.equalTo(50)
			 make.leading.centerY.equalTo(self.safeAreaLayoutGuide)

		 }

		 mainLabel.snp.makeConstraints { make in
			 make.leading.equalTo(mainImageView.snp.trailing).offset(20)
			 make.trailing.equalTo(self.safeAreaLayoutGuide)
			 make.height.equalTo(40)
			 make.bottom.equalTo(mainImageView.snp.bottom)
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

		 backgroundColor = .lightGray
		 mainLabel.text = itemIdentifier.title

		 //string > URL > Data > UIImage

		 DispatchQueue.global().async {

			 let url = URL(string: itemIdentifier.firstimage)!

			 //동기처리되어 계속 기다림
			 guard let data = try? Data(contentsOf: url) else {

				 DispatchQueue.main.async {

					 self.mainImageView.image = UIImage(systemName: "star.fill")

				 }
				 return
			 }


			 DispatchQueue.main.async {
 //					content.image = UIImage(data: data!)
 //					content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
 //					print("!1111")
 //
 //					cell.contentConfiguration = content
				 self.mainImageView.image = UIImage(data: data)
			 }
		 }
	 }

	 required init?(coder: NSCoder) {
		 fatalError("init(coder:) has not been implemented")
	 }

 }
