//
//  SearchResultViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/14/24.
//

import UIKit
import SVProgressHUD

final class SearchResultViewController: BaseViewController {

	static let sectionHeaderElementKind = "section-header-element-kind"
	static let sectionFooterElementKind = "section-footer-element-kind"

	var dataSource: UICollectionViewDiffableDataSource<ContentType, Item>! = nil
	var collectionView: UICollectionView! = nil

	let viewModel = SearchResultViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		let logo = UIImage(resource: .title)
		let imageView = UIImageView(image: logo)


		imageView.contentMode = .scaleAspectFit
		navigationItem.titleView = imageView
		navigationController?.navigationBar.backgroundColor = .white


		configureDataSource()
		bindViewModel()
		updateSnapshot()
	}

	override func configureHierarchy() {
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
//		collectionView.autoresizingMask = [.flexibleHeight]
		collectionView.backgroundColor = .systemBackground
		view.addSubview(collectionView)
		collectionView.delegate = self
	}

	override func configureLayout() {
		collectionView.snp.makeConstraints { make in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}
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

	/// - Tag: SupplementaryRegistration
	func configureDataSource() {


		let cellRegistration = UICollectionView.CellRegistration<ResultCollectionViewCell, Item> { (cell, indexPath, identifier) in
			// Populate the cell with our item description.
			//			cell.mainLabel.text = "\(indexPath.section),\(indexPath.item)"
			cell.searchKeyword = self.viewModel.inputKeyword.value
			cell.updateUI(identifier)
			cell.bookmarkButton.tag = indexPath.item
			cell.bookmarkButton.addTarget(self, action: #selector(self.bookmarkButtonClicked), for: .touchUpInside)

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

	@objc func bookmarkButtonClicked(_ sender: UIButton) {
		SVProgressHUD.show()

		if let section = ContentType(rawValue: indexPath.section) {
			switch section {
			case .tour:
				print(section)
				let vc = DetailContentInfoViewController()
				vc.viewModel.inputContentId.value = viewModel.outputTourData.value?.response.body.items?.item?[indexPath.item].contentid
				navigationController?.pushViewController(vc, animated: true)
			case .culture:
				print(section)
				let vc = DetailContentInfoViewController()
				vc.viewModel.inputContentId.value = viewModel.outputCultureData.value?.response.body.items?.item?[indexPath.item].contentid
				navigationController?.pushViewController(vc, animated: true)
			case .festival:
				let vc = DetailContentInfoViewController()
				vc.viewModel.inputContentId.value = viewModel.outputFestivalData.value?.response.body.items?.item?[indexPath.item].contentid
				navigationController?.pushViewController(vc, animated: true)
			case .hotel:
				let vc = DetailContentInfoViewController()
				vc.viewModel.inputContentId.value = viewModel.outputHotelData.value?.response.body.items?.item?[indexPath.item].contentid
				navigationController?.pushViewController(vc, animated: true)
			case .shopping:
				let vc = DetailContentInfoViewController()
				vc.viewModel.inputContentId.value = viewModel.outputShoppingData.value?.response.body.items?.item?[indexPath.item].contentid
				navigationController?.pushViewController(vc, animated: true)
			case .restaurant:
				let vc = DetailContentInfoViewController()
				vc.viewModel.inputContentId.value = viewModel.outputRestaurantData.value?.response.body.items?.item?[indexPath.item].contentid
				navigationController?.pushViewController(vc, animated: true)
			}




		if viewModel.repository.isBookmarked(contentId: data.contentid) {
			viewModel.repository.deleteBookmark(data: data)

			SVProgressHUD.dismiss(withDelay: 0.2)
			updateSnapshot()
		} else {

			viewModel.repository.addBookmark(id: data.contentid) { success in

				DispatchQueue.main.async {
					if success {
						SVProgressHUD.dismiss()
					} else {
						SVProgressHUD.showError(withStatus: "서버 오류")

					}

					self.updateSnapshot()
				}
			}
		}
	}

	@objc func test(_ sender: UIButton) {
		let vc = ContentViewController()
		vc.navigationItem.title = ContentType.allCases[sender.tag].title
		vc.viewModel.isAreaOrKeyword = false
		vc.viewModel.intputContentTypeAtKeyword.value = ContentType.allCases[sender.tag]
		vc.viewModel.inputKeyword.value = viewModel.inputKeyword.value
		navigationController?.pushViewController(vc, animated: true)
	}
}

extension SearchResultViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		if let section = ContentType(rawValue: indexPath.section) {
			switch section {
			case .tour:
				print(section)
				let vc = DetailContentInfoViewController()
				vc.viewModel.inputContentId.value = viewModel.outputTourData.value?.response.body.items?.item?[indexPath.item].contentid
				navigationController?.pushViewController(vc, animated: true)
			case .culture:
				print(section)
				let vc = DetailContentInfoViewController()
				vc.viewModel.inputContentId.value = viewModel.outputCultureData.value?.response.body.items?.item?[indexPath.item].contentid
				navigationController?.pushViewController(vc, animated: true)
			case .festival:
				let vc = DetailContentInfoViewController()
				vc.viewModel.inputContentId.value = viewModel.outputFestivalData.value?.response.body.items?.item?[indexPath.item].contentid
				navigationController?.pushViewController(vc, animated: true)
			case .hotel:
				let vc = DetailContentInfoViewController()
				vc.viewModel.inputContentId.value = viewModel.outputHotelData.value?.response.body.items?.item?[indexPath.item].contentid
				navigationController?.pushViewController(vc, animated: true)
			case .shopping:
				let vc = DetailContentInfoViewController()
				vc.viewModel.inputContentId.value = viewModel.outputShoppingData.value?.response.body.items?.item?[indexPath.item].contentid
				navigationController?.pushViewController(vc, animated: true)
			case .restaurant:
				let vc = DetailContentInfoViewController()
				vc.viewModel.inputContentId.value = viewModel.outputRestaurantData.value?.response.body.items?.item?[indexPath.item].contentid
				navigationController?.pushViewController(vc, animated: true)
			}
		} 

	}
}
