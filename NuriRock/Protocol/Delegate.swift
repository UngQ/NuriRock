//
//  Delegate.swift
//  NuriRock
//
//  Created by ungQ on 3/10/24.
//

import Foundation

protocol TotalResultViewControllerDelegate: AnyObject {
	func addButtonClicked(_ segmentIndex: Int)
	
}


protocol TotalResultTableViewCellDelegate: AnyObject {
	func calendarButtonClicked()
}


protocol CalendarDateSelectionDelegate: AnyObject {
	func didSelectDate(date: Date)
}
