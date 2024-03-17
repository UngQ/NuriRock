//
//  TotalResultViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/9/24.
//

import UIKit
import FSCalendar

protocol SeeMoreButtonClickedDelegate: AnyObject {
	func seeMoreButtonClicked(_ segmentIndex: Int)
}

protocol TotalResultViewControllerDelegate: AnyObject {
	func didScrollTableView(_ direction: ScrollDirection)
}

enum ScrollDirection {
	case up
	case down
}


final class TotalResultViewController: BaseViewController {

	let mainTableView = UITableView()

	let segmentedControl = UISegmentedControl()

	weak var seeMoreDelegate: SeeMoreButtonClickedDelegate?
	weak var scrollDelegate: TotalResultViewControllerDelegate?

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
		mainTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
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
		cell.noMoreaTryDelegate = self
		cell.selectionStyle = .none

		cell.seeMoreButtonAction = { [weak self] segmentIndex in
			self?.seeMoreDelegate?.seeMoreButtonClicked(segmentIndex)
		}

		if let index = selectedItemIndex {
			cell.configureWithIndex(index: index)
		}

		return cell
	}
}


extension TotalResultViewController: CalendarDateDelegate, FSCalendarDelegate {
	func calendarButtonClicked() {
		let vc = CalendarViewController()
		vc.calendar.delegate = self
		present(vc, animated: true)
	}

	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		let cell = mainTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! TotalResultTableViewCell

		cell.viewModel.inputDate.value = date
		cell.bottomCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)

		dismiss(animated: true)
	}
}

extension TotalResultViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)

		if translation.y > 0 {
			scrollDelegate?.didScrollTableView(.down)
		} else if translation.y < 0 {
			scrollDelegate?.didScrollTableView(.up)
		}
	}
}

extension TotalResultViewController: NoMoreTryDelegate {
	func noMoreAlert() {
		let alert = UIAlertController(title: "서버 통신 오류", message: "나중에 재시도 해주세요", preferredStyle: .alert)
		let okButton = UIAlertAction(title: "확인", style: .default)

		alert.addAction(okButton)

		present(alert, animated: true)
	}
	

}
