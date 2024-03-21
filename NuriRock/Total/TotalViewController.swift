//
//  TotalViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/7/24.
//

import UIKit
import SnapKit
import Toast


final class TotalViewController: BaseViewController {

	lazy var cityCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionView())
	var selectedCellIndex = 0

	var containerView = UIView()
	let searchVC = SearchViewController()
	let tabManVC = TabManViewController()

	let repository = SearchHistoryRepository()

	var isInSearchView = false


    override func viewDidLoad() {
        super.viewDidLoad()
		


		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.placeholder = "입력해봐"
		searchController.searchBar.showsScopeBar = true
		searchController.searchBar.delegate = self

		self.navigationItem.searchController = searchController

		navigationItem.hidesSearchBarWhenScrolling = false

		let logo = UIImage(resource: .title)
		let imageView = UIImageView(image: logo)


		imageView.contentMode = .scaleAspectFit
		navigationItem.titleView = imageView
		navigationController?.navigationBar.backgroundColor = .background


		tabManVC.viewControllers.forEach {
			if let contentVC = $0 as? ContentViewController {
				contentVC.scrollDelegate = self
				contentVC.didSelectDelegate = self
			} else		if let totalResultVC = tabManVC.viewControllers.first as? TotalResultViewController {
				totalResultVC.scrollDelegate = self
		 }
		}

    }

	override func configureHierarchy() {

		view.addSubview(cityCollectionView)
		view.addSubview(containerView)
		containerView.addSubview(searchVC.view)
		containerView.addSubview(tabManVC.view)


	}

	override func configureLayout() {


		cityCollectionView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)

			make.height.equalTo(100)
		}


		containerView.snp.makeConstraints { make in
			make.top.equalTo(cityCollectionView.snp.bottom)
			make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
		}
		searchVC.view.snp.makeConstraints { make in
			make.edges.equalToSuperview()

		}


		tabManVC.view.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}

	override func configureView() {




		cityCollectionView.backgroundColor = .background

		cityCollectionView.delegate = self
		cityCollectionView.dataSource = self
		cityCollectionView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

		searchVC.delegate = self

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

	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		print(#function)
		tabManVC.view.isHidden = true
		cityCollectionView.isHidden = true

		containerView.snp.remakeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
		}

		isInSearchView = true
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		containerView.snp.remakeConstraints { make in
			make.top.equalTo(cityCollectionView.snp.bottom)
			make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
		}
		cityCollectionView.snp.remakeConstraints { make in
			make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)

			make.height.equalTo(100)
		}
		tabManVC.view.isHidden = false
		cityCollectionView.isHidden = false

		isInSearchView = false
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

		guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {

			view.makeToast("공백 없이 입력해주세요", position: .center)
			return
		}

			repository.addKeyword(keyword: searchBar.text!)
			let vc = SearchResultViewController()
			vc.viewModel.inputKeyword.value = searchBar.text!
			navigationController?.pushViewController(vc, animated: true)
			searchBar.text = ""
			searchVC.list = repository.fetchHistory()
			searchVC.updateSnapshot()



	}
}


// 시티 콜렉션뷰
extension TotalViewController: UICollectionViewDelegate, UICollectionViewDataSource {


	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return CityCode.allCases.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CityCollectionViewCell

		let imageNumber = indexPath.row

		cell.imageView.image = UIImage(named: "\(imageNumber + 1)")
		cell.cityLabel.text = NSLocalizedString(CityCode.allCases[indexPath.row].name, comment: "")

		if selectedCellIndex == indexPath.item {
			cell.imageView.layer.borderColor = UIColor.point.cgColor
			cell.imageView.layer.borderWidth = 4
		}

		return cell
	}

	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		tabManVC.localCollectionViewRow = indexPath.item

		selectedCellIndex = indexPath.item
		tabManVC.itemSelected(at: indexPath.item)
		tabManVC.scrollToPage(.at(index: 0), animated: true)

		collectionView.reloadData()
	}
}


extension TotalViewController: TotalResultViewControllerDelegate {
	func totalResultViewControllerDidSelectItem(withID id: String) {
		let vc = DetailContentInfoViewController()
		vc.viewModel.inputContentId.value = id
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func didScrollTableView(_ direction: ScrollDirection) {
		switch direction {
		case .down:
			if !isInSearchView {
				UIView.animate(withDuration: 0.3) {
					self.cityCollectionView.isHidden = false
					self.containerView.snp.remakeConstraints { make in
						make.top.equalTo(self.cityCollectionView.snp.bottom)
						make.bottom.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
					}

					self.view.layoutIfNeeded()
				}
			}
		case .up:
			UIView.animate(withDuration: 0.3) {
				self.cityCollectionView.isHidden = true
				self.containerView.snp.remakeConstraints { make in
					make.top.equalTo(self.view.safeAreaLayoutGuide)
					make.bottom.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
				}
				self.view.layoutIfNeeded()

		
			}
		}
	}
}


extension TotalViewController: SearchViewControllerDelegate {
	func didSelectSearchResult(keyword: String) {
		let vc = SearchResultViewController()
		vc.viewModel.inputKeyword.value = keyword
		navigationController?.pushViewController(vc, animated: true)
	}
	

}

extension TotalViewController: TotalResultTableViewCellDelegate {
	func didSelectItem(selectedItem: String) {
		let vc = DetailContentInfoViewController()
		vc.viewModel.inputContentId.value = selectedItem
		navigationController?.pushViewController(vc, animated: true)
	}
	

}
