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
import RealmSwift

//cell.cityLabel.text = NSLocalizedString(CityCode.allCases[indexPath.row].name, comment: "")


final class BookmarkViewController: BaseViewController {

	private enum Section {
		case main
	}

	let viewModel = BookmarkViewModel()
	private let locationManager = CLLocationManager()

	private let mapView = MKMapView()

	private let distanceLabel = UILabel()

	private let cityScrollView = UIScrollView()
	private let cityStackView = UIStackView()
	private weak var selectedButton: UIButton?
	private var lastSelectedIndex: Int?

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

		guard let index = lastSelectedIndex else { return }
		guard let button = cityStackView.arrangedSubviews[index] as? UIButton else { return }
				 cityStackViewClicked(button)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		checkDeviceLocationAuthorization()
		configureNavigationBar()
		configureStackView()
		configureDataSource()
		bind()
		makeRealmObserve()


	}


	private func makeRealmObserve() {
		viewModel.observationToken = viewModel.totalBookmarks?.observe { changes in
			switch changes {
			case .initial:
				self.viewModel.outputBookmarks.value = Array(self.viewModel.totalBookmarks)

				self.updateSnapshot()

				if let firstButton = self.cityStackView.arrangedSubviews.first as? UIButton {
					print(firstButton.tag)
					self.cityStackViewClicked(firstButton)
				}

			case .update(let boomarks, let deletions, let insertions, let modifications):

				self.viewModel.outputBookmarks.value = Array(self.viewModel.totalBookmarks)

				if deletions.count > 0 {
					print("delete")
					self.updateSnapshot()
				} else {
					print("update")
					self.updateSnapshot()
				}

				guard let selectedIndex = self.lastSelectedIndex,
					  let button = self.cityStackView.arrangedSubviews[selectedIndex] as? UIButton else { return }
				self.cityStackViewClicked(button)




			case .error:
				print("error")
			}

		}
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

		view.addSubview(cityScrollView)
		cityScrollView.addSubview(cityStackView)

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

		cityScrollView.snp.makeConstraints { make in
			make.top.equalTo(mapView.snp.bottom).offset(8)
			make.horizontalEdges.equalToSuperview().inset(8)
			make.height.equalTo(24)
		}

		cityStackView.snp.makeConstraints { make in
			make.height.equalTo(24)
			make.edges.equalTo(cityScrollView)
		}

		bookmarkCollectionView.snp.makeConstraints { make in
			make.top.equalTo(cityScrollView.snp.bottom).offset(8)
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

		cityStackView.spacing = 8
	}

	private func bind() {
//		viewModel.outputBookmarks.apiBind { data in
////			self.updateMapView(with: data ?? [])
//
//			self.updateSnapshot()
//		}

	}

	private func configureStackView() {

		let button = UIButton()
		button.setTitle(" \(NSLocalizedString(LocalString.total.rawValue, comment: "")) ", for: .normal)
		button.setTitleColor(.text, for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 12)
//		button.layer.borderColor = UIColor.black.cgColor
//		button.layer.borderWidth = 1
//		button.layer.cornerRadius = 4
		button.tag = 0
		cityStackView.addArrangedSubview(button)

		button.addTarget(self, action: #selector(cityStackViewClicked), for: .touchUpInside)

		var cityTag = 1
		for cityCode in CityCode.allCases {
			let button = UIButton()
			button.tag = cityTag
			cityTag += 1

			button.setTitle(" \(NSLocalizedString(cityCode.name, comment: "")) ", for: .normal)
			button.setTitleColor(.lightGray, for: .normal)
			button.titleLabel?.font = .boldSystemFont(ofSize: 12)
//			button.layer.borderColor = UIColor.black.cgColor
//			button.layer.borderWidth = 1
//			button.layer.cornerRadius = 4

			cityStackView.addArrangedSubview(button)

			button.addTarget(self, action: #selector(cityStackViewClicked), for: .touchUpInside)
		 }
	}

	@objc private  func cityStackViewClicked(_ sender: UIButton) {
		mapView.removeAnnotations(mapView.annotations)

		selectedButton?.backgroundColor = .clear
		selectedButton?.setTitleColor(.lightGray, for: .normal)
//		sender.backgroundColor = .point
		sender.setTitleColor(.text, for: .normal)
		selectedButton = sender
		lastSelectedIndex = sender.tag
		checkDeviceLocationAuthorization()
		if sender.tag == 0 {
			viewModel.outputBookmarks.value = Array(viewModel.totalBookmarks)
		} else {

			viewModel.filterBookmarks(by: CityCode.allCases[sender.tag - 1])
		}

		updateSnapshot()

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
				  let longitude = Double(bookmark.mapx) else { return }

			let annotation = MKPointAnnotation()
			annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			annotation.title = bookmark.title

			mapView.addAnnotation(annotation)
			mapView.showAnnotations(mapView.annotations, animated: true)
		}
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
		
		if dataSource != nil {
			snapshot.deleteAllItems()
			dataSource.apply(snapshot, animatingDifferences: true)
		}

		snapshot.appendSections([.main])

		let bookmarks = viewModel.outputBookmarks.value ?? []

		snapshot.appendItems(bookmarks, toSection: .main)

		dataSource.apply(snapshot, animatingDifferences: true) //reloadData
		self.updateMapView(with: bookmarks)

		//realm과 결합할 때, 삭제 할때 스냅샷이 안먹힐때
//				dataSource.applySnapshotUsingReloadData(snapshot)

		noBookmarksLabel.isHidden = !bookmarks.isEmpty
		  bookmarkCollectionView.isHidden = bookmarks.isEmpty
	}


	@objc private func bookmarkButtonClicked(_ sender: UIButton) {
		SVProgressHUD.show()


//		print(Array(viewModel.outputBookmarks.value ?? [])[sender.tag])

		viewModel.repository.deleteBookmarkInBookmarkView(data: Array(viewModel.outputBookmarks.value ?? [])[sender.tag])





		SVProgressHUD.dismiss(withDelay: 0.2)
	}

	@objc private func mapButtonClicked(_ sender: UIButton) {
		guard let bookmark = viewModel.outputBookmarks.value?[sender.tag] else { return }

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

			distanceLabel.text = NSLocalizedString(LocalString.awayLocation.rawValue, comment: "") + (formatToDecimalString(distance/1000)) + "km"

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

		let region = MKCoordinateRegion(center: viewData, latitudinalMeters: 10000, longitudinalMeters: 10000)
		mapView.setRegion(region, animated: true)

		let myLocation = CLLocation(latitude: data.latitude, longitude: data.longitude)
		let distance = CLLocation(latitude: viewData.latitude, longitude: viewData.longitude).distance(from: myLocation)

		distanceLabel.text = NSLocalizedString(LocalString.awayLocation.rawValue, comment: "") + (formatToDecimalString(distance/1000)) + "km"

	}
}

