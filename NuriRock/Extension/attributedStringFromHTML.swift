//
//  replacingHTMLBreaks.swift
//  NuriRock
//
//  Created by ungQ on 3/21/24.
//

import UIKit

extension String {
	func attributedStringFromHTML() -> NSAttributedString? {
		let modifiedString = self.replacingOccurrences(of: "<br>", with: "\n", options: .caseInsensitive, range: nil)
		guard let data = modifiedString.data(using: .utf8) else { return nil }

		let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
			.documentType: NSAttributedString.DocumentType.html,
			.characterEncoding: String.Encoding.utf8.rawValue
		]

		do {
			return try NSAttributedString(data: data, options: options, documentAttributes: nil)
		} catch {
			print("Error converting HTML string to attributed string: \(error)")
			return nil
		}
	}
}
