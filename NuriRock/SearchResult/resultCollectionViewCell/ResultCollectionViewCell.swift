//
//  ResultCollectionViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/15/24.
//

import UIKit


class ResultCollectionViewCell: UICollectionViewCell {

	static let identifier = "ResultCollectionViewCell"

	let thumbnailImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 8
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	 let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		label.numberOfLines = 2
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	let addressLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		label.numberOfLines = 3
		label.textColor = .darkGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.addSubview(thumbnailImageView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(addressLabel)
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
			thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),

			titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

			addressLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
			addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
		])
	}

	public func configure(imageUrl: String, title: String, address: String) {
		// Assuming you have a method to set the image from a URL, here we just use a placeholder
		thumbnailImageView.image = UIImage(named: "placeholder")

		titleLabel.text = title
		addressLabel.text = address
	}
}
