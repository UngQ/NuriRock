//
//  TotalViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/7/24.
//

import UIKit
import SnapKit

final class TotalViewController: BaseViewController {


	lazy var localCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionView())


	var containerView = UIView()
	let tabManVC = TabManViewController()

//	var resultTableView = UITableView()


	var test = true

    override func viewDidLoad() {
        super.viewDidLoad()


		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.placeholder = "입력해봐"
//		searchController.searchBar.scopeButtonTitles = ["전체", "관광지","쇼핑", "음식점"]

		searchController.searchBar.showsScopeBar = true
		searchController.searchBar.delegate = self

		self.navigationItem.searchController = searchController



		let logo = UIImage(resource: .title)
		let imageView = UIImageView(image: logo)


		imageView.contentMode = .scaleAspectFit
		navigationItem.titleView = imageView
		navigationController?.navigationBar.backgroundColor = .white


    }

	override func configureHierarchy() {

		view.addSubview(localCollectionView)
//		view.addSubview(resultTableView)
		view.addSubview(containerView)
		containerView.addSubview(tabManVC.view)

	}

	override func configureLayout() {


		localCollectionView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)

			make.height.equalTo(100)
		}


		containerView.snp.makeConstraints { make in
			make.top.equalTo(localCollectionView.snp.bottom)
			make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
		}

		tabManVC.view.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}

	override func configureView() {
//		if test {
//			localCollectionView.backgroundColor = .darkGray
//		} else {
//			localCollectionView.backgroundColor = .brown
//		}


		localCollectionView.backgroundColor = .white

		localCollectionView.delegate = self
		localCollectionView.dataSource = self
		localCollectionView.register(LocalCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

//		resultTableView.delegate = self
//		resultTableView.dataSource = self
//		resultTableView.rowHeight = 300
//
//
//		resultTableView.backgroundColor = .black
	}

	private func configureCollectionView() -> UICollectionViewFlowLayout {

		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 12

		let cellWidth = view.frame.width - (spacing * 2)

		layout.itemSize = CGSize(width: cellWidth / 6, height: cellWidth / 6 + 20)
		layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
		layout.minimumLineSpacing = spacing
		layout.minimumInteritemSpacing = 0


		layout.scrollDirection = .horizontal


		return layout

	}
}


//네비게이션 서치바
extension TotalViewController: UISearchBarDelegate {
//sear
}


// 시티 콜렉션뷰
extension TotalViewController: UICollectionViewDelegate, UICollectionViewDataSource {


	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 17
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LocalCollectionViewCell

		let imageNumber = indexPath.row

		cell.imageView.image = UIImage(imageLiteralResourceName: "\(imageNumber + 1)")
		cell.cityLabel.text = NSLocalizedString(LocalString.allCases[indexPath.row+1].rawValue, comment: "")
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("select")
	}


}


//
//
//extension TotalViewController: UITableViewDelegate, UITableViewDataSource {
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		5
//	}
//	
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = UITableViewCell()
//		cell.textLabel?.text = "test"
//		cell.textLabel?.textColor = .black
//
//		return cell
//	}
//	
//
//
//}
