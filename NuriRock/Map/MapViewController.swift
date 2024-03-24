//
//  MapViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/24/24.
//

import UIKit
import MapKit

class MapViewController: BaseViewController {

	let mapView = MKMapView()

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
		
	}



}
