//
//  APIModel.swift
//  NuriRock
//
//  Created by ungQ on 3/10/24.
//

import Foundation


struct Test: Codable {
	let response: Response
}

// MARK: - Response
struct Response: Codable {
	let header: Header
	let body: Body
}

// MARK: - Body
struct Body: Codable {
	let items: Items?
	let numOfRows, pageNo, totalCount: Int

	//items가 0개 일떄 String("")으로 전달받는 것을 처리
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		numOfRows = try container.decode(Int.self, forKey: .numOfRows)
		pageNo = try container.decode(Int.self, forKey: .pageNo)
		totalCount = try container.decode(Int.self, forKey: .totalCount)

		if let itemsObject = try? container.decode(Items.self, forKey: .items) {
			items = itemsObject
		} else if let itemsString = try? container.decode(String.self, forKey: .items), itemsString == "" {
			items = nil
		} else {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath + [CodingKeys.items], debugDescription: "Expected items to be either an Items object or an empty string"))
		}
	}
}

// MARK: - Items
struct Items: Codable {
	let item: [Item]

	
}

// MARK: - Item
struct Item: Codable {
	let addr1, addr2, areacode: String
	let contentid, contenttypeid: String
	let createdtime: String
	let firstimage, firstimage2: String
	let mapx, mapy, mlevel, modifiedtime: String
	let tel, title: String
	let zipcode, eventstartdate, eventenddate: String?


}

//enum Cat1: String, Codable {
//	case a01 = "A01"
//	case a02 = "A02"
//}


// MARK: - Header
struct Header: Codable {
	let resultCode, resultMsg: String
}



