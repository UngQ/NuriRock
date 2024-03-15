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



   init() {

	   inputKeyword.apiBind { keyword in
		   self.callAPIDataRequest(api: .searchKeyword(keyword: keyword, contentType: .tour, numOfRows: 10, pageNo: 1))
		   self.callAPIDataRequest(api: .searchKeyword(keyword: keyword, contentType: .culture, numOfRows: 10, pageNo: 1))
		   self.callAPIDataRequest(api: .searchKeyword(keyword: keyword, contentType: .festival, numOfRows: 10, pageNo: 1))
		   self.callAPIDataRequest(api: .searchKeyword(keyword: keyword, contentType: .hotel, numOfRows: 10, pageNo: 1))
		   self.callAPIDataRequest(api: .searchKeyword(keyword: keyword, contentType: .shopping, numOfRows: 10, pageNo: 1))
		   self.callAPIDataRequest(api: .searchKeyword(keyword: keyword, contentType: .restaurant, numOfRows: 10, pageNo: 1))
	   }

   }

	private func callAPIDataRequest(api: API) {
		APIService.shared.request(type: Test.self, api: api) { response, error in
			guard let response = response else { return }
			switch api {
			case .searchKeyword(_, let contentType, _, _):
				switch contentType {
				case .tour:
					self.outputTourData.value = response
					print(response)
				case .culture:
					self.outputCultureData.value = response
					print(response)
				case .festival:
					self.outputFestivalData.value = response
					print(response)
				case .hotel:
					self.outputHotelData.value = response
					print(response)
				case .shopping:
					self.outputShoppingData.value = response
					print(response)
				case .restaurant:
					self.outputRestaurantData.value = response
					print(response)
				}
			default:
				break
			}
		}
	}
}
