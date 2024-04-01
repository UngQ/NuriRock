//
//  BookmarkRepository.swift
//  NuriRock
//
//  Created by ungQ on 3/20/24.
//

import Foundation
import RealmSwift

//final class BookmarkRepository {
//
//	private var realm: Realm?
//
//	init() {
//		do {
//			realm = try Realm()
//		} catch {
//			print(error)
//		}
//	}
//
//	func fetchHistory() -> [BookmarkRealmModel] {
//		guard let realm = realm else { return [] }
//		let result = realm.objects(BookmarkRealmModel.self).sorted(byKeyPath: "date", ascending: false)
//		return Array(result)
//	}
//
//
//
//
//
//	func deleteAllKeyword() {
//		guard let realm = realm else { return }
//
//		do {
//			try realm.write {
//				let allKeywords = realm.objects(SearchedKeyword.self)
//				realm.delete(allKeywords)
//			}
//		} catch {
//			print("deleteAll error")
//		}
//	}
//
//	func isInBookmark(contentId: String) -> Bool {
//		guard let realm = realm else { return  false }
//
//
//		return realm.object(ofType: BookmarkRealmModel.self, forPrimaryKey: contentId) != nil
//	}
//
//}




final class BookmarkRepository {

	var realm: Realm?
	


	init() {
		do {
			realm = try Realm()
		} catch {
			print(error)
		}
	}

	func fetchBookmark2() -> Results<BookmarkRealmModel> {
		let result = realm!.objects(BookmarkRealmModel.self) //.sorted(byKeyPath: "date", ascending: false)
		return result
	}


	func fetchBookmark() -> [BookmarkRealmModel] {
		guard let realm = realm else { return [] }
		let result = realm.objects(BookmarkRealmModel.self) //.sorted(byKeyPath: "date", ascending: false)
		return Array(result)
	}

	func addBookmark(id: String, completionHandler: @escaping ((Bool) -> Void))  {
		
		guard let realm = realm else { return }
		
		
		print(realm.configuration.fileURL)
		var item = BookmarkRealmModel()
		
		APIService.shared.request(type: KorTour.self, api: .detailCommon(contentId: id)) { response, error in
			if let response = response {
				guard let data = response.response.body.items?.item?[0] else {
					completionHandler(false)
					return
				}
				
				item = BookmarkRealmModel(contentid: data.contentid,
										  contenttypeid: data.contenttypeid,
										  title: data.title,
										  addr1: data.addr1,
										  addr2: data.addr2,
										  areacode: data.areacode ?? "",
										  firstimage: data.firstimage,
										  overview: data.overview ?? "",
										  mapx: data.mapx ?? "",
										  mapy: data.mapy ?? "")
				
				do {
					try realm.write {
						realm.add(item, update: .modified)
					}
					completionHandler(true)
				} catch {
					print("add error")
					completionHandler(false)
				}
				
			}
		}
	}


	func addBookmarkInDetailView(data: Item) {

		guard let realm = realm else { return }


		print(realm.configuration.fileURL)

		let item = BookmarkRealmModel(contentid: data.contentid,
									  contenttypeid: data.contenttypeid,
									  title: data.title,
									  addr1: data.addr1,
									  addr2: data.addr2,
									  areacode: data.areacode ?? "",
									  firstimage: data.firstimage,
									  overview: data.overview ?? "",
									  mapx: data.mapx ?? "",
									  mapy: data.mapy ?? "")

		do {
			try realm.write {
				realm.add(item, update: .modified)
			}
		} catch {
			print("add error")
		}

	}

	func deleteBookmark(data: Item) {

		guard let realm = realm else { return }



		guard let object = realm.object(ofType: BookmarkRealmModel.self, forPrimaryKey: data.contentid) else { return }

		do {
			try realm.write {
				realm.delete(object)
			}
		} catch {
			print("delete Error")
		}

	}

	func deleteBookmarkInBookmarkView(data: BookmarkRealmModel) {

		guard let realm = realm else { return }



		guard let object = realm.object(ofType: BookmarkRealmModel.self, forPrimaryKey: data.contentid) else { return }

		do {
			try realm.write {
				realm.delete(object)
			}
		} catch {
			print("delete Error")
		}

	}

	func isBookmarked(contentId: String) -> Bool {
		guard let realm = realm else { return  false }


		return realm.object(ofType: BookmarkRealmModel.self, forPrimaryKey: contentId) != nil
	}


	func observeBookmarks(completion: @escaping ([BookmarkRealmModel]) -> Void) -> NotificationToken {
		guard let realm = realm else { fatalError("Realm not initialized") }

		let bookmarks = realm.objects(BookmarkRealmModel.self)
		return bookmarks.observe { changes in
			switch changes {
			case .initial(let results), .update(let results, deletions: _, insertions: _, modifications: _):
				// Call completion with current bookmarks
				completion(Array(results))
			case .error(let error):
				fatalError("Realm observation error: \(error)")
			}
		}
	}

}
