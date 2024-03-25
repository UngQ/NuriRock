//
//  MapViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/24/24.
//

import UIKit
import MapKit

final class MapViewController: BaseViewController {

	let viewModel = MapViewModel()

	private let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

		if let sheetPresentationController = sheetPresentationController {
			sheetPresentationController.detents = [.medium()]
			sheetPresentationController.prefersGrabberVisible = true

		}

    }


	override func configureHierarchy() {
		view.addSubview(mapView)
	}

	override func configureLayout() {
		mapView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalToSuperview()
			make.height.equalTo(view.frame.height/2)
		}
	}

	override func configureView() {

		guard let data = viewModel.outputContentInfo.value else { return }

		if let latitude = Double(data.mapy ?? "0"),
		   let longitude = Double(data.mapx ?? "0") {
			let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
			let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
			mapView.setRegion(region, animated: true)

			let annotation = MKPointAnnotation()
			annotation.coordinate = coordinate
			annotation.title = data.title

			mapView.addAnnotation(annotation)

		}

	}


}
