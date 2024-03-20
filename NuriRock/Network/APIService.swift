//
//  APIService.swift
//  NuriRock
//
//  Created by ungQ on 3/10/24.
//

import Foundation
import Alamofire

final class APIService {

	static let shared = APIService()

	private init() {}

	

	func request<T: Decodable>(type: T.Type, api: API, retryCount: Int = 2, completionHandler: @escaping (T?, AFError?) -> Void) {

		AF.request(api.endPoint,
				   method: api.method,
				   parameters: api.parameter,
				   encoding: api.encoding).responseDecodable(of: T.self) { response in
			switch response.result {
			case .success(let success):
				print("네트워크 통신 성공!")
				completionHandler(success, nil)
			case .failure(let failure):
				print("에러")
				if retryCount > 0 {

					DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
						self.request(type: type, api: api, retryCount: retryCount - 1, completionHandler: completionHandler)
						print(retryCount)
					}
				} else {
					print("여기로오나")
					completionHandler(nil, failure)
				}

			}
		}
	}
}



