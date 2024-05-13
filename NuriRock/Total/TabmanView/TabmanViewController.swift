//
//  TabmanViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/9/24.
//

import UIKit
import Tabman
import Pageboy

final class TabManViewController: TabmanViewController {


	private let baseView = UIView()

	var localCollectionViewRow = 0

	var viewControllers: [UIViewController] = []

	private let totalResultVC = TotalResultViewController()

	private let tourVC = ContentViewController()
	private let cultureVC = ContentViewController()
	private let festivalVC = ContentViewController()
	private let hotelVC = ContentViewController()
	private let shoppingVC = ContentViewController()
	private let restaurantVC = ContentViewController()

    override func viewDidLoad() {
        super.viewDidLoad()


		totalResultVC.seeMoreDelegate = self


		tourVC.viewModel.inputContentType.value = ContentType.tour
		cultureVC.viewModel.inputContentType.value = ContentType.culture
		festivalVC.viewModel.inputContentType.value = ContentType.festival
		hotelVC.viewModel.inputContentType.value = ContentType.hotel
		shoppingVC.viewModel.inputContentType.value = ContentType.shopping
		restaurantVC.viewModel.inputContentType.value = ContentType.restaurant

		viewControllers.append(totalResultVC)
		viewControllers.append(tourVC)
		viewControllers.append(cultureVC)
		viewControllers.append(festivalVC)
		viewControllers.append(hotelVC)
		viewControllers.append(shoppingVC)
		viewControllers.append(restaurantVC)
		self.dataSource = self

		view.addSubview(baseView)
		baseView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
		}


		let bar = TMBar.ButtonBar()
//		bar.backgroundView.style = .clear
		bar.layout.transitionStyle = .snap

		bar.layout.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)


		bar.backgroundColor = .point

		bar.buttons.customize { (button) in
			button.tintColor = .systemGray
			button.selectedTintColor = .text
			button.font = .systemFont(ofSize: 12)
			button.selectedFont = .boldSystemFont(ofSize: 12)
		}

		bar.indicator.weight = .custom(value: 2)
		bar.indicator.tintColor = .text
		bar.indicator.overscrollBehavior = .compress
		bar.layout.alignment = .leading

		addBar(bar, dataSource: self, at: .custom(view: baseView, layout: nil))


    }

	func itemSelected(at index: Int) {
		if let totalResultVC = viewControllers.first as? TotalResultViewController {
			totalResultVC.selectedItemIndex = index
			
			totalResultVC.updateUIBasedOnSelection()
		}

		viewControllers.forEach {
			if let contentVC = $0 as? ContentViewController {
				contentVC.updateForCity(index: index)
			}
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
			let title = NSLocalizedString(LocalString.events.rawValue, comment: "")
			return TMBarItem(title: title)
		case 4:
			let title = NSLocalizedString(LocalString.hotel.rawValue, comment: "")
			return TMBarItem(title: title)
		case 5:
			let title = NSLocalizedString(LocalString.shopping.rawValue, comment: "")
			return TMBarItem(title: title)

		case 6:
			let title = NSLocalizedString(LocalString.restaurant.rawValue, comment: "")
			return TMBarItem(title: title)
		default:
			return TMBarItem(title: "")
		}
	}
	

}

extension TabManViewController: SeeMoreButtonClickedDelegate {
	func seeMoreButtonClicked(_ segmentIndex: Int) {
		let pageIndex = segmentIndex == 0 ? 1 : 6
		scrollToPage(.at(index: pageIndex), animated: true)
		
		let test = totalResultVC.mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TotalResultTableViewCell
//		tourVC. test.viewModel.outputTourData
	}
}
