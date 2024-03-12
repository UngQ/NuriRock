//
//  TotalResultTableViewModel.swift
//  NuriRock
//
//  Created by ungQ on 3/10/24.
//

import Foundation
import Alamofire


class TotalResultTableViewModel {


	var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)

	var inputSegmentedValue: Observable<Int> = Observable(0)

	var inputContentId: Observable<String> = Observable("")
	var inputDate: Observable<Date> = Observable(Date())
	var inputAreaCode: Observable<String> = Observable("1") //초기값 서울(1)

	var outputTourData: Observable<Test?> = Observable(nil)
	var outputRestaurantData: Observable<Test?> = Observable(nil)
	var outputFestivalData: Observable<Test?> = Observable(nil)

	var onDateChanged: ((String) -> Void)?



	init() {

		inputAreaCode.bind { areaCode in
			self.callAPIDataRequest(api: .tour(areaCode: areaCode))
			self.callAPIDataRequest(api: .restaurant(areaCode: areaCode))
			self.callAPIDataRequest(api: .festival(areaCode: areaCode, date: self.inputDate.value.toYYYYMMDD()))
		}

		inputDate.apiBind { date in
			self.callAPIDataRequest(api: .festival(areaCode: self.inputAreaCode.value, date: date.toYYYYMMDD()))
			self.onDateChanged?(date.formatDateBasedOnLocale())
		}
	}

	private func callAPIDataRequest(api: API) {
		APIService.shared.request(type: Test.self, api: api) { response, error in
			switch api {
			case .tour:
				self.outputTourData.value = response
			case .restaurant:
				self.outputRestaurantData.value = response
			case .festival:
				self.outputFestivalData.value = response
			default:
				return
			}
		}
	}
}
