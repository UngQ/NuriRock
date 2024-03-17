//
//  StringHighlight.swift
//  NuriRock
//
//  Created by ungQ on 3/16/24.
//

import UIKit

extension NSAttributedString {
	// 검색한 텍스트와 일치하는 부분만 다른 색상으로 강조하는 기능
	static func highlight(searchText: String, in fullText: String, highlightColor: UIColor, textColor: UIColor, font: UIFont) -> NSAttributedString {
		let attributedString = NSMutableAttributedString(string: fullText, attributes: [.font: font, .foregroundColor: textColor])

		let searchPattern = searchText
		let range = (fullText as NSString).range(of: searchPattern, options: .caseInsensitive)

		// 검색된 텍스트가 있으면 해당 범위의 색상 변경
		if range.location != NSNotFound {
			attributedString.addAttribute(.foregroundColor, value: highlightColor, range: range)
		}

		return attributedString
	}
}
