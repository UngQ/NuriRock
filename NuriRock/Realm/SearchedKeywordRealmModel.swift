//
//  RealmModel.swift
//  NuriRock
//
//  Created by ungQ on 3/13/24.
//

import Foundation
import RealmSwift


final class SearchedKeyword: Object {
	@Persisted var date: Date = Date()
	@Persisted(primaryKey: true) var keyword: String

	convenience init(keyword: String) {
		self.init()
		self.keyword = keyword
	}
}
