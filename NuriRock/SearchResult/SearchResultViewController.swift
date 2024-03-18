//
//  SearchResultViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/14/24.
//

import UIKit
import SVProgressHUD

class SearchResultViewController: UIViewController {

	static let sectionHeaderElementKind = "section-header-element-kind"
	static let sectionFooterElementKind = "section-footer-element-kind"

	var dataSource: UICollectionViewDiffableDataSource<ContentType, Item>! = nil
	var collectionView: UICollectionView! = nil

	let viewModel = SearchResultViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "\(viewModel.inputKeyword.value) 검색 결과"
		configureHierarchy()
		configureDataSource()
		bindViewModel()
		updateSnapshot()
	}

		private func bindViewModel() {
			viewModel.outputTourData.bind { _ in
				self.updateSnapshot()
			}
	
			viewModel.outputCultureData.bind { _ in
				self.updateSnapshot()
			}
	
			viewModel.outputFestivalData.bind { _ in
				self.updateSnapshot()
			}
	
			viewModel.outputHotelData.bind { _ in
				self.updateSnapshot()
			}
	
			viewModel.outputShoppingData.bind { _ in
				self.updateSnapshot()
			}
	
			viewModel.outputRestaurantData.bind { _ in
				self.updateSnapshot()
			}

			viewModel.onProgress.bind { _ in
				if self.viewModel.onProgress.value {
					SVProgressHUD.show()
				} else {
					SVProgressHUD.dismiss()
				}
			}

			viewModel.noMoreRetryAttempts.apiBind { _ in
				if self.viewModel.noMoreRetryAttempts.value {
					self.view.makeToast("잠시 후 다시 시도해주세요.", position: .center)
				}
			}
		}
	

	private func updateSnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<ContentType, Item>()
		snapshot.appendSections(ContentType.allCases)

		snapshot.appendItems(viewModel.outputTourData.value?.response.body.items?.item ?? [], toSection: .tour)
		snapshot.appendItems(viewModel.outputCultureData.value?.response.body.items?.item ?? [], toSection: .culture)
		snapshot.appendItems(viewModel.outputFestivalData.value?.response.body.items?.item ?? [], toSection: .festival)
		snapshot.appendItems(viewModel.outputHotelData.value?.response.body.items?.item ?? [], toSection: .hotel)
		snapshot.appendItems(viewModel.outputShoppingData.value?.response.body.items?.item ?? [], toSection: .shopping)
		snapshot.appendItems(viewModel.outputRestaurantData.value?.response.body.items?.item ?? [], toSection: .restaurant)

		dataSource.apply(snapshot) //reloadData

		//realm과 결합할 때, 삭제 할때 스냅샷이 안먹힐때
//		dataSource.applySnapshotUsingReloadData(snapshot)
	}
}

extension SearchResultViewController {
	/// - Tag: HeaderFooter
	func createLayout() -> UICollectionViewLayout {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											 heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)

		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											  heightDimension: .absolute(72))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = 5
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

		let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
													 heightDimension: .estimated(44))
		let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
			layoutSize: headerFooterSize,
			elementKind: SearchResultViewController.sectionHeaderElementKind, alignment: .top)
		let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
			layoutSize: headerFooterSize,
			elementKind: SearchResultViewController.sectionFooterElementKind, alignment: .bottom)
		section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}
}

extension SearchResultViewController {
	func configureHierarchy() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		collectionView.backgroundColor = .systemBackground
		view.addSubview(collectionView)
		collectionView.delegate = self
	}
	/// - Tag: SupplementaryRegistration
	func configureDataSource() {


		let cellRegistration = UICollectionView.CellRegistration<ResultCollectionViewCell, Item> { (cell, indexPath, identifier) in
			// Populate the cell with our item description.
//			cell.mainLabel.text = "\(indexPath.section),\(indexPath.item)"
			cell.searchKeyword = self.viewModel.inputKeyword.value
			cell.updateUI(identifier)

		}

		let headerRegistration = UICollectionView.SupplementaryRegistration
		<ResultCollectionViewSectionHeaderView>(elementKind: SearchResultViewController.sectionHeaderElementKind) {
			(supplementaryView, string, indexPath) in

			supplementaryView.titleLabel.text = ContentType(rawValue: indexPath.section)?.title


//			supplementaryView.backgroundColor = .lightGray
//			supplementaryView.layer.borderColor = UIColor.black.cgColor
//			supplementaryView.layer.borderWidth = 1.0
		}

		let footerRegistration = UICollectionView.SupplementaryRegistration
		<ResultCollectionViewSectionFooterView>(elementKind: SearchResultViewController.sectionFooterElementKind) {
			(supplementaryView, string, indexPath) in

			supplementaryView.seeMoreButton.tag = indexPath.section

			supplementaryView.seeMoreButton.addTarget(self, action: #selector(self.test), for: .touchUpInside)
			//			supplementaryView.backgroundColor = .lightGray
			//			supplementaryView.layer.borderColor = UIColor.black.cgColor
			//			supplementaryView.layer.borderWidth = 1.0
		}

		dataSource = UICollectionViewDiffableDataSource<ContentType, Item>(collectionView: collectionView) {
			(collectionView: UICollectionView, indexPath: IndexPath, identifier: Item) -> UICollectionViewCell? in
			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
		}


		dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
			guard let self = self else { return nil }

			if kind == SearchResultViewController.sectionHeaderElementKind {
				return collectionView.dequeueConfiguredReusableSupplementary(
					using: headerRegistration, for: indexPath)
			} else if kind == SearchResultViewController.sectionFooterElementKind {
				return collectionView.dequeueConfiguredReusableSupplementary(
					using: footerRegistration, for: indexPath)
			} else {
				return nil
			}
		}
	}

	@objc func test(_ sender: UIButton) {
		let vc = ContentViewController()
		vc.viewModel.isAreaOrKeyword = false
		vc.viewModel.intputContentTypeAtKeyword.value = ContentType.allCases[sender.tag]
		vc.viewModel.inputKeyword.value = viewModel.inputKeyword.value
		navigationController?.pushViewController(vc, animated: true)
	}
}

extension SearchResultViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("select")
		collectionView.deselectItem(at: indexPath, animated: true)
	}
}
//
//
//class SearchResultViewController: UIViewController {
//
//	var viewModel = SearchResultViewModel()
//
//	var dataSource:  UICollectionViewDiffableDataSource<ContentType, Item>!
//
//	lazy private var collectionView = {
//		let layout = UICollectionViewFlowLayout()
//		layout.itemSize = CGSize(width: view.frame.width, height: 80)
//		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
////		layout.headerReferenceSize = CGSize(width: view.frame.width, height: 40)
//
//		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//		collectionView.backgroundColor = .white
//		collectionView.autoresizingMask = [.flexibleWidth, . flexibleHeight]
//
//		collectionView.delegate = self
//
//
////		collectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: "resultcell")
////		collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
//		return collectionView
//	}()
//
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		setConstraints()
//		configureDataSource()
//
//		bindViewModel()
//
//
//	}
//
//
//	private func bindViewModel() {
//		viewModel.outputTourData.bind { _ in
//			self.updateSnapshot()
//		}
//
//		viewModel.outputCultureData.bind { _ in
//			self.updateSnapshot()
//		}
//
//		viewModel.outputFestivalData.bind { _ in
//			self.updateSnapshot()
//		}
//
//		viewModel.outputHotelData.bind { _ in
//			self.updateSnapshot()
//		}
//
//		viewModel.outputShoppingData.bind { _ in
//			self.updateSnapshot()
//		}
//
//		viewModel.outputRestaurantData.bind { _ in
//			self.updateSnapshot()
//		}
//	}
//
//	func numberOfSections(in collectionView: UICollectionView) -> Int {
//		return 6 // 카테고리 수
//	}
//
//	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//		guard kind == UICollectionView.elementKindSectionHeader else {
//			return UICollectionReusableView()
//		}
//
//		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView
//
//		let sectionTitle: String = {
//			switch indexPath.section {
//			case 0: return "Tour"
//			case 1: return "Culture"
//			case 2: return "Festival"
//			case 3: return "Hotel"
//			case 4: return "Shopping"
//			case 5: return "Restaurant"
//			default: return ""
//			}
//		}()
//
//		header.configure(title: sectionTitle)
//		return header
//	}
//
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//		return CGSize(width: collectionView.frame.width, height: 50)  // Adjust the height as needed
//	}
//
//
//	private func configureDataSource() {
//
//		let cellRegistration = UICollectionView.CellRegistration<ResultCollectionViewCell, Item> { (cell, indexPath, identifier) in
//			// Populate the cell with our item description.
//			cell.updateUI(identifier)
//		}
//
//		let headerRegistration = UICollectionView.SupplementaryRegistration
//		<ResultCollectionViewSectionHeaderView>(elementKind: SearchResultViewController.sectionHeaderElementKind) {
//			(supplementaryView, string, indexPath) in
//			supplementaryView.titleLabel.text = "\(string)"
//		}
//
//		dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
//			(collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
//			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
//		}
//
//		dataSource.supplementaryViewProvider = { (view, kind, index) in
//			return self.collectionView.dequeueConfiguredReusableSupplementary(
//				using: kind == SectionHeadersFootersViewController.sectionHeaderElementKind ? headerRegistration : footerRegistration, for: index)
//		}
//
//
////		let cellRegistration = photoCellRegistration()
////		let dataCellRegistration = dataCellRegistration()
//
//		//datasource의 역할 = let cell= collectionView.dequereusable~~~
//		dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
//
//			self.dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
//				guard kind == UICollectionView.elementKindSectionHeader else { return nil }
//				let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView
//				let sectionTitle: String = {
//					switch indexPath.section {
//					case 0: return "Tour"
//					case 1: return "Culture"
//					case 2: return "Festival"
//					case 3: return "Hotel"
//					case 4: return "Shopping"
//					case 5: return "Restaurant"
//					default: return ""
//					}
//				}()
//				header?.configure(title: sectionTitle)
//				return header
//			}
//
//			if let section = ContentType(rawValue: indexPath.section) {
//				switch section {
//				case .tour:
//					let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//
//					return cell
//
//				case .culture:
//					let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//
//					return cell
//
//				case .festival:
//					let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//
//					return cell
//				case .hotel:
//					let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//
//					return cell
//				case .shopping:
//					let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//
//					return cell
//				case .restaurant:
//					let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//
//					return cell
//				}
//			} else {
//				return nil
//			}
//
//
//
//		})
//
//	}
//
//	private func updateSnapshot() {
//		var snapshot = NSDiffableDataSourceSnapshot<ContentType, Item>()
//		snapshot.appendSections(ContentType.allCases)
//
//		snapshot.appendItems(viewModel.outputTourData.value?.response.body.items?.item ?? [], toSection: .tour)
//		snapshot.appendItems(viewModel.outputCultureData.value?.response.body.items?.item ?? [], toSection: .culture)
//		snapshot.appendItems(viewModel.outputFestivalData.value?.response.body.items?.item ?? [], toSection: .festival)
//		snapshot.appendItems(viewModel.outputHotelData.value?.response.body.items?.item ?? [], toSection: .hotel)
//		snapshot.appendItems(viewModel.outputShoppingData.value?.response.body.items?.item ?? [], toSection: .shopping)
//		snapshot.appendItems(viewModel.outputRestaurantData.value?.response.body.items?.item ?? [], toSection: .restaurant)
//
//		dataSource.apply(snapshot) //reloadData
//
//		//realm과 결합할 때, 삭제 할때 스냅샷이 안먹힐때
////		dataSource.applySnapshotUsingReloadData(snapshot)
//	}
//
//}
//
//
//
//extension SearchResultViewController {
//
//	static let sectionHeaderElementKind = "section-header-element-kind"
//	static let sectionFooterElementKind = "section-footer-element-kind"
//
//	// 2.
//	private func createLayout() -> UICollectionViewLayout {
//		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//											 heightDimension: .fractionalHeight(1.0))
//		let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//											  heightDimension: .absolute(44))
//		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//		let section = NSCollectionLayoutSection(group: group)
//		section.interGroupSpacing = 5
//		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//
//		let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//													 heightDimension: .estimated(44))
//
//		let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//			layoutSize: headerFooterSize,
//			elementKind: SearchResultViewController.sectionHeaderElementKind, alignment: .top)
//		let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
//			layoutSize: headerFooterSize,
//			elementKind: SearchResultViewController.sectionFooterElementKind, alignment: .bottom)
//		section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
//
//		let layout = UICollectionViewCompositionalLayout(section: section)
//		return layout
//
////
////		//sectionprovider
////		let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
////
////			guard let section = ContentType(rawValue: sectionIndex) else { return nil }
////			let layoutSection: NSCollectionLayoutSection
////			//cell, group 사이즈의 영향을 받음, 200* 1.0, 100* 1.0
////			let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
////												  heightDimension: .fractionalHeight(1.0))
////			let item = NSCollectionLayoutItem(layoutSize: itemSize)
////
////			//group
////			let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
////														 heightDimension: .absolute(60))
////			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize, subitems: [item])
////
////			//section
////			layoutSection = NSCollectionLayoutSection(group: group)
////			layoutSection.interGroupSpacing = 5
////
////			return layoutSection
////
////		}
////		return layout
//	}
//
//
//
//	// 3.
//	private func setConstraints() {
//		view.addSubview(collectionView)
//		collectionView.snp.makeConstraints { make in
//			make.edges.equalTo(view.safeAreaLayoutGuide)
//		}
//	}
//
//
//	private func photoCellRegistration() -> UICollectionView.CellRegistration<ResultCollectionViewCell, Item> {
//
//		UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
//
//			cell.updateUI(itemIdentifier)
//
//		}
//	}
////
////	private func dataCellRegistration() -> UICollectionView.CellRegistration<ResultCollectionViewCell, Item> {
////		//cellRegistration의 역할 = cell.textLabel.text = "고래밥"
////		UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
////
////			cell.updateUI()
////
////		}
////	}
//}
//
//
//extension SearchResultViewController: UICollectionViewDelegate {
//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		print(#function)
//	}
//}
