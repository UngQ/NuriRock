//
//  KeywordHistoryRepository.swift
//  NuriRock
//
//  Created by ungQ on 3/13/24.
//

import Foundation
import RealmSwift

final class SearchHistoryRepository {

	private var realm: Realm?

	init() {
		do {
			realm = try Realm()
		} catch {
			print(error)
		}
	}

	func fetchHistory() -> [SearchedKeyword] {
		guard let realm = realm else { return [] }
		let result = realm.objects(SearchedKeyword.self).sorted(byKeyPath: "date", ascending: false)
		return Array(result)
	}



	func addKeyword(keyword: String) {

		guard let realm = realm else { return }


		print(realm.configuration.fileURL)

		let item = SearchedKeyword(keyword: keyword)

		do {
			try realm.write {
				realm.add(item, update: .modified)
			}
		} catch {
			print("add error")
		}


	}

	func deleteAllKeyword() {
		guard let realm = realm else { return }

		do {
			try realm.write {
				let allKeywords = realm.objects(SearchedKeyword.self)
				realm.delete(allKeywords)
			}
		} catch {
			print("deleteAll error")
		}
	}

}
