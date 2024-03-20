//
//  BookmarkViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/20/24.
//

import UIKit
import MapKit

final class BookmarkViewController: BaseViewController {




	let viewModel = DetailContentInfoViewModel()

	let scrollView = UIScrollView()
	let contentView = UIView()

	let mainImageView = {
		let view = UIImageView(frame: .zero)
		view.contentMode = .scaleAspectFill
		view.clipsToBounds = true
		view.layer.cornerRadius = 12
		return view
	}()

	let titleLabel = {
		let view = UILabel()
		view.text = "test"
		return view
	}()

	let addrLabel = {
		let view = UILabel()
		view.text = "test"
		return view
	}()

	let mapView = MKMapView()



	override func viewDidLoad() {
		super.viewDidLoad()

		let logo = UIImage(resource: .title)
		let imageView = UIImageView(image: logo)


		imageView.contentMode = .scaleAspectFit
		navigationItem.titleView = imageView
		navigationController?.navigationBar.backgroundColor = .white

	}



	override func configureHierarchy() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		contentView.addSubview(mainImageView)
		contentView.addSubview(titleLabel)
		contentView.addSubview(addrLabel)
		contentView.addSubview(mapView)
	}

	override func configureLayout() {
		scrollView.snp.makeConstraints { make in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}

		contentView.snp.makeConstraints { make in
			make.verticalEdges.equalTo(scrollView)
			make.width.equalTo(scrollView.snp.width)
		}

		mapView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(contentView).inset(8)
			make.height.equalTo(288)
		}

		titleLabel.snp.makeConstraints { make in
			make.bottom.horizontalEdges.equalTo(contentView).inset(8)
			make.height.equalTo(288)
		}

		addrLabel.snp.makeConstraints { make in
			make.top.equalTo(mapView.snp.bottom).offset(8)
			make.horizontalEdges.equalTo(contentView)
			make.bottom.equalTo(titleLabel.snp.top)
		}
	}

	override func configureView() {
		titleLabel.backgroundColor = .green
		addrLabel.backgroundColor = .blue
		scrollView.delegate = self
		scrollView.isScrollEnabled = true

		addrLabel.numberOfLines = 0
		addrLabel.font = .boldSystemFont(ofSize: 40)
		addrLabel.text = "adfasdfsadf333fadfasdfasdfasdfasdfasdfasdfsdfasdf\n\n\nfadfasdfasdfasdfasdf\n\nasdfasdfadfafdasdf\n\nasdfasdfsadfasdf"

	}

	func bind() {
		viewModel.outputContentInfo.apiBind { _ in
			let url = URL(string: self.viewModel.outputContentInfo.value?[0].firstimage ?? "")
			self.mainImageView.kf.setImage(with: url)

			if let latString = self.viewModel.outputContentInfo.value?[0].mapy,
			   let lonString = self.viewModel.outputContentInfo.value?[0].mapx,
			   let latitude = Double(latString),
			   let longitude = Double(lonString) {
				let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
				let annontation = MKPointAnnotation()
				annontation.coordinate = coordinate
				annontation.title = self.viewModel.outputContentInfo.value?[0].title

				let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 30000, longitudinalMeters: 30000)
				self.mapView.setRegion(region, animated: true)

				self.mapView.addAnnotation(annontation)
			} else {
				// Handle the case where conversion failed or values were nil
				print("Failed to convert strings to doubles or values were nil.")
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
					make.top.horizontalEdges.equalTo(self.contentView).inset(8)
					make.height.equalTo(288)
				}

				self.view.layoutIfNeeded()
			}
		} else if translation.y < 0 {
				UIView.animate(withDuration: 0.3) {
					self.mapView.isHidden = true
					self.mapView.snp.remakeConstraints { make in
						make.top.horizontalEdges.equalTo(self.contentView).inset(8)
						make.height.equalTo(0)
					}
					self.view.layoutIfNeeded()

			}
		}
	}
}
