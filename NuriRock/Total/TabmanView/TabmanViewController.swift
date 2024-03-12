//
//  TabmanViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/9/24.
//

import UIKit
import Tabman
import Pageboy
import FSCalendar

final class TabManViewController: TabmanViewController {


	let baseView = UIView()

	private var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

		let totalResultVC = TotalResultViewController()
		 totalResultVC.delegate = self

		let searchVC = SearchViewController()


		viewControllers.append(totalResultVC)
		viewControllers.append(searchVC)
		viewControllers.append(SearchViewController())
		viewControllers.append(SearchViewController())
		viewControllers.append(SearchViewController())
		viewControllers.append(SearchViewController())
		self.dataSource = self

		view.addSubview(baseView)
		baseView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
		}


		let bar = TMBar.ButtonBar()
//		bar.backgroundView.style = .clear
		bar.layout.transitionStyle = .snap

		bar.layout.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

		bar.backgroundColor = .systemBlue

		bar.buttons.customize { (button) in
			button.tintColor = .systemGray
			button.selectedTintColor = .black
			button.font = .systemFont(ofSize: 12)
			button.selectedFont = .boldSystemFont(ofSize: 12)
		}

		bar.indicator.weight = .custom(value: 2)
		bar.indicator.tintColor = .black
		bar.indicator.overscrollBehavior = .none

		addBar(bar, dataSource: self, at: .custom(view: baseView, layout: nil))


    }

	func itemSelected(at index: Int) {
		if let totalResultVC = viewControllers.first as? TotalResultViewController {
			totalResultVC.selectedItemIndex = index
			totalResultVC.updateUIBasedOnSelection()
		}
	}


}


extension TabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
	func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
		viewControllers.count
	}
	
	func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
		viewControllers[index]
	}
	
	func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
		nil
	}
	
	func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
		switch index {
		case 0:
			let title = NSLocalizedString(LocalString.total.rawValue, comment: "")
			return TMBarItem(title: title)

		case 1:
			let title = NSLocalizedString(LocalString.touristAttraction.rawValue, comment: "")
			return TMBarItem(title: title)

		case 2:
			let title = NSLocalizedString(LocalString.culturalFacilities.rawValue, comment: "")
			return TMBarItem(title: title)

		case 3:
			let title = "숙박"
			return TMBarItem(title: title)
		case 4:
			let title = NSLocalizedString(LocalString.shopping.rawValue, comment: "")
			return TMBarItem(title: title)
		case 5:
			let title = "맛집"
			return TMBarItem(title: title)

		default:
			return TMBarItem(title: "")
		}
	}
	

}

extension TabManViewController: TotalResultViewControllerDelegate {
	func addButtonClicked(_ segmentIndex: Int) {
		let pageIndex = segmentIndex == 0 ? 1 : 5
		scrollToPage(.at(index: pageIndex), animated: true)


	}
}


