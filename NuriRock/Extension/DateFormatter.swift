//
//  DateFormatter.swift
//  NuriRock
//
//  Created by ungQ on 3/11/24.
//

import Foundation


extension Date {
	func toYYYYMMDD() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyyMMdd"
		return formatter.string(from: self)
	}
}
