//
//  DetailContentInfoViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/18/24.
//

import UIKit
import MapKit
import SVProgressHUD

final class DetailContentInfoViewController: BaseViewController {

	let viewModel = DetailContentInfoViewModel()

	private lazy var scrollView = {
		let view = UIScrollView()
//		view.delegate = self
		view.isScrollEnabled = true
		return view
	}()

	private let contentView = UIView()

	private let mainImageView = {
		let view = UIImageView(frame: .zero)
		view.contentMode = .scaleAspectFill
		view.clipsToBounds = true
		view.layer.cornerRadius = 12
		return view
	}()

	private let titleLabel = {
		let view = UILabel()
		view.numberOfLines = 0
		view.font = .boldSystemFont(ofSize: 14)
		return view
	}()

	private let addrLabel = {
		let view = UILabel()
		view.numberOfLines = 0
		view.font = .boldSystemFont(ofSize: 12)
		return view
	}()

	private let mapView = {
		let view = MKMapView()
		view.layer.cornerRadius = 12
		view.layer.masksToBounds = true
		return view
	}()

	private let overViewLabel = {
		let view = UILabel()
		view.numberOfLines = 0
		view.font = .boldSystemFont(ofSize: 12)
		return view
	}()

	private let lineView = {
		let view = UIView()
		view.backgroundColor = .point
		return view
	}()

	private let secondLineView = {
		let view = UIView()
		view.backgroundColor = .point
		return view
	}()

	private let moreInfoButton = {
		let view = UIButton()
		view.backgroundColor = .green
		return view
	}()


    override func viewDidLoad() {
        super.viewDidLoad()
		bind()
		configureNavigationBar()
		makeRealmObserve()

    }

	private func makeRealmObserve() {
		viewModel.observationToken = viewModel.bookmarks?.observe { changes in
			switch changes {
			case .initial:
				print("init")
			case .update:
				print("update")
				if self.viewModel.repository.isBookmarked(contentId: self.viewModel.inputContentId.value ?? "") {
					let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(self.rightBarButtonClicked))
					self.navigationItem.rightBarButtonItem = rightBarButton
				} else {
					let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(self.rightBarButtonClicked))
					self.navigationItem.rightBarButtonItem = rightBarButton
				}
			case .error:
				print("error")
			}

		}
	}

	override func configureHierarchy() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		contentView.addSubview(mainImageView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(addrLabel)
		contentView.addSubview(overViewLabel)
		contentView.addSubview(mapView)

		contentView.addSubview(lineView)
		contentView.addSubview(secondLineView)
		contentView.addSubview(moreInfoButton)
	}

	override func configureLayout() {
		scrollView.snp.makeConstraints { make in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}

		contentView.snp.makeConstraints { make in
			make.verticalEdges.equalTo(scrollView)
			make.width.equalTo(scrollView.snp.width)
		}

		mainImageView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(contentView).inset(8)
			make.height.equalTo(288)
		}

		moreInfoButton.snp.makeConstraints { make in
			make.bottom.horizontalEdges.equalTo(contentView).inset(8)
			make.height.equalTo(40)
		}

		mapView.snp.makeConstraints { make in
			make.bottom.equalTo(moreInfoButton.snp.top).offset(-8)
			make.horizontalEdges.equalTo(contentView).inset(8)
			make.height.equalTo(288)
		}

		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(mainImageView.snp.bottom).offset(8)
			make.horizontalEdges.equalTo(contentView).inset(8)

		}

		lineView.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
			make.horizontalEdges.equalTo(contentView).inset(8)
			make.height.equalTo(1)
		}

		addrLabel.snp.makeConstraints { make in
			make.top.equalTo(lineView.snp.bottom).offset(8)
			make.horizontalEdges.equalTo(contentView).inset(8)

		}

		secondLineView.snp.makeConstraints { make in
			make.top.equalTo(addrLabel.snp.bottom).offset(8)
			make.horizontalEdges.equalTo(contentView).inset(8)
			make.height.equalTo(1)
		}

		overViewLabel.snp.makeConstraints { make in
			make.top.equalTo(secondLineView.snp.bottom).offset(8)
			make.horizontalEdges.equalTo(contentView).inset(8)
			make.bottom.equalTo(mapView.snp.top).offset(-8)
		}
	}

	override func configureView() {
		moreInfoButton.isHidden = true
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

	@objc private func rightBarButtonClicked(_ sender: UIBarButtonItem) {

		SVProgressHUD.show()
		guard let data = viewModel.outputContentInfo.value?[0] else { return }

		if viewModel.repository.isBookmarked(contentId: data.contentid) {
			sender.image = UIImage(systemName: "bookmark")
			viewModel.repository.deleteBookmark(data: data)

			SVProgressHUD.dismiss(withDelay: 0.2)

		} else {
			sender.image = UIImage(systemName: "bookmark.fill")
			viewModel.repository.addBookmarkInDetailView(data: data)

			SVProgressHUD.dismiss(withDelay: 0.2)
		}


	}

	private func bind() {

		SVProgressHUD.show()

		viewModel.outputContentInfo.apiBind { _ in

			DispatchQueue.main.async {



				if self.viewModel.repository.isBookmarked(contentId: self.viewModel.inputContentId.value ?? "") {
					let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(self.rightBarButtonClicked))
					self.navigationItem.rightBarButtonItem = rightBarButton
				} else {
					let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(self.rightBarButtonClicked))
					self.navigationItem.rightBarButtonItem = rightBarButton
				}

				guard let data = self.viewModel.outputContentInfo.value?[0] else { return }

				//이미지 바인드
				let url = URL(string: data.firstimage)
				self.mainImageView.kf.setImage(with: url)

				//타이틀 바인드
				self.titleLabel.text = data.title

				//주소 바인드
				self.addrLabel.text = data.addr1 + data.addr2
				

				//오버뷰 바인드
				
				self.overViewLabel.attributedText = data.overview?.attributedStringFromHTML(withFont: .boldSystemFont(ofSize: 12), color: .text)

				//맵뷰 바인드
				if let latString = data.mapy,
				   let lonString = data.mapx,
				   let latitude = Double(latString),
				   let longitude = Double(lonString) {
					let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
					let annontation = MKPointAnnotation()
					annontation.coordinate = coordinate
					annontation.title = self.viewModel.outputContentInfo.value?[0].title

					let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
					self.mapView.setRegion(region, animated: true)

					self.mapView.addAnnotation(annontation)
				} else {
					// Handle the case where conversion failed or values were nil
					print("Failed to convert strings to doubles or values were nil.")
				}
			}
			SVProgressHUD.dismiss()
		}
	}

	private func updateBookmarkButton(isBookmarked: Bool) {
		let buttonImage = UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
		let rightBarButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(rightBarButtonClicked))
		self.navigationItem.rightBarButtonItem = rightBarButton
	}
}
