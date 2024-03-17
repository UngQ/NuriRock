//
//  SearchResultViewModel.swift
//  NuriRock
//
//  Created by ungQ on 3/14/24.
//

import Foundation

class SearchResultViewModel {

	var inputKeyword: Observable<String> = Observable("")

	var outputTourData: Observable<Test?> = Observable(nil)
	var outputCultureData: Observable<Test?> = Observable(nil)
	var outputFestivalData: Observable<Test?> = Observable(nil)
	var outputHotelData: Observable<Test?> = Observable(nil)
	var outputShoppingData: Observable<Test?> = Observable(nil)
	var outputRestaurantData: Observable<Test?> = Observable(nil)

	var onProgress: Observable<Bool> = Observable(true)
	var noMoreRetryAttempts: Observable<Bool> = Observable(false)



	init() {

		inputKeyword.apiBind { keyword in
			//			self.callAPIDataRequest(api: .areaBasedList(contentType: .tour, areaCode: .busan, numOfRows: 3, pageNo: 1))
			//			self.callAPIDataRequest(api: .areaBasedList(contentType: .tour, areaCode: .chungbuk, numOfRows: 3, pageNo: 1))
			//			self.callAPIDataRequest(api: .areaBasedList(contentType: .tour, areaCode: .chungnam, numOfRows: 3, pageNo: 1))
			//			self.callAPIDataRequest(api: .areaBasedList(contentType: .tour, areaCode: .gangwon, numOfRows: 3, pageNo: 1))
			//
			//			self.callAPIDataRequest(api: .areaBasedList(contentType: .tour, areaCode: .daegu, numOfRows: 3, pageNo: 1))
			//			self.callAPIDataRequest(api: .areaBasedList(contentType: .tour, areaCode: .daejeon, numOfRows: 3, pageNo: 1))

			self.callAPIDataRequest(api: .searchKeyword(keyword: keyword, contentType: .tour, numOfRows: 3, pageNo: 1))
			self.callAPIDataRequest(api: .searchKeyword(keyword: keyword, contentType: .culture, numOfRows: 3, pageNo: 1))
			self.callAPIDataRequest(api: .searchKeyword(keyword: keyword, contentType: .festival, numOfRows: 3, pageNo: 1))
			self.callAPIDataRequest(api: .searchKeyword(keyword: keyword, contentType: .hotel, numOfRows: 3, pageNo: 1))
			self.callAPIDataRequest(api: .searchKeyword(keyword: keyword, contentType: .shopping, numOfRows: 3, pageNo: 1))
			self.callAPIDataRequest(api: .searchKeyword(keyword: keyword, contentType: .restaurant, numOfRows: 3, pageNo: 1))
		}

	}

	private func callAPIDataRequest(api: API) {

		self.onProgress.value = true
		self.noMoreRetryAttempts.value = false


		APIService.shared.request(type: Test.self, api: api) { response, error in
			if let response = response {
				switch api {
				case .searchKeyword(_, let contentType, _, _):
					switch contentType {
					case .tour:
						self.outputTourData.value = response
						self.onProgress.value = false
						print(response)
					case .culture:
						self.outputCultureData.value = response
						self.onProgress.value = false
						print(response)
					case .festival:
						self.outputFestivalData.value = response
						self.onProgress.value = false
						print(response)
					case .hotel:
						self.outputHotelData.value = response
						self.onProgress.value = false
						print(response)
					case .shopping:
						self.outputShoppingData.value = response
						self.onProgress.value = false
						print(response)
					case .restaurant:
						self.outputRestaurantData.value = response
						self.onProgress.value = false
						print(response)
					}
				default:
					break
				}
			} else if error != nil {

				print("여기냐!!!여기냐!!!여기냐!!!여기냐!!!여기냐!!!여기냐!!!")
				self.onProgress.value = false
				self.noMoreRetryAttempts.value = true


			}
		}
	}
}
