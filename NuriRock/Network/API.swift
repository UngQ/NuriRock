//
//  API.swift
//  NuriRock
//
//  Created by ungQ on 3/12/24.
//

import Foundation
import Alamofire


enum API {
	case searchKeyword(keyword: String, contentType: ContentType, numOfRows: Int, pageNo: Int)
	case areaBasedList(contentType: ContentType, areaCode: CityCode, numOfRows: Int, pageNo: Int)
	case searchFestival(eventStartDate: String, areaCode: CityCode, numOfRows: Int, pageNo: Int)
	case detailCommon(contentId: String)

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
		case .detailCommon:
			return baseURL + "/detailCommon1"
		}
	}

	var parameter: Parameters {
		var params: [String: Any] = [
			"serviceKey": APIKey.korDataAPIServiceKey,
			"MobileOS": "IOS",
			"MobileApp": "NuriROCK",
			"_type": "json",
		]

		switch self {
		case .searchKeyword(let keyword, let contentType, let numOfRows, let pageNo):
			params["keyword"] = keyword
			params["contentTypeId"] = contentType.contentTypeCode
			params["numOfRows"] = numOfRows
			params["pageNo"] = pageNo
			params["listYN"] = "Y"
			params["arrange"] = "Q"

		case .areaBasedList(let contentType, let areaCode, let numOfRows, let pageNo):
			params["contentTypeId"] = contentType.contentTypeCode
			params["numOfRows"] = numOfRows
			params["pageNo"] = pageNo
			params["areaCode"] = areaCode.rawValue
			params["listYN"] = "Y"
			params["arrange"] = "Q"

		case .searchFestival(let eventStartDate, let areaCode, let numOfRows, let pageNo):
			params["eventStartDate"] = eventStartDate
			params["eventEndDate"] = eventStartDate
			params["numOfRows"] = numOfRows
			params["pageNo"] = pageNo
			params["areaCode"] = areaCode.rawValue
			params["listYN"] = "Y"
			params["arrange"] = "Q"

		case .detailCommon(let contentId):
			params["contentId"] = contentId
			params["defaultYN"] = "Y"
			params["firstImageYN"] = "Y"
			params["addrinfoYN"] = "Y"
			params["mapinfoYN"] = "Y"
			params["overviewYN"] = "Y"
			params["areacodeYN"] = "Y"
//			params["numOfRows"] = 10
//			params["pageNo"] = 1
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
