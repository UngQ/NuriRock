//
//  setViewShadow.swift
//  NuriRock
//
//  Created by ungQ on 3/21/24.
//

import UIKit


extension UIView {
	func setViewShadow(backView: UIView) {
		backView.layer.masksToBounds = true
		backView.layer.cornerRadius = 10
//		backView.layer.borderWidth = 1
//		backView.layer.borderColor = UIColor.white.cgColor

		layer.masksToBounds = false
		layer.shadowOpacity = 0.4
		layer.shadowOffset = CGSize(width: -2, height: 2)
		layer.shadowRadius = 3
	}
}
