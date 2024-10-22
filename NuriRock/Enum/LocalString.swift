//
//  LocalString.swift
//  NuriRock
//
//  Created by ungQ on 3/7/24.
//

import Foundation

enum Language: String {
	case Code
}

enum LocalString: String, CaseIterable {

	case LanguageSetting = "LanguageSetting"

	case seoul = "Seoul"
	case busan = "Busan"
	case daegu = "Daegu"
	case incheon = "Incheon"
	case gwangju = "Gwangju"
	case daejeon = "Daejeon"
	case ulsan = "Ulsan"
	case sejong = "Sejong"
	case gyeonggi = "Gyeonggi"
	case gangwon = "Gangwon"
	case chungbuk = "Chungbuk"
	case chungnam  = "Chungnam"
	case jeonbuk = "Jeonbuk"
	case jeonnam = "Jeonnam"
	case gyeongbuk = "Gyeongbuk"
	case gyeongnam = "Gyeongnam"
	case jeju = "Jeju"

	case total = "Total"
	case popularTouristAtraction = "PopularTouristAttraction"
	case popularRestaurant = "PopularRestaurant"
	case touristAttraction = "TouristAttraction"
	case culturalFacilities = "CulturalFacilities"
	case shopping = "Shopping"

	case events = "Events"
	case hotel = "Hotel"
	case restaurant = "Restaurant"
	case seemore = "Seemore"

	case tryLater = "TryLater"
	case serverError = "ServerError"
	case okay = "Okay"
	case withoutSpaces = "WithoutSpaces"
	case nomoreList = "NomoreList"

	case myLocation = "MyLocation"
	case noBookmarks = "NoBookmarks"

	case recentSearchHistory = "RecentSearchHistory"
	case clearAll = "ClearAll"
	case noHistory = "NoHistory"
	case awayLocation = "AwayLocation"
}
