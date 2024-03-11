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
	var selectedCellIndex = 0

	var containerView = UIView()
	let tabManVC = TabManViewController()

//	var resultTableView = UITableView()


	var test = true

	override func viewWillAppear(_ animated: Bool) {
//		navigationController?.navigationBar.prefersLargeTitles = true
//		 navigationItem.searchController = searchController
//		 navigationItem.hidesSearchBarWhenScrolling = false
//		 definesPresentationContext = true
	}

    override func viewDidLoad() {
        super.viewDidLoad()


		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.placeholder = "입력해봐"
//		searchController.searchBar.scopeButtonTitles = ["전체", "관광지","쇼핑", "음식점"]

		searchController.searchBar.showsScopeBar = true
		searchController.searchBar.delegate = self

		self.navigationItem.searchController = searchController

		navigationItem.hidesSearchBarWhenScrolling = false

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
		containerView.addSubview(SearchViewController().view)
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

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		print(#function)
	}



	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		print(#function)
		tabManVC.view.isHidden = true
		localCollectionView.isHidden = true

		containerView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
		}

//		let vc = SearchViewController()
//
//		navigationController?.pushViewController(vc, animated: true)

	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		containerView.snp.remakeConstraints { make in
			make.top.equalTo(localCollectionView.snp.bottom)
			make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
		}
		localCollectionView.snp.remakeConstraints { make in
			make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)

			make.height.equalTo(100)
		}
		tabManVC.view.isHidden = false
		localCollectionView.isHidden = false


	}
}


// 시티 콜렉션뷰
extension TotalViewController: UICollectionViewDelegate, UICollectionViewDataSource {


	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return CityCode.allCases.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LocalCollectionViewCell

		let imageNumber = indexPath.row

		cell.imageView.image = UIImage(named: "\(imageNumber + 1)")
		cell.cityLabel.text = NSLocalizedString(CityCode.allCases[indexPath.row].name, comment: "")

		if selectedCellIndex == indexPath.item {
			cell.imageView.layer.borderColor = UIColor.systemBlue.cgColor
			cell.imageView.layer.borderWidth = 4
		}

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		selectedCellIndex = indexPath.item
		tabManVC.itemSelected(at: indexPath.row)
		collectionView.reloadData()
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
