//
//  TotalResultViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/9/24.
//

import UIKit
import FSCalendar

final class TotalResultViewController: BaseViewController {

	let mainTableView = UITableView()

	let segmentedControl = UISegmentedControl()

	weak var delegate: TotalResultViewControllerDelegate?
	var selectedItemIndex: Int?


    override func viewDidLoad() {
        super.viewDidLoad()


    }

	override func configureHierarchy() {
		view.addSubview(mainTableView)
	}

	override func configureLayout() {
		mainTableView.snp.makeConstraints { make in

			make.top.equalTo(view.safeAreaLayoutGuide).offset(44) // 탭바높이 44
			make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
		}
	}

	override func configureView() {
		mainTableView.backgroundColor = .white

		mainTableView.delegate = self
		mainTableView.dataSource = self
		mainTableView.rowHeight = 1000
		mainTableView.register(TotalResultTableViewCell.self, forCellReuseIdentifier: "TotalResultTableViewCell")
	}

	func updateUIBasedOnSelection() {
		mainTableView.reloadData()
	}

}

extension TotalResultViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TotalResultTableViewCell", for: indexPath) as! TotalResultTableViewCell
		cell.delegate = self
		cell.selectionStyle = .none
		cell.addButtonAction = { [weak self] segmentIndex in
			self?.delegate?.addButtonClicked(segmentIndex)
		}

		if let index = selectedItemIndex {
			cell.configureWithIndex(index: index)
		}

		return cell
	}
}


extension TotalResultViewController: TotalResultTableViewCellDelegate, FSCalendarDelegate {
	func calendarButtonClicked() {
		let vc = CalendarViewController()
		vc.calendar.delegate = self
		present(vc, animated: true)
	}

	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		let cell = mainTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! TotalResultTableViewCell

		cell.viewModel.inputDate.value = date

		print(date.formatDateBasedOnLocale())

		dismiss(animated: true)
	}
}
