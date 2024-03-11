//
//  CityCode.swift
//  NuriRock
//
//  Created by ungQ on 3/11/24.
//

import Foundation

enum CityCode: String, CaseIterable {
	case seoul = "1"
	case incheon = "2"
	case daejeon = "3"
	case daegu = "4"
	case gwangju = "5"
	case busan = "6"
	case ulsan = "7"
	case sejong = "8"
	case gyeonggi = "31"
	case gangwon = "32"
	case chungbuk = "33"
	case chungnam  = "34"
	case gyeongbuk = "35"
	case gyeongnam = "36"
	case jeonbuk = "37"
	case jeonnam = "38"
	case jeju = "39"

	var name: String {
		switch self {
		case .seoul: return "Seoul"
		case .busan: return "Busan"
		case .daegu: return "Daegu"
		case .incheon: return "Incheon"
		case .gwangju: return "Gwangju"
		case .daejeon: return "Daejeon"
		case .ulsan: return "Ulsan"
		case .sejong: return "Sejong"
		case .gyeonggi: return "Gyeonggi"
		case .gangwon: return "Gangwon"
		case .chungbuk: return "Chungbuk"
		case .chungnam: return "Chungnam"
		case .jeonbuk: return "Jeonbuk"
		case .jeonnam: return "Jeonnam"
		case .gyeongbuk: return "Gyeongbuk"
		case .gyeongnam: return "Gyeongnam"
		case .jeju: return "Jeju"
		}
	}
}
