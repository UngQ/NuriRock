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
	var outputBookmarks: Observable<[Bookmark]?> = Observable(nil)

//	lazy var list = repository.fetchBookmark()

	var totalBookmarks: Results<BookmarkRealmModel>!
	var filterBookmarks: [Bookmark]?
	var observationToken: NotificationToken?

	var test: [Bookmark]?

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


//		let book = test?.filter { $0.areacode == city.rawValue }
//		viewModel.outputBookmarks.value = Array(viewModel.repository.fetchBookmark2()).map { $0.toStruct() }

		filterBookmarks = Array(totalBookmarks).map { $0.toStruct() }.filter { $0.areacode == city.rawValue }
		outputBookmarks.value = filterBookmarks
	}



	
}
