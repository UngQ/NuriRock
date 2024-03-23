//
//  DoubleFormatter.swift
//  NuriRock
//
//  Created by ungQ on 3/22/24.
//

import Foundation

func formatToDecimalString(_ number: Double) -> String {
	let formatter = NumberFormatter()
	formatter.numberStyle = .decimal
	formatter.maximumFractionDigits = 2
	formatter.minimumFractionDigits = 2
	formatter.locale = Locale(identifier: "en_US") // Use US locale to ensure point decimal

	return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
}
