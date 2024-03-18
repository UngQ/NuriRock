//
//  DetailContentInfoViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/18/24.
//

import UIKit

class DetailContentInfoViewController: BaseViewController {

	var contentID = ""

	let label = {
		let view = UILabel()
		view.text = "test"
		return view
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

	override func configureHierarchy() {
		view.addSubview(label)
	}

	override func configureLayout() {
		label.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}

	override func configureView() {

	}



}
