//
//  Observable.swift
//  NuriRock
//
//  Created by ungQ on 3/10/24.
//

import Foundation

class Observable<T> {

	private var closure: ((T) -> Void)?

	var value: T {
		didSet {
			closure?(value)
		}
	}

	init(_ value: T) {
		self.value = value
	}

	func bind(_ closure: @escaping (T) -> Void) {
		print(#function)
		closure(value)
		self.closure = closure
	}

	func apiBind(_ closure: @escaping (T) -> Void) {
		self.closure = closure
	}
}
