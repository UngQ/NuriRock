//
//  TotalResultTableViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/9/24.
//

import UIKit
import Kingfisher
import FSCalendar

class TotalResultTableViewCell: BaseTableViewCell {

	let viewModel = TotalResultTableViewModel()

	weak var delegate: TotalResultTableViewCellDelegate?

	var addButtonAction: ((_ segmentIndex: Int) -> Void)?
	private var currentSegmentIndex: Int = 0

	let segmentedController = UISegmentedControl(items: [NSLocalizedString(LocalString.popularTouristAtraction.rawValue, comment: ""),
														 NSLocalizedString(LocalString.popularRestaurant.rawValue, comment: "")])

	let addButton = UIButton()
	let concertLabel = UILabel()
	let dateLabel = UILabel()
	let calendarButton = UIButton()

	lazy var topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureTopCollectionViewFlowLayout())
	lazy var bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureBottomCollectionViewFlowLayout())

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		bind()

		viewModel.onDateChanged = {
			self.dateLabel.text = $0
		}
	}

	private func bind() {
		viewModel.outputTourData.apiBind { data in
			self.topCollectionView.reloadData()
		}

		viewModel.outputRestaurantData.apiBind { _ in
			self.topCollectionView.reloadData()
		}

		viewModel.outputFestivalData.apiBind { _ in
			self.bottomCollectionView.reloadData()
		}

		viewModel.inputSegmentedValue.apiBind { _ in
			self.topCollectionView.reloadData()
		}


	}

	override func configureHierarchy() {
		contentView.addSubview(segmentedController)
		contentView.addSubview(topCollectionView)
		contentView.addSubview(addButton)
		contentView.addSubview(concertLabel)
		contentView.addSubview(dateLabel)
		contentView.addSubview(calendarButton)
		contentView.addSubview(bottomCollectionView)
	}

	override func configureLayout() {
		segmentedController.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(4)
			make.horizontalEdges.equalToSuperview().inset(8)
			make.height.equalTo(24)
		}

		topCollectionView.snp.makeConstraints { make in
			make.top.equalTo(segmentedController.snp.bottom).offset(4)
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(420)
		}

		addButton.snp.makeConstraints { make in
			make.top.equalTo(topCollectionView.snp.bottom).offset(4)
			make.centerX.equalToSuperview()
			make.width.equalTo(80)
			make.height.equalTo(24)
		}

		concertLabel.snp.makeConstraints { make in
			make.top.equalTo(addButton.snp.bottom).offset(12)
			make.horizontalEdges.equalToSuperview().inset(8)
			make.height.equalTo(24)
		}

		dateLabel.snp.makeConstraints { make in
			make.top.equalTo(concertLabel.snp.bottom).offset(4)
			make.centerX.equalToSuperview()
			make.width.greaterThanOrEqualTo(0)
			make.height.equalTo(24)
		}

		calendarButton.snp.makeConstraints { make in
			make.top.equalTo(concertLabel.snp.bottom).offset(4)
			make.trailing.equalToSuperview().offset(-8)
			make.size.equalTo(28)
		}

		bottomCollectionView.snp.makeConstraints { make in
			make.top.equalTo(dateLabel.snp.bottom).offset(4)
			make.bottom.horizontalEdges.equalToSuperview()
		}
	}

	override func configureCell() {

	
		addButton.setTitle(NSLocalizedString(LocalString.seemore.rawValue, comment: ""), for: .normal)
		addButton.backgroundColor = .systemBlue
		addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
		addButton.layer.cornerRadius = 8
		addButton.titleLabel?.font = .boldSystemFont(ofSize: 12)

		concertLabel.text = NSLocalizedString(LocalString.events.rawValue, comment: "")
		concertLabel.font = .boldSystemFont(ofSize: 16)

		dateLabel.text = Date().formatDateBasedOnLocale()
		dateLabel.font = .boldSystemFont(ofSize: 14)

		calendarButton.setBackgroundImage(UIImage(systemName: "calendar"), for: .normal)
		calendarButton.addTarget(self, action: #selector(calendarButtonClicked), for: .touchUpInside)

		configureSegmentedController()
		configureTopCollectionView()
		configureBottomCollectionView()
	}


	@objc func calendarButtonClicked() {
		delegate?.calendarButtonClicked()
	}


	private func configureSegmentedController() {
		segmentedController.selectedSegmentIndex = 0
		let normalFontAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white]
		let selectedFontAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.black]

		// Apply the attributes to the segmented control
		segmentedController.setTitleTextAttributes(normalFontAttributes, for: .normal)
		segmentedController.setTitleTextAttributes(selectedFontAttributes, for: .selected)

		segmentedController.backgroundColor = .systemBlue

		segmentedController.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)

	}


	private func configureTopCollectionView() {
		topCollectionView.delegate = self
		topCollectionView.dataSource = self
		topCollectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: "TopCollectionViewCell")
	}

	private func configureBottomCollectionView() {
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
		addButtonAction?(currentSegmentIndex)
	}

	@objc private func segmentedValueChanged(_ sender: UISegmentedControl) {
		viewModel.inputSegmentedValue.value = sender.selectedSegmentIndex
		currentSegmentIndex = sender.selectedSegmentIndex
	}

	private func configureTopCollectionViewFlowLayout() -> UICollectionViewFlowLayout {

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

	private func configureBottomCollectionViewFlowLayout() -> UICollectionViewFlowLayout {

		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.itemSize = Const.itemSize // <-
		layout.minimumLineSpacing = Const.itemSpacing // <-
		layout.minimumInteritemSpacing = 0
		return layout

	}

	func configureWithIndex(index: Int) {

		viewModel.inputAreaCode.value = CityCode.allCases[index].rawValue
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

			guard let data = viewModel.outputFestivalData.value?.response.body.items else { return 1 }

			return data.item.count  // 예시 값
		}
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == self.topCollectionView {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as? TopCollectionViewCell else {
				return UICollectionViewCell()
			}
			var data: [Item]? = []



			if viewModel.inputSegmentedValue.value == 0 {
				guard let items = viewModel.outputTourData.value?.response.body.items else { return cell }

				data = items.item
			} else {
				guard let items = viewModel.outputRestaurantData.value?.response.body.items else { return cell }
				data = items.item
			}

			// topCollectionView에 대한 셀 구성
			guard let data = data else { return cell }
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
			guard let data = viewModel.outputFestivalData.value?.response.body.items else { 
				cell.emptyLabel.isHidden = false
				cell.detailView.isHidden = true
				return cell }

			let url = URL(string: data.item[indexPath.item].firstimage)
			cell.posterImageView.kf.setImage(with: url)
			cell.titleLabel.text = data.item[indexPath.item].title
			cell.addrLabel.text = data.item[indexPath.item].addr1

			guard let startDate = data.item[indexPath.item].eventstartdate else { return cell }
			guard let endDate = data.item[indexPath.item].eventenddate else { return cell }
			cell.dateLabel.text = "\(startDate.formattedDateString()) ~ \(endDate.formattedDateString())"
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
		static let itemSize = CGSize(width: 292, height: 420)
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


extension TotalResultTableViewCell: CalendarDateSelectionDelegate {
	func didSelectDate(date: Date) {
		viewModel.inputDate.value = date

	}
}
