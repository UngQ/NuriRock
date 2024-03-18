//
//  ContentViewModel.swift
//  NuriRock
//
//  Created by ungQ on 3/16/24.
//

import Foundation

class ContentViewModel {

	var inputContentType: Observable<ContentType> = Observable(.tour)
	var inputAreaCode: Observable<CityCode> = Observable(.seoul)

	var lastPageNo: Observable<Int> = Observable(0)
	var inputPageNo: Observable<Int> = Observable(1)



	var outputContentData: Observable<Test?> = Observable(nil)
	var outputItemList: Observable<[Item]?> = Observable(nil)


	var onProgress: Observable<Bool> = Observable(true)
	var noMoreRetryAttempts: Observable<Bool> = Observable(false)

	
	var isAreaChange = true

	init() {

		inputContentType.apiBind { _ in
			self.callAPIDataRequest(api: .areaBasedList(contentType: self.inputContentType.value, areaCode: self.inputAreaCode.value, numOfRows: 20, pageNo: 1))
		}

		inputAreaCode.apiBind { _ in
			self.callAPIDataRequest(api: .areaBasedList(contentType: self.inputContentType.value, areaCode: self.inputAreaCode.value, numOfRows: 20, pageNo: 1))
		}


		inputPageNo.apiBind { _ in
			if !self.isAreaChange {
				self.callAPIDataRequest(api: .areaBasedList(contentType: self.inputContentType.value, areaCode: self.inputAreaCode.value, numOfRows: 20, pageNo: self.inputPageNo.value))
			}
		}
	}


	private func callAPIDataRequest(api: API) {

		self.onProgress.value = true
		self.noMoreRetryAttempts.value = false

		if inputPageNo.value != lastPageNo.value {

			APIService.shared.request(type: Test.self, api: api) { response, error in
				if let response = response {
					let totalCount = response.response.body.totalCount
					let totalPages = totalCount / 10 + (totalCount % 10 > 0 ? 1 : 0)
					self.lastPageNo.value = totalPages

					if self.inputPageNo.value == 1 {


						self.outputContentData.value = response
						self.outputItemList.value = response.response.body.items?.item

						self.onProgress.value = false
					} else {

						self.outputItemList.value?.append(contentsOf: response.response.body.items?.item ?? [])
					}
				} else if error != nil {

					print("여기냐!!!여기냐!!!여기냐!!!여기냐!!!여기냐!!!여기냐!!!")
					self.onProgress.value = false
					self.noMoreRetryAttempts.value = true
				}

			}
		}
	}
}
