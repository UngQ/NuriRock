//
//  ContentViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/16/24.
//

import UIKit
import SVProgressHUD
import Kingfisher

final class ContentViewController: BaseViewController {

	enum Section {
		case main
	}

	static let sectionHeaderElementKind = "section-header-element-kind"
	static let sectionFooterElementKind = "section-footer-element-kind"

	var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
	lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

	let viewModel = ContentViewModel()

	weak var scrollDelegate: TotalResultViewControllerDelegate?
	weak var didSelectDelegate: TotalResultTableViewCellDelegate?

	


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let _ = viewModel.outputItemList.value {

		} else {
			viewModel.inputViewWillAppearTrigger.value = ()
		}
		print(#function)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		let cashe = ImageCache.default
		cashe.clearMemoryCache()
		cashe.clearDiskCache {
			print("done")
		}
		cashe.cleanExpiredMemoryCache()
		cashe.cleanExpiredDiskCache {
			print("done")
		}

	}



	override func viewDidLoad() {
		super.viewDidLoad()

		configureHierarchy()
		configureDataSource()
		bindViewModel()
		updateSnapshot()

//		viewModel.inputViewWillAppearTrigger.value = ()

		viewModel.observationToken = viewModel.bookmarks?.observe { changes in
			switch changes {
			case .initial:
				print("init")
			case .update:
				self.collectionView.reloadData()
			case .error:
				print("error")
			}

		}

	}


	func updateForCity(index: Int) {
		viewModel.isAreaChange = true
		viewModel.inputAreaCode.value = CityCode.allCases[index]
		viewModel.outputItemList.value = nil
		viewModel.inputPageNo.value = 1
	}

	override func configureHierarchy() {
		view.addSubview(collectionView)
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		collectionView.backgroundColor = .systemBackground

		collectionView.delegate = self

	}

	override func configureLayout() {
		if viewModel.isAreaOrKeyword == false {
			collectionView.snp.makeConstraints { make in
				make.top.equalTo(view.safeAreaLayoutGuide)
				make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
			}
		} else  {
			collectionView.snp.makeConstraints { make in
				make.top.equalTo(view.safeAreaLayoutGuide).offset(56)
				make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
			}
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
			self.viewModel.isLoading = false
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
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		snapshot.appendSections([.main])

		snapshot.appendItems(viewModel.outputItemList.value ?? [], toSection: .main)

		dataSource.apply(snapshot, animatingDifferences: true) //reloadData

		//realm과 결합할 때, 삭제 할때 스냅샷이 안먹힐때
//				dataSource.applySnapshotUsingReloadData(snapshot)
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
//		let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
//			layoutSize: headerFooterSize,
//			elementKind: SearchResultViewController.sectionFooterElementKind, alignment: .bottom)
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
			cell.bookmarkButton.tag = indexPath.item
			cell.bookmarkButton.addTarget(self, action: #selector(self.bookmarkButtonClicked), for: .touchUpInside)

			if self.viewModel.repository.isBookmarked(contentId: self.viewModel.outputItemList.value?[indexPath.item].contentid ?? "") {
				cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)

			} else if !self.viewModel.repository.isBookmarked(contentId: self.viewModel.outputItemList.value?[indexPath.item].contentid ?? "") {
				cell.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
			}
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

//			supplementaryView.seeMoreButton.addTarget(self, action: #selector(self.test), for: .touchUpInside)
			supplementaryView.backgroundColor = .lightGray
			//			supplementaryView.layer.borderColor = UIColor.black.cgColor
			//			supplementaryView.layer.borderWidth = 1.0
		}

		dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
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

		guard let data = viewModel.outputItemList.value?[sender.tag] else {
			return }


		if viewModel.repository.isBookmarked(contentId: data.contentid) {
			viewModel.repository.deleteBookmark(data: data)
			sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
			SVProgressHUD.dismiss(withDelay: 0.2)
			updateSnapshot()
		} else {

			viewModel.repository.addBookmark(id: data.contentid) { success in

				DispatchQueue.main.async {
					if success {
						sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
						SVProgressHUD.dismiss()
					} else {
						SVProgressHUD.showError(withStatus: "서버 오류")

					}

					self.updateSnapshot()
				}
			}
		}
	}

	@objc func test() {
		print("test")
	}
}

extension ContentViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		if let selectedItem = viewModel.outputItemList.value?[indexPath.row].contentid {
			didSelectDelegate?.didSelectItem(selectedItem: selectedItem)
		}

		let vc = DetailContentInfoViewController()
		vc.viewModel.inputContentId.value = viewModel.outputItemList.value?[indexPath.row].contentid
		navigationController?.pushViewController(vc, animated: true)

	}
}

extension ContentViewController: UIScrollViewDelegate {



	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)

		if translation.y > 0 {
			scrollDelegate?.didScrollTableView(.down)
		} else if translation.y < 0 {

			let offsetY = scrollView.contentOffset.y
			let contentHeight = scrollView.contentSize.height
			let height = scrollView.frame.size.height

			if offsetY > contentHeight - height * 1.1 && !viewModel.isLoading {
				viewModel.isLoading = true
				if viewModel.isAreaOrKeyword {
					viewModel.isAreaChange = false
					viewModel.inputPageNo.value += 1
				} else {
					viewModel.inputPageNo.value += 1
				}
			}

			scrollDelegate?.didScrollTableView(.up)
		}
	}
}
