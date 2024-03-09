//
//  TotalResultTableViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/9/24.
//

import UIKit

class TotalResultTableViewCell: BaseTableViewCell {

	let segmentedController = UISegmentedControl(items: ["추천 관광지", "추천 맛집"])
	lazy var topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionView())
	let addButton = UIButton()

	let concertLabel = UILabel()
	let dateLabel = UILabel()
	let calenderButton = UIButton()
	let bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	override func configureHierarchy() {
		contentView.addSubview(segmentedController)
		contentView.addSubview(topCollectionView)
		contentView.addSubview(addButton)
		contentView.addSubview(concertLabel)
		contentView.addSubview(dateLabel)
		contentView.addSubview(calenderButton)
		contentView.addSubview(bottomCollectionView)
	}

	override func configureLayout() {
		segmentedController.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(4)
			make.horizontalEdges.equalToSuperview().inset(8)
			make.height.equalTo(32)
		}

		topCollectionView.snp.makeConstraints { make in
			make.top.equalTo(segmentedController.snp.bottom).offset(4)
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(420)
		}

		addButton.snp.makeConstraints { make in
			make.top.equalTo(topCollectionView.snp.bottom).offset(4)
			make.horizontalEdges.equalToSuperview().inset(8)
			make.height.equalTo(24)
		}

		concertLabel.snp.makeConstraints { make in
			make.top.equalTo(addButton.snp.bottom).offset(4)
			make.horizontalEdges.equalToSuperview().inset(8)
			make.height.equalTo(32)
		}

		dateLabel.snp.makeConstraints { make in
			make.top.equalTo(concertLabel.snp.bottom).offset(4)
			make.centerX.equalToSuperview()
			make.width.greaterThanOrEqualTo(0)
			make.height.equalTo(32)
		}

		calenderButton.snp.makeConstraints { make in
			make.top.equalTo(concertLabel.snp.bottom).offset(4)
			make.trailing.equalToSuperview().offset(-8)
			make.size.equalTo(32)
		}

		bottomCollectionView.snp.makeConstraints { make in
			make.top.equalTo(dateLabel.snp.bottom).offset(4)
			make.bottom.horizontalEdges.equalToSuperview()
		}
	}

	override func configureCell() {
		segmentedController.selectedSegmentIndex = 0

		topCollectionView.backgroundColor = .blue
		concertLabel.text = "conccert"

		dateLabel.text = "24ssssss"

		topCollectionView.delegate = self
		topCollectionView.dataSource = self
		topCollectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: "TopCollectionViewCell")
	}

	private func configureCollectionView() -> UICollectionViewFlowLayout {

		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 12

		let cellWidth = UIScreen.main.bounds.width - (spacing * 3)

		layout.itemSize = CGSize(width: cellWidth / 2 , height: (420 - (spacing * 3)) / 2)
		print(layout.itemSize)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		layout.minimumLineSpacing = spacing
		layout.minimumInteritemSpacing = 0


		layout.scrollDirection = .vertical


		return layout

	}



	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension TotalResultTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		4
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as! TopCollectionViewCell
		cell.backgroundColor = .darkGray
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("hi")
	}


}
