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

	func formatDateBasedOnLocale() -> String {
		let currentLocale = Locale.current.language.languageCode ?? "en"
		let dateFormatter = DateFormatter()

		// Checking if the current locale is Korea
		if currentLocale.identifier == "ko" {
			dateFormatter.dateFormat = "yyyy년 M월 d일"  // Korean date format e.g., 2024년 3월 12일
		} else {
			dateFormatter.dateFormat = "MMMM d, yyyy"  // American date format e.g., March 12, 2024
		}

		return dateFormatter.string(from: self)
	}
}

extension String {
	func formattedDateString() -> String {
		let inputFormatter = DateFormatter()
		inputFormatter.dateFormat = "yyyyMMdd"

		guard let date = inputFormatter.date(from: self) else { return self	}

		let outputFormatter = DateFormatter()

		if Locale.current.language.languageCode == "ko" {
			outputFormatter.dateFormat = "yyyy년 M월 d일"
		} else {
			outputFormatter.dateFormat = "MMMM d, yyyy"
		}

		return outputFormatter.string(from: date)
	}
}
