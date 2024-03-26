//
//  TotalResultTableViewCell.swift
//  NuriRock
//
//  Created by ungQ on 3/9/24.
//

import UIKit
import Kingfisher
import FSCalendar
import SVProgressHUD

protocol CalendarDateDelegate: AnyObject {
	func calendarButtonClicked()
}

protocol NoMoreTryDelegate: AnyObject {
	func noMoreAlert()
}

protocol TotalResultTableViewCellDelegate: AnyObject {
	func didSelectItem(selectedItem: String)
}

final class TotalResultTableViewCell: BaseTableViewCell {

	let viewModel = TotalResultTableViewModel()


	weak var delegate: CalendarDateDelegate?

	weak var noMoreaTryDelegate: NoMoreTryDelegate?

	weak var didSelectDelegate: TotalResultTableViewCellDelegate?

	var seeMoreButtonAction: ((_ segmentIndex: Int) -> Void)?
	private var currentSegmentIndex: Int = 0

	private let segmentedController = UISegmentedControl(items: [NSLocalizedString(LocalString.popularTouristAtraction.rawValue, comment: ""),
														 NSLocalizedString(LocalString.popularRestaurant.rawValue, comment: "")])

	private let seeMoreButton = UIButton()
	private let concertLabel = UILabel()
	private let dateLabel = UILabel()
	private let calendarButton = UIButton()

	lazy var topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureTopCollectionViewFlowLayout())
	lazy var bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureBottomCollectionViewFlowLayout())

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		bind()

		viewModel.observationToken = viewModel.bookmarks?.observe { changes in
			switch changes {
			case .initial:
				print("init")
			case .update:
				self.topCollectionView.reloadData()
				self.bottomCollectionView.reloadData()
			case .error:
				print("error")
			}

		}


	
	}

	private func bind() {
		viewModel.onDateChanged = {
			self.dateLabel.text = $0
		}

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

		viewModel.onProgress.bind { _ in
			if self.viewModel.onProgress.value {
				SVProgressHUD.show()
			} else if self.viewModel.mainAPICallNumber == 0 {

				SVProgressHUD.dismiss()
			}
		}

		viewModel.noMoreRetryAttempts.apiBind { _ in
			if self.viewModel.noMoreRetryAttempts.value {
				self.noMoreaTryDelegate?.noMoreAlert()
			}
		}




	}


	override func configureHierarchy() {

		contentView.addSubview(segmentedController)
		contentView.addSubview(topCollectionView)
		contentView.addSubview(seeMoreButton)
		contentView.addSubview(concertLabel)
		contentView.addSubview(dateLabel)
		contentView.addSubview(calendarButton)
		contentView.addSubview(bottomCollectionView)

	}

	override func configureLayout() {
		segmentedController.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(12)
			make.horizontalEdges.equalToSuperview().inset(8)
			make.height.equalTo(24)
		}

		topCollectionView.snp.makeConstraints { make in
			make.top.equalTo(segmentedController.snp.bottom).offset(4)
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(420)
		}

		seeMoreButton.snp.makeConstraints { make in
			make.top.equalTo(topCollectionView.snp.bottom).offset(4)
			make.centerX.equalToSuperview()
			make.width.equalTo(80)
			make.height.equalTo(24)
		}

		concertLabel.snp.makeConstraints { make in
			make.top.equalTo(seeMoreButton.snp.bottom).offset(12)
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

		seeMoreButton.setTitle(NSLocalizedString(LocalString.seemore.rawValue, comment: ""), for: .normal)
		seeMoreButton.backgroundColor = .point
		seeMoreButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
		seeMoreButton.layer.cornerRadius = 8
		seeMoreButton.titleLabel?.font = .boldSystemFont(ofSize: 12)

		concertLabel.text = NSLocalizedString(LocalString.events.rawValue, comment: "")
		concertLabel.font = .boldSystemFont(ofSize: 16)

		dateLabel.text = Date().formatDateBasedOnLocale()
		dateLabel.font = .boldSystemFont(ofSize: 14)

		calendarButton.setBackgroundImage(UIImage(systemName: "calendar"), for: .normal)
		calendarButton.tintColor = .point
		calendarButton.addTarget(self, action: #selector(calendarButtonClicked), for: .touchUpInside)

		configureSegmentedController()
		configureTopCollectionView()
		configureBottomCollectionView()
	}


	@objc private func calendarButtonClicked() {
		delegate?.calendarButtonClicked()

	}


	private func configureSegmentedController() {
		segmentedController.selectedSegmentIndex = 0
		let normalFontAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.background]
		let selectedFontAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.text]

		// Apply the attributes to the segmented control
		segmentedController.setTitleTextAttributes(normalFontAttributes, for: .normal)
		segmentedController.setTitleTextAttributes(selectedFontAttributes, for: .selected)

		segmentedController.backgroundColor = .point

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
		seeMoreButtonAction?(currentSegmentIndex)
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

		segmentedController.selectedSegmentIndex = 0
		segmentedValueChanged(segmentedController)
		viewModel.inputAreaCode.value = CityCode.allCases[index]
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

			guard let data = viewModel.outputFestivalData.value?.response.body.items?.item else { return 1 }

			return data.count
		}
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == self.topCollectionView {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as? TopCollectionViewCell else {
				return UICollectionViewCell()
			}


			if viewModel.inputSegmentedValue.value == 0 {
				guard let items = viewModel.outputTourData.value?.response.body.items?.item else { return cell }

				viewModel.currentData = items
			} else {
				guard let items = viewModel.outputRestaurantData.value?.response.body.items?.item else { return cell }
				viewModel.currentData = items
			}

			// topCollectionView에 대한 셀 구성
			let url = URL(string: viewModel.currentData[indexPath.item].firstimage)
			cell.imageView.kf.indicatorType = .activity
			cell.imageView.kf.setImage(with: url)
			cell.titleLabel.text = viewModel.currentData[indexPath.item].title
			cell.addressLabel.text = viewModel.currentData[indexPath.item].addr1

			if viewModel.repository.isBookmarked(contentId: viewModel.currentData[indexPath.item].contentid) {
				cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)

			} else if !viewModel.repository.isBookmarked(contentId: viewModel.currentData[indexPath.item].contentid) {
				cell.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
			}

			cell.bookmarkButton.tag = indexPath.item
			cell.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonClickedInTopCV), for: .touchUpInside)

			return cell

		} else if collectionView == self.bottomCollectionView {
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCollectionViewCell", for: indexPath) as? BottomCollectionViewCell else {
				return UICollectionViewCell()
			}
			// bottomCollectionView에 대한 셀 구성
			// 적절한 데이터 설정
			guard let data = viewModel.outputFestivalData.value?.response.body.items?.item else {
				cell.emptyLabel.isHidden = false
				cell.detailView.isHidden = true
				return cell }

			let url = URL(string: data[indexPath.item].firstimage)
			cell.posterImageView.kf.indicatorType = .activity
			cell.posterImageView.kf.setImage(with: url)
			cell.titleLabel.text = data[indexPath.item].title
			cell.addrLabel.text = data[indexPath.item].addr1

			guard let startDate = data[indexPath.item].eventstartdate else { return cell }
			guard let endDate = data[indexPath.item].eventenddate else { return cell }
			cell.dateLabel.text = "\(startDate.formattedDateString()) ~ \(endDate.formattedDateString())"


			if viewModel.repository.isBookmarked(contentId: data[indexPath.item].contentid) {
				cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)


			} else if !viewModel.repository.isBookmarked(contentId: data[indexPath.item].contentid) {
				cell.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
			}

			cell.bookmarkButton.tag = indexPath.item
			cell.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonClickedInBottomCV), for: .touchUpInside)

			return cell
		}
		return UICollectionViewCell()
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == self.topCollectionView {
			print("위")

			if viewModel.currentData != [] {

				didSelectDelegate?.didSelectItem(selectedItem: viewModel.currentData[indexPath.item].contentid)

			}

		} else if collectionView == self.bottomCollectionView {
			// bottomCollectionView에 대한 아이템 수 반환

			if let data = viewModel.outputFestivalData.value?.response.body.items?.item {

				didSelectDelegate?.didSelectItem(selectedItem: data[indexPath.item].contentid)
			}
		}

	}


	@objc private func bookmarkButtonClickedInTopCV(_ sender: UIButton) {

		SVProgressHUD.show()

		let data = viewModel.currentData[sender.tag]

		if viewModel.repository.isBookmarked(contentId: data.contentid) {
			viewModel.repository.deleteBookmark(data: data)

			SVProgressHUD.dismiss(withDelay: 0.2)
			topCollectionView.reloadData()

		} else {
			
			viewModel.repository.addBookmark(id: data.contentid) { success in
				DispatchQueue.main.async {
					if success {
						SVProgressHUD.dismiss()
					} else {
						SVProgressHUD.showError(withStatus: "서버 오류")
					}
					self.topCollectionView.reloadData()
				}
			}
		}
	}

	@objc private func bookmarkButtonClickedInBottomCV(_ sender: UIButton) {
		SVProgressHUD.show()

		guard let data = viewModel.outputFestivalData.value?.response.body.items?.item?[sender.tag] else {
			return }


		if viewModel.repository.isBookmarked(contentId: data.contentid) {
			viewModel.repository.deleteBookmark(data: data)

			SVProgressHUD.dismiss(withDelay: 0.2)
			bottomCollectionView.reloadData()

		} else {

			viewModel.repository.addBookmark(id: data.contentid) { success in

				DispatchQueue.main.async {
					if success {
						SVProgressHUD.dismiss()
					} else {
						SVProgressHUD.showError(withStatus: "서버 오류")

					}

					self.bottomCollectionView.reloadData()
				}
			}
		}
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
