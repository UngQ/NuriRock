//
//  ContentViewModel.swift
//  NuriRock
//
//  Created by ungQ on 3/16/24.
//

import Foundation

class ContentViewModel {

	var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)

	var inputContentType: Observable<ContentType> = Observable(.tour)
	var inputAreaCode: Observable<CityCode> = Observable(.seoul)
	var inputKeyword: Observable<String> = Observable("")
	var intputContentTypeAtKeyword: Observable<ContentType> = Observable(.tour)

	var lastPageNo: Observable<Int> = Observable(0)
	var inputPageNo: Observable<Int> = Observable(1)



	var outputContentData: Observable<Test?> = Observable(nil)
	var outputItemList: Observable<[Item]?> = Observable(nil)


	var onProgress: Observable<Bool> = Observable(true)
	var noMoreRetryAttempts: Observable<Bool> = Observable(false)
	var isLastPage: Observable<Bool> = Observable(false)


	var isAreaOrKeyword = true // true일 경우 Area기반 검색, false일 경우 Keyword기반 검색
	var isAreaChange = true

	init() {

//		inputContentType.apiBind { _ in
//			self.callAPIDataRequest(api: .areaBasedList(contentType: self.inputContentType.value, areaCode: self.inputAreaCode.value, numOfRows: 20, pageNo: 1))
//		}
//
//		inputAreaCode.apiBind { _ in
//			self.callAPIDataRequest(api: .areaBasedList(contentType: self.inputContentType.value, areaCode: self.inputAreaCode.value, numOfRows: 20, pageNo: 1))
//		}

		inputViewWillAppearTrigger.apiBind { _ in
			if self.isAreaOrKeyword {
				self.callAPIDataRequest(api: .areaBasedList(contentType: self.inputContentType.value, areaCode: self.inputAreaCode.value, numOfRows: 20, pageNo: 1))
			} else {
				self.callAPIDataRequest(api: .searchKeyword(keyword: self.inputKeyword.value, contentType: self.intputContentTypeAtKeyword.value, numOfRows: 20, pageNo: 1))
			}
		}

//		inputKeyword.apiBind { _ in
//			self.callAPIDataRequest(api: .searchKeyword(keyword: self.inputKeyword.value, contentType: self.intputContentTypeAtKeyword.value, numOfRows: 20, pageNo: 1))
//		}


		inputPageNo.apiBind { _ in
			if self.inputPageNo.value != 1 {
				if !self.isAreaChange {
					self.callAPIDataRequest(api: .areaBasedList(contentType: self.inputContentType.value, areaCode: self.inputAreaCode.value, numOfRows: 20, pageNo: self.inputPageNo.value))
				} else {
					self.callAPIDataRequest(api: .searchKeyword(keyword: self.inputKeyword.value, contentType: self.intputContentTypeAtKeyword.value, numOfRows: 20, pageNo: self.inputPageNo.value))
				}
			}
		}
	}


	private func callAPIDataRequest(api: API) {

		self.onProgress.value = true
		self.noMoreRetryAttempts.value = false

		if inputPageNo.value != lastPageNo.value {

			APIService.shared.request(type: Test.self, api: api) { response, error in
				if let response = response {

					if self.inputPageNo.value == 1 {
						self.outputContentData.value = response
						self.outputItemList.value = response.response.body.items?.item

						self.onProgress.value = false
					} else {

						if !(response.response.body.items?.item?.isEmpty ?? true) {
							print("하하")
							self.outputItemList.value?.append(contentsOf: response.response.body.items?.item ?? [])
							self.onProgress.value = false
						} else {
							print("혹시")
							self.onProgress.value = false
							self.isLastPage.value = true
						}
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
