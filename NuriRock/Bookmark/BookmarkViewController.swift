//
//  BookmarkViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/20/24.
//

import UIKit
import MapKit
import CoreLocation
import SVProgressHUD

final class BookmarkViewController: BaseViewController {

	private enum Section {
		case main
	}

	let viewModel = BookmarkViewModel()
	private let locationManager = CLLocationManager()

	private let mapView = MKMapView()

	private let distanceLabel = UILabel()

	private lazy var bookmarkCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
	private var dataSource: UICollectionViewDiffableDataSource<Section, BookmarkRealmModel>! = nil


	private let noBookmarksLabel: UILabel = {
		  let label = UILabel()
		  label.text = NSLocalizedString(LocalString.noBookmarks.rawValue, comment: "")
		  label.textAlignment = .center
		  label.isHidden = true
		  return label
	  }()


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

			viewModel.dataReloadTrigger.value = ()

		checkDeviceLocationAuthorization()

	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		viewModel.outputBookmarks.value = nil

	}


	override func viewDidLoad() {
		super.viewDidLoad()

		configureNavigationBar()
		configureDataSource()
		bind()
		updateSnapshot()
	}

	private func configureNavigationBar() {
		let logo = UIImage(resource: .title)
		let imageView = UIImageView(image: logo)

		imageView.contentMode = .scaleAspectFit

		let titleView = UIView()
		  titleView.addSubview(imageView)

		imageView.snp.makeConstraints { make in
			make.centerX.centerY.equalTo(titleView)
			make.height.width.equalTo(44)
		}

		  self.navigationItem.titleView = titleView

		  titleView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: 44)


		navigationController?.navigationBar.backgroundColor = .background
	}



	override func configureHierarchy() {

		view.addSubview(mapView)
		view.addSubview(bookmarkCollectionView)
		view.addSubview(distanceLabel)

		view.addSubview(noBookmarksLabel)
	}

	override func configureLayout() {

		mapView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
			make.height.equalTo(288)
		}

		distanceLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalTo(mapView.snp.bottom)
		}

		bookmarkCollectionView.snp.makeConstraints { make in
			make.top.equalTo(mapView.snp.bottom).offset(4)
			make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
			make.bottom.equalTo(view.safeAreaLayoutGuide)
		}

		noBookmarksLabel.snp.makeConstraints { make in
			make.center.equalTo(bookmarkCollectionView)
			 
		 }
	}

	override func configureView() {
		locationManager.delegate = self
		bookmarkCollectionView.delegate = self
		mapView.delegate = self

		mapView.layer.cornerRadius = 12
		mapView.layer.masksToBounds = true

		distanceLabel.font = .boldSystemFont(ofSize: 12)
		distanceLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
	}

	private func bind() {
		viewModel.outputBookmarks.apiBind { _ in
			self.updateMapView(with: self.viewModel.outputBookmarks.value ?? [])

			self.updateSnapshot()
		}

	}



	private func updateMapView(with bookmarks: [BookmarkRealmModel]) {

		if let myLocation = viewModel.inputMyLocation.value {
			let annontation = MKPointAnnotation()
			annontation.coordinate = myLocation
			annontation.title = NSLocalizedString(LocalString.myLocation.rawValue, comment: "")
			mapView.addAnnotation(annontation)
		}

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

			if let myLocation = viewModel.inputMyLocation.value {
				let annontation = MKPointAnnotation()
				annontation.coordinate = myLocation
				mapView.addAnnotation(annontation)
			}
		}

		// Assuming you want to show all annotations within the map's visible region
		mapView.showAnnotations(mapView.annotations, animated: true)
	}

	private func createLayout() -> UICollectionViewLayout {
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

	private func configureDataSource() {

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


		let bookmarks = viewModel.outputBookmarks.value ?? []
		snapshot.appendItems(bookmarks, toSection: .main)

		dataSource.apply(snapshot, animatingDifferences: true) //reloadData

		//realm과 결합할 때, 삭제 할때 스냅샷이 안먹힐때
//				dataSource.applySnapshotUsingReloadData(snapshot)

		noBookmarksLabel.isHidden = !bookmarks.isEmpty
		  bookmarkCollectionView.isHidden = bookmarks.isEmpty
	}


	@objc private func bookmarkButtonClicked(_ sender: UIButton) {
		SVProgressHUD.show()

		guard let data = viewModel.outputBookmarks.value?[sender.tag] else {
			return }

		viewModel.repository.deleteBookmarkInBookmarkView(data: data)
		viewModel.outputBookmarks.value = []
		viewModel.dataReloadTrigger.value = ()
		updateSnapshot()
		mapView.removeAnnotations(self.mapView.annotations)
		self.updateMapView(with: self.viewModel.outputBookmarks.value ?? [])

		SVProgressHUD.dismiss(withDelay: 0.2)
	}

	@objc private func mapButtonClicked(_ sender: UIButton) {
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

			guard let data = viewModel.inputMyLocation.value else { return }
			let myLocation = CLLocation(latitude: data.latitude, longitude: data.longitude)
			let distance = CLLocation(latitude: latitude, longitude: longitude).distance(from: myLocation)

			distanceLabel.text = "현재 위치로 부터 약 \(formatToDecimalString(distance/1000)) km"

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

		let vc = DetailContentInfoViewController()
		vc.viewModel.inputContentId.value = viewModel.outputBookmarks.value?[indexPath.item].contentid
		navigationController?.pushViewController(vc, animated: true)

		
	  }

}


extension BookmarkViewController {

	func checkDeviceLocationAuthorization() {

		DispatchQueue.global().async {

			if CLLocationManager.locationServicesEnabled() {
				let authorization: CLAuthorizationStatus

				if #available(iOS 14.0, *) {
					authorization = self.locationManager.authorizationStatus
				} else {
					authorization = CLLocationManager.authorizationStatus()
				}

				DispatchQueue.main.async {

					self.checkCurrentLocationAuthorization(status: authorization)
				}
			}
			else {
					print("??")
				}
			}
		}


	func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {

		switch status {
		case .notDetermined:

			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			locationManager.requestWhenInUseAuthorization()

		case .denied:

//			showLocationSettingAlert()
			locationManager.startUpdatingLocation()

		case .authorizedWhenInUse:

			locationManager.startUpdatingLocation()

		default:
			print("checkCurrentLocationAuthorization default")
		}
	}



	func setRegionAndAnnontation(center: CLLocationCoordinate2D) {

		let region = MKCoordinateRegion(center: center, latitudinalMeters: 30000, longitudinalMeters: 30000)
		mapView.setRegion(region, animated: true)

	}
}


extension BookmarkViewController: CLLocationManagerDelegate {

	

	func addAnnotation(coordinate: CLLocationCoordinate2D) {
		let annontation = MKPointAnnotation()
		annontation.coordinate = coordinate
		annontation.title = NSLocalizedString(LocalString.myLocation.rawValue, comment: "")

			self.mapView.addAnnotation(annontation)
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last?.coordinate {

			viewModel.inputMyLocation.value = location

			setRegionAndAnnontation(center: location)

			addAnnotation(coordinate: location)

		}

		locationManager.stopUpdatingLocation()

	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		//37.654165, 127.049696 씨드큐브 창동

//		guard let coordinate = viewModel.inputMyLocation.value else { return }
//		setRegionAndAnnontation(center: coordinate)
//		addAnnotation(coordinate: coordinate)

	}

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkDeviceLocationAuthorization()
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		checkDeviceLocationAuthorization()
	}



}


extension BookmarkViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		guard let viewData = view.annotation?.coordinate else { return }
		guard let data = viewModel.inputMyLocation.value else { return }
		let myLocation = CLLocation(latitude: data.latitude, longitude: data.longitude)
		let distance = CLLocation(latitude: viewData.latitude, longitude: viewData.longitude).distance(from: myLocation)

		distanceLabel.text = NSLocalizedString(LocalString.awayLocation.rawValue, comment: "") + (formatToDecimalString(distance/1000)) + "km"

	}
}

