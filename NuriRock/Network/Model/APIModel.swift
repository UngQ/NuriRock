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
	let items: Items
	let numOfRows, pageNo, totalCount: Int
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
	let sigungucode, tel, title: String
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



