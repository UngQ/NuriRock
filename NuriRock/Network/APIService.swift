//
//  APIService.swift
//  NuriRock
//
//  Created by ungQ on 3/10/24.
//

import Foundation
import Alamofire

class APIService {

	static let shared = APIService()

	private init() {}

	

	func request<T: Decodable>(type: T.Type, api: API, completionHandler: @escaping (T?, AFError?) -> Void) {


		AF.request(api.endPoint,
				   method: api.method,
				   parameters: api.parameter,
				   encoding: api.encoding).responseDecodable(of: T.self) { response in
			switch response.result {
			case .success(let success):
				print("네트워크 통신 성공!")
				completionHandler(success, nil)
			case .failure(let failure):
				print(failure)
				completionHandler(nil, failure)
			}
		}
	}
}
