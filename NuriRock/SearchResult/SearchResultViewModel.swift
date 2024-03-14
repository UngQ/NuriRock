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
	var outputCulturalFacilitiesData: Observable<Test?> = Observable(nil)
	var outputFestivalData: Observable<Test?> = Observable(nil)
	var outputHotelData: Observable<Test?> = Observable(nil)
	var outputShoppingData: Observable<Test?> = Observable(nil)
	var outputRestaurantData: Observable<Test?> = Observable(nil)



   init() {

	   inputKeyword.bind { areaCode in
//		   self.callAPIDataRequest(api: .tour(areaCode: areaCode))
//		   self.callAPIDataRequest(api: .restaurant(areaCode: areaCode))
//		   self.callAPIDataRequest(api: .festival(areaCode: areaCode, date: self.inputDate.value.toYYYYMMDD()))
	   }

   }

//   private func callAPIDataRequest(api: API) {
//	   APIService.shared.request(type: Test.self, api: api) { response, error in
//		   switch api {
//		   case .tour:
//			   self.outputTourData.value = response
//		   case .restaurant:
//			   self.outputRestaurantData.value = response
//		   case .festival:
//			   self.outputFestivalData.value = response
//		   default:
//			   return
//		   }
//	   }
//   }
}
