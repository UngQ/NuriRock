//
//  SettingViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/20/24.
//

import UIKit

final class SettingViewController: BaseViewController {

	private enum Section {
		case main
	}

	private var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
	private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    override func viewDidLoad() {
        super.viewDidLoad()

		configureNavigationBar()
		configureDataSource()
		updateSnapshot()
    }

	override func configureHierarchy() {
		view.addSubview(collectionView)
	}

	override func configureLayout() {
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}

	override func configureView() {
		view.backgroundColor = .background
		collectionView.delegate = self
	}

	private func configureNavigationBar() {
		let logo = UIImage(resource: .title)
		let imageView = UIImageView(image: logo)

		imageView.contentMode = .scaleAspectFit

		let titleView = UIView()
		titleView.addSubview(imageView)

		imageView.snp.makeConstraints { make in
			make.centerX.centerY.equalTo(titleView)
			make.height.width.equalTo(44)
		}

		self.navigationItem.titleView = titleView

		titleView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: 44)

		navigationController?.navigationBar.backgroundColor = .background
	}

	private func configureDataSource() {

		let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { cell, indexPath, itemIdentifier in
			var content = UIListContentConfiguration.subtitleCell()
			content.text = "개인정보 처리방침"
			content.secondaryText = "Privacy Policy"
			content.textProperties.color = UIColor.background
			content.textProperties.font = .boldSystemFont(ofSize: 14)


			content.secondaryTextProperties.color = UIColor.background
			content.secondaryTextProperties.font = .systemFont(ofSize: 13)


			content.image = UIImage(systemName: "person.crop.circle")
			content.imageProperties.tintColor = .background
			cell.contentConfiguration = content

			var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
			backgroundConfig.backgroundColor = .point
			cell.backgroundConfiguration = backgroundConfig
		}


		dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
			return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
		}
	}

	private func updateSnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
		snapshot.appendSections([.main])

		snapshot.appendItems([1], toSection: .main)
		dataSource.apply(snapshot)
	}

	private func createLayout() -> UICollectionViewLayout {
		var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
		configuration.backgroundColor = .background
		configuration.showsSeparators = false



		let layout = UICollectionViewCompositionalLayout.list(using: configuration)


		return layout
	}


}


extension SettingViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let vc = PrivacyWebViewController()
		vc.url = "https://ungq.notion.site/NuriROCK-353045ac99f9484a8c7da4d14a8cb240"
		present(vc, animated: true)
	}
}
