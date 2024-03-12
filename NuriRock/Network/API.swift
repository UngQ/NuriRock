//
//  API.swift
//  NuriRock
//
//  Created by ungQ on 3/12/24.
//

import Foundation
import Alamofire

enum API {
	case tour(areaCode: String)
	case culture(areaCode: String)
	case festival(areaCode: String, date: String)
	case hotel(areaCode: String)
	case shopping(areaCode: String)
	case restaurant(areaCode: String)

	var baseURL: String {
		let languageCode = Locale.current.language.languageCode ?? "en"
		switch languageCode {
		case "ko":
			return "http://apis.data.go.kr/B551011/KorService1"
		default:
			return "http://apis.data.go.kr/B551011/EngService1"
		}
	}

	var contentTypeCode: String {
		let languageCode = Locale.current.language.languageCode ?? "en"
		switch self {
		case .tour:
			return languageCode == "ko" ? "12" : "76"
		case .culture:
			return languageCode == "ko" ? "14" : "78"
		case .festival:
			return languageCode == "ko" ? "15" : "85"
		case .hotel:
			return languageCode == "ko" ? "32" : "80"
		case .shopping:
			return languageCode == "ko" ? "38" : "79"
		case .restaurant:
			return languageCode == "ko" ? "39" : "82"
		}
	}

	var areaCode: String {
		switch self {
		case .tour(let code),
				.culture(let code),
				.festival(let code, _),
				.hotel(let code),
				.shopping(let code),
				.restaurant(let code):
			return code
		}
	}

	var date: String? {
		switch self {
		case .festival(_, let date):
			return date
		default:
			return nil
		}
	}

	var endPoint: String {
		switch self {
		case .festival:
			return baseURL + "/searchFestival1"

		default:
			return baseURL + "/areaBasedList1"
		}
	}

	var method: HTTPMethod {
		return .get
	}

	var parameter: Parameters? {
		var paras: [String: Any] = [
			"serviceKey": APIKey.korDataAPIServiceKey,
			"numOfRows": "10",
			"pageNo": "1",
			"MobileOS": "IOS",
			"MobileApp": "NuriRock",
			"_type": "json",
			"listYN": "Y",
			"arrange": "Q",
			"areaCode": areaCode
		]

		if let date = self.date {
			paras["eventStartDate"] = date
		} else {
			paras["contentTypeId"] = contentTypeCode
		}

		return paras
	}

	var encoding: URLEncoding {
		return .queryString
	}
}
