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


	let baseView = UIView()

	private var viewControllers: [UIViewController] = []


    override func viewDidLoad() {
        super.viewDidLoad()

		viewControllers.append(TotalResultViewController())
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

		bar.buttons.customize { (button) in
			button.tintColor = .systemGray4
			button.selectedTintColor = .black
			button.font = .systemFont(ofSize: 15)
			button.selectedFont = .boldSystemFont(ofSize: 15)
		}

		bar.indicator.weight = .custom(value: 2)
		bar.indicator.tintColor = .black
		bar.indicator.overscrollBehavior = .none

		addBar(bar, dataSource: self, at: .custom(view: baseView, layout: nil))

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
			let title = "test1"
			return TMBarItem(title: title)

		case 1:
			let title = "test2"
			return TMBarItem(title: title)

		default:
			return TMBarItem(title: "")
		}
	}
	

}
