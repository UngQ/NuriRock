//
//  replacingHTMLBreaks.swift
//  NuriRock
//
//  Created by ungQ on 3/21/24.
//

import UIKit

extension String {

	func attributedStringFromHTML(withFont font: UIFont, color: UIColor) -> NSAttributedString? {
		// Convert UIColor to CSS-compatible format
		let cssColor = color.toCSSRGBA()

		// Prepare the HTML string with font and color styling
		let styledHTML = """
		<span style="font-family: '-apple-system', '\(font.fontName)'; font-size: \(font.pointSize)px; color: \(cssColor);">\(self)</span>
		"""

		// Replace <br> tags with line breaks
		let modifiedString = styledHTML.replacingOccurrences(of: "<br>", with: "\n", options: .caseInsensitive, range: nil)
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


// UIColor to CSS RGBA extension
extension UIColor {
	func toCSSRGBA() -> String {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0

		self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

		return "rgba(\(Int(red * 255)), \(Int(green * 255)), \(Int(blue * 255)), \(alpha))"
	}
}
