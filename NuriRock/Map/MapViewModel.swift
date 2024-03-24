//
//  MapViewModel.swift
//  NuriRock
//
//  Created by ungQ on 3/24/24.
//

import Foundation
import MapKit

class MapViewModel {


	let repository = BookmarkRepository()

	let inputMyLocation: Observable<CLLocationCoordinate2D?> = Observable(nil)

	let dataReloadTrigger: Observable<Void?> = Observable(nil)
	var outputBookmarks: Observable<[BookmarkRealmModel]?> = Observable(nil)

	lazy var list = repository.fetchBookmark()

	init() {

		print(#function)

		dataReloadTrigger.apiBind { _ in
			self.outputBookmarks.value = self.repository.fetchBookmark()
			print(self.outputBookmarks.value)
			print("111")
		}


	}




}

