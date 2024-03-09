//
//  Country.swift
//  NuriRock
//
//  Created by ungQ on 3/7/24.
//

import Foundation

enum Country: String, CaseIterable {
	case korea = "ko"
	case usa = "en"
	case china = "zh"
	case japan = "ja"

	var flag: String {
		switch self {
		case .korea: return "🇰🇷"
		case .usa: return "🇺🇸"
		case .china: return "🇨🇳"
		case .japan: return "🇯🇵"
		}
	}

	static func from(languageCode: String) -> Country {
			return Country.allCases.first { $0.rawValue == languageCode } ?? .usa
		}

}
