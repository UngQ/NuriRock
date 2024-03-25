//
//  PrivacyWebViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/25/24.
//

import UIKit
import WebKit

final class PrivacyWebViewController: BaseViewController {

	private let webView = WKWebView()
	var url = ""

    override func viewDidLoad() {
        super.viewDidLoad()

		let url = URL(string: url)
		let request = URLRequest(url: url!)
		webView.load(request)
    }
    
	override func configureHierarchy() {
		view.addSubview(webView)
	}

	override func configureLayout() {
		webView.snp.makeConstraints { make in
			make.edges.equalTo(view.safeAreaLayoutGuide)
		}

	}

	override func configureView() {

	}



}
