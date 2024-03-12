//
//  CalendarViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/12/24.
//

import UIKit
import FSCalendar

class CalendarViewController: BaseViewController {

	let calendar = FSCalendar()

    override func viewDidLoad() {
        super.viewDidLoad()

        
		if let sheetPresentationController = sheetPresentationController {
			sheetPresentationController.detents = [.medium()]
			sheetPresentationController.prefersGrabberVisible = true

		}
    }
    


	override func configureHierarchy() {
		view.addSubview(calendar)
	}

	override func configureLayout() {
		calendar.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(view.frame.height/2)

		}
	}

	override func configureView() {
		calendar.appearance.titleFont = .boldSystemFont(ofSize: 14)
		calendar.appearance.weekdayFont = .boldSystemFont(ofSize: 14)
		calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 14)
		calendar.appearance.subtitleFont = .boldSystemFont(ofSize: 14)


		calendar.appearance.weekdayTextColor = .black
		calendar.appearance.headerTitleColor = .black
		calendar.appearance.titleWeekendColor = .red
//		calendar.scrollDirection = .horizontal
//		calendar.appearance.eventDefaultColor = .green
		calendar.appearance.todayColor = .systemBlue
	}

	

}
