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

	var inputContentType: Observable<String> = Observable(ContentType.tour.rawValue)

	var outputData: Observable<Test?> = Observable(nil)



	init() {


//		inputViewDidLoadTrigger.bind { _ in
//			self.callRequest(contentType: self.contentType)
//		}

		inputContentType.bind { contentType in
			self.callRequest(contentType: contentType)
		}


	}



	private func callRequest(contentType: String) {
		APIService.shared.request(type: Test.self, api: API.local(contentType: contentType)) { response, error in
			self.outputData.value = response
		}
	}

}
