//
//  MapViewModel.swift
//  NuriRock
//
//  Created by ungQ on 3/24/24.
//

import Foundation
import MapKit

final class MapViewModel {


	var outputContentInfo: Observable<Item?> = Observable(nil)


	init() {

		print(#function)

		outputContentInfo.bind { _ in
			print(self.outputContentInfo.value?.mapx)
			print(self.outputContentInfo.value?.mapy)

		}

	}


}





