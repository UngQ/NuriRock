//
//  BookmarkRealmModel.swift
//  NuriRock
//
//  Created by ungQ on 3/20/24.
//

import Foundation
import RealmSwift


final class BookmarkRealmModel: Object {
	@Persisted(primaryKey: true) var contentid: String
	@Persisted var contenttypeid: String
	@Persisted var title: String
	@Persisted var addr1: String
	@Persisted var addr2: String
	@Persisted var areacode: String
	@Persisted var firstimage: String
	@Persisted var overview: String
	@Persisted var mapx: String
	@Persisted var mapy: String

	convenience init(contentid: String, contenttypeid: String, title: String, addr1: String, addr2: String, areacode: String, firstimage: String, overview: String, mapx: String, mapy: String) {
		self.init()
		self.contentid = contentid
		self.contenttypeid = contenttypeid
		self.title = title
		self.addr1 = addr1
		self.addr2 = addr2
		self.areacode = areacode
		self.firstimage = firstimage
		self.overview = overview
		self.mapx = mapx
		self.mapy = mapy
	}


}
