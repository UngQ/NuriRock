//
//  ContentViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/16/24.
//

import UIKit
import SVProgressHUD

class ContentViewController: BaseViewController {

	static let sectionHeaderElementKind = "section-header-element-kind"
	static let sectionFooterElementKind = "section-footer-element-kind"

	var dataSource: UICollectionViewDiffableDataSource<ContentType, Item>! = nil
	lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

	let viewModel = ContentViewModel()


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		viewModel.inputViewWillAppearTrigger.value = ()
		print(#function)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		print(viewModel.inputContentType.value)

		configureHierarchy()
		configureDataSource()
		bindViewModel()
		updateSnapshot()


	}


	func updateForCity(index: Int) {
		viewModel.isAreaChange = true
		viewModel.inputAreaCode.value = CityCode.allCases[index]
		viewModel.inputPageNo.value = 1
	}

	override func configureHierarchy() {
		view.addSubview(collectionView)
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		collectionView.backgroundColor = .systemBackground

		collectionView.delegate = self
		collectionView.prefetchDataSource = self
	}

	override func configureLayout() {
		collectionView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(44)
			make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
		}

	}

	override func configureView() {
		 

	}

	private func bindViewModel() {

		viewModel.noMoreRetryAttempts.apiBind { _ in
			if self.viewModel.noMoreRetryAttempts.value {
				self.view.makeToast("잠시 후 다시 시도해주세요.", position: .center)
			}
		}

		viewModel.outputContentData.bind { _ in
			self.updateSnapshot()
		}

		viewModel.outputItemList.bind { _ in
			self.updateSnapshot()
		}

		viewModel.onProgress.bind { _ in
			if self.viewModel.onProgress.value {
				SVProgressHUD.show()
			} else {
				SVProgressHUD.dismiss()
			}
		}

		viewModel.isLastPage.apiBind { _ in
			self.view.makeToast("더 이상 목록이 없습니다")
		}

//		viewModel.onProgress.bind { _ in
//			if self.viewModel.onProgress.value {
//				SVProgressHUD.show()
//			} else {
//				SVProgressHUD.dismiss()
//			}
//		}
//
//		viewModel.noMoreRetryAttempts.apiBind { _ in
//			if self.viewModel.noMoreRetryAttempts.value {
//				self.view.makeToast("잠시 후 다시 시도해주세요.", position: .center)
//			}
//		}
	}


	private func updateSnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<ContentType, Item>()
		snapshot.appendSections([.tour])

		snapshot.appendItems(viewModel.outputItemList.value ?? [], toSection: .tour)

		dataSource.apply(snapshot) //reloadData

		//realm과 결합할 때, 삭제 할때 스냅샷이 안먹힐때
		//		dataSource.applySnapshotUsingReloadData(snapshot)
	}
}

extension ContentViewController {
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
//		let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//			layoutSize: headerFooterSize,
//			elementKind: SearchResultViewController.sectionHeaderElementKind, alignment: .top)
		let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
			layoutSize: headerFooterSize,
			elementKind: SearchResultViewController.sectionFooterElementKind, alignment: .bottom)
//		section.boundarySupplementaryItems = [sectionFooter]

		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}
}

extension ContentViewController {


	/// - Tag: SupplementaryRegistration
	func configureDataSource() {

		let cellRegistration = UICollectionView.CellRegistration<ResultCollectionViewCell, Item> { (cell, indexPath, identifier) in
			// Populate the cell with our item description.
			//			cell.mainLabel.text = "\(indexPath.section),\(indexPath.item)"
//			cell.searchKeyword = self.viewModel.inputKeyword.value
			cell.updateUI(identifier)
		}

		let headerRegistration = UICollectionView.SupplementaryRegistration
		<ResultCollectionViewSectionHeaderView>(elementKind: SearchResultViewController.sectionHeaderElementKind) {
			(supplementaryView, string, indexPath) in

			supplementaryView.titleLabel.text = ContentType(rawValue: indexPath.section)?.title
			supplementaryView.backgroundColor = .lightGray
			//			supplementaryView.layer.borderColor = UIColor.black.cgColor
			//			supplementaryView.layer.borderWidth = 1.0
		}

		let footerRegistration = UICollectionView.SupplementaryRegistration
		<ResultCollectionViewSectionFooterView>(elementKind: SearchResultViewController.sectionFooterElementKind) {
			(supplementaryView, string, indexPath) in

			supplementaryView.seeMoreButton.addTarget(self, action: #selector(self.test), for: .touchUpInside)
			supplementaryView.backgroundColor = .lightGray
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

	@objc func test() {
		print("test")
	}
}

extension ContentViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("select")
		collectionView.deselectItem(at: indexPath, animated: true)
	}
}

extension ContentViewController: UICollectionViewDataSourcePrefetching {


	func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {


		for item in indexPaths {
			guard let count = viewModel.outputItemList.value?.count else { return }
			if count - 10 == item.row {
				
				if viewModel.isAreaOrKeyword {
					viewModel.isAreaChange = false
					viewModel.inputPageNo.value += 1
				} else {
					viewModel.inputPageNo.value += 1
				}
				print("hi~~")
			}
		}
	}

}
