//
//  BookmarkViewModel.swift
//  NuriRock
//
//  Created by ungQ on 3/21/24.
//

import Foundation


class BookmarkViewModel {

	let repository = BookmarkRepository()

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
