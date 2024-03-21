//
//  TotalResultTableViewModel.swift
//  NuriRock
//
//  Created by ungQ on 3/10/24.
//

import Foundation
import Alamofire


final class TotalResultTableViewModel {

	let repository = BookmarkRepository()

	var currentData: [Item] = []


	var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)

	var inputSegmentedValue: Observable<Int> = Observable(0)

	var inputContentId: Observable<String> = Observable("")
	var inputDate: Observable<Date> = Observable(Date())
	var inputAreaCode: Observable<CityCode> = Observable(.seoul) //초기값 서울(1)

	var outputTourData: Observable<Test?> = Observable(nil)
	var outputCultureData: Observable<Test?> = Observable(nil)
	var outputFestivalData: Observable<Test?> = Observable(nil)
	var outputHotelData: Observable<Test?> = Observable(nil)
	var outputShoppingData: Observable<Test?> = Observable(nil)
	var outputRestaurantData: Observable<Test?> = Observable(nil)

	var onProgress: Observable<Bool> = Observable(true)
	var noMoreRetryAttempts: Observable<Bool> = Observable(false)

	var isBookmarkButtonClicked: Observable<Bool> = Observable(false)


	var onDateChanged: ((String) -> Void)?

	var mainAPICallNumber = 3


	init() {

		inputAreaCode.bind { areaCode in
			print(areaCode.rawValue)
			self.mainAPICallNumber = 3
			self.callAPIDataRequest(api: .areaBasedList(contentType: .tour, areaCode: areaCode, numOfRows: 10, pageNo: 1))
			self.callAPIDataRequest(api: .areaBasedList(contentType: .restaurant, areaCode: areaCode, numOfRows: 10, pageNo: 1))
			self.callAPIDataRequest(api: .searchFestival(eventStartDate: self.inputDate.value.toYYYYMMDD(), areaCode: areaCode, numOfRows: 10, pageNo: 1))

		}

		inputDate.apiBind { date in
			self.mainAPICallNumber = 1
			self.callAPIDataRequest(api: .searchFestival(eventStartDate: date.toYYYYMMDD(), areaCode: self.inputAreaCode.value, numOfRows: 10, pageNo: 1))
			self.onDateChanged?(date.formatDateBasedOnLocale())
		}
	}

	private func callAPIDataRequest(api: API) {
		self.onProgress.value = true
		self.noMoreRetryAttempts.value = false

		APIService.shared.request(type: Test.self, api: api) { response, error in
			if let response = response {
				self.mainAPICallNumber -= 1
				switch api {
				case .areaBasedList(let contentType, _, _, _):
					switch contentType {
					case .tour:
						self.outputTourData.value = response
						self.onProgress.value = false

					case .culture:
						self.outputCultureData.value = response
						self.onProgress.value = false
					case .festival: //축제 정보는 지역 + 오늘날짜 기반으로만 정보 받아와서 .areaBasedList에서 사용 X
						break
					case .hotel:
						self.outputHotelData.value = response
						self.onProgress.value = false
					case .shopping:
						self.outputShoppingData.value = response
						self.onProgress.value = false
					case .restaurant:
						self.outputRestaurantData.value = response
						self.onProgress.value = false
					}
				case .searchFestival:
					self.outputFestivalData.value = response
					self.onProgress.value = false


				default:
					break
				}
			} else if let error = error {
				self.noMoreRetryAttempts.value = true
				self.onProgress.value = false
			
			}
		}
	}
}
