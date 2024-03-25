//
//  TabbarController.swift
//  NuriRock
//
//  Created by ungQ on 3/13/24.
//

import UIKit

final class MainTabbarController: UITabBarController {



	private let firstVC = UINavigationController(rootViewController: TotalViewController())
	private let secondVC = UINavigationController(rootViewController: BookmarkViewController())
	private let thirdVC = UINavigationController(rootViewController: SettingViewController())


	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .background

		self.tabBar.tintColor = .point
		self.tabBar.barTintColor = .background
		self.tabBar.isTranslucent = false
		self.tabBar.unselectedItemTintColor = .text
		self.tabBar.backgroundColor = .background

		firstVC.tabBarItem.title = ""
		firstVC.tabBarItem.image = UIImage(systemName: "house.fill")

		secondVC.tabBarItem.title = ""
		secondVC.tabBarItem.image = UIImage(systemName: "bookmark.fill")

		thirdVC.tabBarItem.title = ""
		thirdVC.tabBarItem.image = UIImage(systemName: "gearshape.fill")

		viewControllers = [firstVC, secondVC, thirdVC]

	}
}
