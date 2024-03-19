//
//  DetailContentInfoViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/18/24.
//

import UIKit
import MapKit

class DetailContentInfoViewController: BaseViewController {

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
		bind()
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

		mainImageView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(contentView).inset(8)
			make.height.equalTo(288)
		}

		mapView.snp.makeConstraints { make in
			make.bottom.horizontalEdges.equalTo(contentView).inset(8)
			make.height.equalTo(288)
		}

		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(mainImageView.snp.bottom).offset(8)
			make.horizontalEdges.equalTo(contentView)
			make.height.equalTo(400)
		}

		addrLabel.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
			make.horizontalEdges.equalTo(contentView)
			make.bottom.equalTo(mapView.snp.top)
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

extension DetailContentInfoViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {

	}
}
