//
//  BaseViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/7/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .background

		configureHierarchy()
		configureLayout()
		configureView()
    }
	
	func configureHierarchy() {}
	func configureLayout() {}
	func configureView() {}
}
