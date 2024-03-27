//
//  BookmarkViewModel.swift
//  NuriRock
//
//  Created by ungQ on 3/21/24.
//

import Foundation
import CoreLocation
import RealmSwift

final class BookmarkViewModel {

	let repository = BookmarkRepository()

	let inputMyLocation: Observable<CLLocationCoordinate2D?> = Observable(nil)

	let dataReloadTrigger: Observable<Void?> = Observable(nil)
	var outputBookmarks: Observable<[BookmarkRealmModel]?> = Observable(nil)

	lazy var list = repository.fetchBookmark()

	var totalBookmarks: Results<BookmarkRealmModel>!
	var filterBookmarks: [BookmarkRealmModel]?
	var observationToken: NotificationToken?

	init() {
		totalBookmarks = repository.realm?.objects(BookmarkRealmModel.self)
//		outputBookmarks.value = Array(totalBookmarks)

		print("여기서이닝ㅅ!?")

//		dataReloadTrigger.apiBind { _ in
//			self.outputBookmarks.value = self.repository.fetchBookmark()
//			print(self.outputBookmarks.value)
//			print("111")
//		}


	}

	func filterBookmarks(by city: CityCode) {
		// Assuming you have a way to filter your Realm objects by city or another property
		// This is a simplistic filter. Adjust according to your data model's actual structure.
		filterBookmarks = totalBookmarks.filter { $0.areacode == city.rawValue }
		outputBookmarks.value = filterBookmarks
	}



	
}
