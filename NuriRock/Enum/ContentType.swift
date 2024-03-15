//
//  ContentType.swift
//  NuriRock
//
//  Created by ungQ on 3/10/24.
//

import Foundation

enum ContentType: Int, CaseIterable {
	case tour
	case culture
	case festival
	case hotel
	case shopping
	case restaurant

	var contentTypeCode: String {
		switch self {
		case .tour:
			return Locale.current.language.languageCode == "ko" ? "12" : "76"
		case .culture:
			return Locale.current.language.languageCode == "ko" ? "14" : "78"
		case .festival:
			return Locale.current.language.languageCode == "ko" ? "15" : "85"
		case .hotel:
			return Locale.current.language.languageCode == "ko" ? "32" : "80"
		case .shopping:
			return Locale.current.language.languageCode == "ko" ? "38" : "79"
		case .restaurant:
			return Locale.current.language.languageCode == "ko" ? "39" : "82"
		}
	}
}
