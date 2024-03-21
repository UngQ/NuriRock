//
//  BookmarkViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/20/24.
//

import UIKit
import MapKit
import SVProgressHUD

final class BookmarkViewController: BaseViewController {

	enum Section {
		case main
	}

	let viewModel = BookmarkViewModel()

	let mapView = MKMapView()

	lazy var bookmarkCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
	var dataSource: UICollectionViewDiffableDataSource<Section, BookmarkRealmModel>! = nil

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

			viewModel.dataReloadTrigger.value = ()


	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		viewModel.outputBookmarks.value = nil

	}


	override func viewDidLoad() {
		super.viewDidLoad()


		let logo = UIImage(resource: .title)
		let imageView = UIImageView(image: logo)


		imageView.contentMode = .scaleAspectFit
		navigationItem.titleView = imageView
		navigationController?.navigationBar.backgroundColor = .background


		bookmarkCollectionView.delegate = self
		configureDataSource()
		bind()
		updateSnapshot()
	}





	override func configureHierarchy() {

		view.addSubview(mapView)
		view.addSubview(bookmarkCollectionView)
	}

	override func configureLayout() {

		mapView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
			make.height.equalTo(288)
		}

		bookmarkCollectionView.snp.makeConstraints { make in
			make.top.equalTo(mapView.snp.bottom).offset(4)
			make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
			make.bottom.equalTo(view.safeAreaLayoutGuide)
		}
	}

	override func configureView() {

		mapView.layer.cornerRadius = 12
		mapView.layer.masksToBounds = true
//		mapView.
	}

	func bind() {
		viewModel.outputBookmarks.apiBind { _ in
			self.updateMapView(with: self.viewModel.outputBookmarks.value ?? [])

			self.updateSnapshot()
		}

	}



	func updateMapView(with bookmarks: [BookmarkRealmModel]) {
		for bookmark in bookmarks {
			guard let latitude = Double(bookmark.mapy),
				  let longitude = Double(bookmark.mapx) else {
				print("Invalid coordinates for bookmark \(bookmark.title)")
				continue
			}

			let annotation = MKPointAnnotation()
			annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			annotation.title = bookmark.title
//			annotation.subtitle = bookmark.contenttypeid  // Store contenttypeid for later reference in viewForAnnotation

			mapView.addAnnotation(annotation)
		}

		// Assuming you want to show all annotations within the map's visible region
		mapView.showAnnotations(mapView.annotations, animated: true)
	}

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


		let layout = UICollectionViewCompositionalLayout(section: section)
		return layout
	}

	func configureDataSource() {

		let cellRegistration = UICollectionView.CellRegistration<ResultCollectionViewCell, BookmarkRealmModel> { (cell, indexPath, identifier) in
			// Populate the cell with our item description.
			//			cell.mainLabel.text = "\(indexPath.section),\(indexPath.item)"
//			cell.searchKeyword = self.viewModel.inputKeyword.value
//			cell.updateUI(identifier)
			cell.updateUIInBookmarkVC(identifier)

			cell.bookmarkButton.tag = indexPath.item
			cell.bookmarkButton.addTarget(self, action: #selector(self.bookmarkButtonClicked), for: .touchUpInside)
			cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
			
			cell.mapButton.tag = indexPath.item
			cell.mapButton.addTarget(self, action: #selector(self.mapButtonClicked), for: .touchUpInside)

		}

		dataSource = UICollectionViewDiffableDataSource<Section, BookmarkRealmModel>(collectionView: bookmarkCollectionView) {
			(collectionView: UICollectionView, indexPath: IndexPath, identifier: BookmarkRealmModel) -> UICollectionViewCell? in
			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
		}

	}

	private func updateSnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<Section, BookmarkRealmModel>()
		snapshot.appendSections([.main])

		snapshot.appendItems(viewModel.outputBookmarks.value ?? [], toSection: .main)

		dataSource.apply(snapshot, animatingDifferences: true) //reloadData

		//realm과 결합할 때, 삭제 할때 스냅샷이 안먹힐때
//				dataSource.applySnapshotUsingReloadData(snapshot)
	}


	@objc func bookmarkButtonClicked(_ sender: UIButton) {
		SVProgressHUD.show()

		guard let data = viewModel.outputBookmarks.value?[sender.tag] else {
			return }

		viewModel.repository.deleteBookmarkInBookmarkView(data: data)
		viewModel.outputBookmarks.value = []
		viewModel.dataReloadTrigger.value = ()
		updateSnapshot()

		SVProgressHUD.dismiss(withDelay: 0.2)
	}

	@objc func mapButtonClicked(_ sender: UIButton) {
		guard let bookmark = viewModel.outputBookmarks.value?[sender.tag] else { return }

		// Optionally, zoom in on the map view when a bookmark is selected
		if let latitude = Double(bookmark.mapy),
		   let longitude = Double(bookmark.mapx) {
			let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
			mapView.setRegion(region, animated: true)

			UIView.animate(withDuration: 0.3) {
				self.mapView.isHidden = false
				self.mapView.snp.remakeConstraints { make in
					make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(8)
					make.height.equalTo(288)
				}

				self.view.layoutIfNeeded()
			}
		}
	}
}


extension BookmarkViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)

		if translation.y > 0 {
			UIView.animate(withDuration: 0.3) {
				self.mapView.isHidden = false
				self.mapView.snp.remakeConstraints { make in
					make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(8)
					make.height.equalTo(288)
				}

				self.view.layoutIfNeeded()
			}
		} else if translation.y < 0 {
				UIView.animate(withDuration: 0.3) {

					self.mapView.snp.remakeConstraints { make in
						make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(8)
						make.height.equalTo(0)
					}
					self.mapView.isHidden = true
					self.view.layoutIfNeeded()

			}
		}
	}
}


extension BookmarkViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	  }

}
