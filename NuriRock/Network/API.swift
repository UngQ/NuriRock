//
//  API.swift
//  NuriRock
//
//  Created by ungQ on 3/12/24.
//

import Foundation
import Alamofire


enum API {
	case searchKeyword(keyword: String, contentType: ContentType, areaCode: CityCode, numOfRows: Int, pageNo: Int)
	case areaBasedList(contentType: ContentType, areaCode: CityCode, numOfRows: Int, pageNo: Int)
	case searchFestival(eventStartDate: String, areaCode: CityCode, numOfRows: Int, pageNo: Int)

	enum ContentType: String {
		case tour = "tour"
		case culture = "culture"
		case festival = "festival"
		case hotel = "hotel"
		case shopping = "shopping"
		case restaurant = "restaurant"

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

	var baseURL: String {
		return Locale.current.language.languageCode == "ko" ? "http://apis.data.go.kr/B551011/KorService1" : "http://apis.data.go.kr/B551011/EngService1"
	}

	var endPoint: String {
		switch self {
		case .searchKeyword:
			return baseURL + "/searchKeyword1"
		case .areaBasedList:
			return baseURL + "/areaBasedList1"
		case .searchFestival:
			return baseURL + "/searchFestival1"
		}
	}

	var parameter: [String: Any] {
		var params: [String: Any] = [
			"serviceKey": APIKey.korDataAPIServiceKey,
			"MobileOS": "IOS",
			"MobileApp": "NuriRock",
			"_type": "json",
			"listYN": "Y",
			"arrange": "Q"
		]

		switch self {
		case .searchKeyword(let keyword, let contentType, let areaCode, let numOfRows, let pageNo):
			params["keyword"] = keyword
			params["contentTypeId"] = contentType.contentTypeCode
			params["numOfRows"] = numOfRows
			params["pageNo"] = pageNo
			params["areaCode"] = areaCode.rawValue

		case .areaBasedList(let contentType, let areaCode, let numOfRows, let pageNo):
			params["contentTypeId"] = contentType.contentTypeCode
			params["numOfRows"] = numOfRows
			params["pageNo"] = pageNo
			params["areaCode"] = areaCode.rawValue

		case .searchFestival(let eventStartDate, let areaCode, let numOfRows, let pageNo):
			params["eventStartDate"] = eventStartDate.formattedDateString()
			params["contentTypeId"] = ContentType.festival.contentTypeCode
			params["numOfRows"] = numOfRows
			params["pageNo"] = pageNo
			params["areaCode"] = areaCode.rawValue
		}

		return params
	}

	var method: HTTPMethod {
		return .get
	}
	
	var encoding: URLEncoding {
		return .queryString
	}
}
