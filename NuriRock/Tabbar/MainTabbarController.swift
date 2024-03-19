//
//  TabbarController.swift
//  NuriRock
//
//  Created by ungQ on 3/13/24.
//

import UIKit

class MainTabbarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white

		self.tabBar.tintColor = .systemBlue
		self.tabBar.barTintColor = .black
		self.tabBar.isTranslucent = false
		self.tabBar.unselectedItemTintColor = .black



		let firstVC = UINavigationController(rootViewController: TotalViewController())

		firstVC.tabBarItem.title = "메인"
		firstVC.tabBarItem.image = UIImage(systemName: "house.fill")

		let secondVC = UINavigationController(rootViewController: TotalViewController())

		secondVC.tabBarItem.title = "위시"
		secondVC.tabBarItem.image = UIImage(systemName: "heart")


		let thirdVC = UINavigationController(rootViewController: TotalViewController())

		thirdVC.tabBarItem.title = "위시"
		thirdVC.tabBarItem.image = UIImage(systemName: "heart")



//		let vc = UINavigationController(rootViewController: firstVC)


		viewControllers = [firstVC, secondVC, thirdVC]
	}


	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/

}
