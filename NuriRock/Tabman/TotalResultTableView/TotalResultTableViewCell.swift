//
//  TotalResultTableViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/9/24.
//

import UIKit
import Kingfisher

class TotalResultTableViewCell: BaseTableViewCell {


	let viewModel = TotalResultTableViewModel()

	weak var delegate: TotalResultTableViewCellDelegate?

	let segmentedController = UISegmentedControl(items: ["추천 관광지", "추천 맛집"])
	lazy var topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureTopCollectionView())
	let addButton = UIButton()
	let concertLabel = UILabel()
	let dateLabel = UILabel()
	let calenderButton = UIButton()
	lazy var bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureBottomCollectionView())

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		viewModel.outputData.apiBind { data in
			print("HAllo")
			self.topCollectionView.reloadData()
		}
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
		let normalFontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
		let selectedFontAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]

		// Apply the attributes to the segmented control
		segmentedController.setTitleTextAttributes(normalFontAttributes, for: .normal)
		segmentedController.setTitleTextAttributes(selectedFontAttributes, for: .selected)

		segmentedController.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)

	
		addButton.setTitle("더보기", for: .normal)
		addButton.backgroundColor = .systemBrown
		addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)

		concertLabel.text = "conccert"

		dateLabel.text = "24ssssss"

		
		topCollectionView.delegate = self
		topCollectionView.dataSource = self
		topCollectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: "TopCollectionViewCell")


		bottomCollectionView.isScrollEnabled = true
		bottomCollectionView.showsHorizontalScrollIndicator = false
		bottomCollectionView.showsVerticalScrollIndicator = true
		bottomCollectionView.backgroundColor = .clear
		bottomCollectionView.clipsToBounds = true

		bottomCollectionView.isPagingEnabled = false // <- 한 페이지의 넓이를 조절 할 수 없기 때문에 scrollViewWillEndDragging을 사용하여 구현
		bottomCollectionView.contentInsetAdjustmentBehavior = .never // <- 내부적으로 safe area에 의해 가려지는 것을 방지하기 위해서 자동으로 inset조정해 주는 것을 비활성화
		bottomCollectionView.contentInset = Const.collectionViewContentInset // <-
		bottomCollectionView.decelerationRate = .fast // <- 스크롤이 빠르게 되도록 (페이징 애니메이션같이 보이게하기 위함)
		bottomCollectionView.translatesAutoresizingMaskIntoConstraints = false

		bottomCollectionView.dataSource = self
		bottomCollectionView.delegate = self
		bottomCollectionView.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: "BottomCollectionViewCell")



	}

	@objc private func addButtonClicked() {
		print("Add!")
		delegate?.addButtonDidTap()
	}

	@objc private func segmentedValueChanged(_ button: UISegmentedControl) {
		if button.selectedSegmentIndex == 0 {
			viewModel.inputContentType.value = ContentType.tour.rawValue
		} else if button.selectedSegmentIndex == 1 {
			viewModel.inputContentType.value = ContentType.restaurant.rawValue
		}
	}

	private func configureTopCollectionView() -> UICollectionViewFlowLayout {

		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 12
		let cellWidth = UIScreen.main.bounds.width - (spacing * 3)

		layout.itemSize = CGSize(width: cellWidth / 2 , height: (420 - (spacing * 3)) / 2)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		layout.minimumLineSpacing = spacing
		layout.minimumInteritemSpacing = 0
		layout.scrollDirection = .vertical

		return layout

	}

	private func configureBottomCollectionView() -> UICollectionViewFlowLayout {

		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.itemSize = Const.itemSize // <-
		layout.minimumLineSpacing = Const.itemSpacing // <-
		layout.minimumInteritemSpacing = 0
		return layout

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension TotalResultTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.topCollectionView {
			// topCollectionView에 대한 아이템 수 반환
			return 4
		} else if collectionView == self.bottomCollectionView {
			// bottomCollectionView에 대한 아이템 수 반환
			return 6  // 예시 값
		}
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == self.topCollectionView {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as? TopCollectionViewCell else {
				return UICollectionViewCell()
			}
			// topCollectionView에 대한 셀 구성
			guard let data = viewModel.outputData.value?.response.body.items.item else { return cell }
			let url = URL(string: data[indexPath.item].firstimage)
			cell.imageView.kf.setImage(with: url)
			cell.titleLabel.text = data[indexPath.item].title
			cell.addressLabel.text = data[indexPath.item].addr1

			return cell

		} else if collectionView == self.bottomCollectionView {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCollectionViewCell", for: indexPath) as? BottomCollectionViewCell else {
				return UICollectionViewCell()
			}
			// bottomCollectionView에 대한 셀 구성
			// 적절한 데이터 설정

			cell.posterImageView.image = UIImage(systemName: "star")
			return cell
		}
		return UICollectionViewCell()
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("hi")
	}


}



extension TotalResultTableViewCell: UICollectionViewDelegateFlowLayout {

	private enum Const {
		static let itemSize = CGSize(width: 300, height: 400)
		static let itemSpacing = 24.0

		static var insetX: CGFloat {
			(UIScreen.main.bounds.width - Self.itemSize.width) / 2.0
		}
		static var collectionViewContentInset: UIEdgeInsets {
			UIEdgeInsets(top: 0, left: Self.insetX, bottom: 0, right: Self.insetX)
		}
	}

	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
		let cellWidth = Const.itemSize.width + Const.itemSpacing
		let index = round(scrolledOffsetX / cellWidth)
		targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)

	}
}

