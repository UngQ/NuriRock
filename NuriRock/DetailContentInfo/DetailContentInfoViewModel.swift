//
//  DetailContentInfoViewModel.swift
//  NuriRock
//
//  Created by ungQ on 3/19/24.
//

import Foundation
import RealmSwift

final class DetailContentInfoViewModel {

	let repository = BookmarkRepository()
	var bookmarks: Results<BookmarkRealmModel>?
	var observationToken: NotificationToken? 

	var inputContentId: Observable<String?> = Observable(nil)


	var outputContentInfo: Observable<[Item]?> = Observable(nil)
	var outputItemList: Observable<[Item]?> = Observable(nil)


	var onProgress: Observable<Bool> = Observable(true)
	var noMoreRetryAttempts: Observable<Bool> = Observable(false)



	init() {
		bookmarks = repository.realm?.objects(BookmarkRealmModel.self)


		inputContentId.apiBind { id in
			self.callAPIDataRequest(api: .detailCommon(contentId: id ?? ""))
		}
	}


	private func callAPIDataRequest(api: API) {

		self.onProgress.value = true
		self.noMoreRetryAttempts.value = false

		APIService.shared.request(type: KorTour.self, api: api) { response, error in
			if let response = response {
				print(response)
				self.outputContentInfo.value = response.response.body.items?.item
				self.onProgress.value = false

			} else if error != nil {

				print("여기냐!!!여기냐!!!여기냐!!!여기냐!!!여기냐!!!여기냐!!!")
				self.onProgress.value = false
				self.noMoreRetryAttempts.value = true
			}

		}
	}


}
