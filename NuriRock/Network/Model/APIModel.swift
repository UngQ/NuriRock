//
//  APIModel.swift
//  NuriRock
//
//  Created by ungQ on 3/10/24.
//

import Foundation


struct Test: Decodable {
	let response: Response
}

struct Response: Decodable {
	let header: Header
	let body: Body
}

struct Header: Decodable {
	let resultCode: String
	let resultMsg: String
}

struct Body: Decodable {
	let items: ItemContainer?
	let numOfRows: Int
	let pageNo: Int
	let totalCount: Int

	enum CodingKeys: String, CodingKey {
		 case items, numOfRows, pageNo, totalCount
	 }


	init(from decoder: Decoder) throws {
		   let container = try decoder.container(keyedBy: CodingKeys.self)
		   numOfRows = try container.decode(Int.self, forKey: .numOfRows)
		   pageNo = try container.decode(Int.self, forKey: .pageNo)
		   totalCount = try container.decode(Int.self, forKey: .totalCount)

		   if let itemArray = try? container.decode(ItemContainer.self, forKey: .items) {
			   items = itemArray
		   } else {
			   items = nil
		   }
	   }

}


struct ItemContainer: Decodable {
	let item: [Item]?
}

struct Item: Decodable {
	let addr1: String
	let addr2: String
	let areacode: String

	let contentid: String
	let contenttypeid: String

	let firstimage: String
	let firstimage2: String

	let mapx: String?
	let mapy: String?

	let tel: String?
	let title: String
	let zipcode: String?
	let eventstartdate: String?
	let eventenddate: String?


	//	let cat1: String?
	//	let cat2: String?
	//	let cat3: String?

	//	let createdtime: String?
	//	let modifiedtime: String?

	//	let cpyrhtDivCd: String?

	//	let mlevel: String?

	//	let sigungucode: String?
}


