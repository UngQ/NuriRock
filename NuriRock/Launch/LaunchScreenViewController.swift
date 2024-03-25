//
//  LaunchScreenViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/22/24.
//

import UIKit

final class LaunchScreenViewController: UIViewController {

	private var imageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .point

		imageView = UIImageView(frame: CGRect(x: self.view.center.x - 100, y: self.view.center.y - 100, width: 200, height: 200))
		imageView.image = UIImage(resource: .title) // Replace with your image name
		imageView.contentMode = .scaleAspectFit
		self.view.addSubview(imageView)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		animateImageView()

		// Transition after 3 seconds
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
			self.transitionToMainViewController()
		}
	}

	private func animateImageView() {
		// Determine the final position y-coordinate near the navigation bar
		guard let navHeight = navigationController?.navigationBar.frame.size.height else { return }
		let targetY: CGFloat = getStatusBarHeight()

		UIView.animate(withDuration: 1.5) {
			// Change the size to 40x40 and move it up
			self.imageView.frame = CGRect(x: self.view.center.x - 22,  // Adjust x to keep it centered
										  y: targetY,                 // Move it up toward the navigation bar
										  width: 44,                  // New width
										  height: 44)                 // New height
		}
	}

	private func getStatusBarHeight() -> CGFloat {
		var statusBarHeight: CGFloat = 0


		if #available(iOS 13.0, *), let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
			statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
		}

		print(statusBarHeight)
		return statusBarHeight
	}

	private func transitionToMainViewController() {
		let mainViewController = MainTabbarController() // Initialize your main view controller
		mainViewController.modalPresentationStyle = .fullScreen
		mainViewController.modalTransitionStyle = .coverVertical
		self.present(mainViewController, animated: false)
	}
}

