//
//  SearchResultViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/14/24.
//

import UIKit

import UIKit

class SearchResultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	var viewModel = SearchResultViewModel()
	private var collectionView: UICollectionView?

	override func viewDidLoad() {
		super.viewDidLoad()
		configureCollectionView()
		bindViewModel()
	}

	private func configureCollectionView() {
		let layout = UICollectionViewFlowLayout()
		layout.headerReferenceSize = CGSize(width: 200, height: 50)  // This is another way to set header size
		collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
		layout.itemSize = CGSize(width: 100, height: 150) // Adjust size as needed
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

		collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
		collectionView?.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: "resultcell")
		collectionView?.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
		collectionView?.delegate = self
		collectionView?.dataSource = self
		collectionView?.backgroundColor = UIColor.white

		if let collectionView = collectionView {
			self.view.addSubview(collectionView)
		}
	}

	private func bindViewModel() {
		viewModel.outputTourData.bind { [weak self] _ in
			self?.collectionView?.reloadData()
		}

		viewModel.outputCultureData.bind { [weak self] _ in
			self?.collectionView?.reloadData()
		}

		viewModel.outputFestivalData.bind { [weak self] _ in
			self?.collectionView?.reloadData()
		}

		viewModel.outputHotelData.bind { [weak self] _ in
			self?.collectionView?.reloadData()
		}

		viewModel.outputShoppingData.bind { [weak self] _ in
			self?.collectionView?.reloadData()
		}

		viewModel.outputRestaurantData.bind { [weak self] _ in
			self?.collectionView?.reloadData()
		}
	}

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 6 // 카테고리 수
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard kind == UICollectionView.elementKindSectionHeader else {
			return UICollectionReusableView()
		}

		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView

		let sectionTitle: String = {
			switch indexPath.section {
			case 0: return "Tour"
			case 1: return "Culture"
			case 2: return "Festival"
			case 3: return "Hotel"
			case 4: return "Shopping"
			case 5: return "Restaurant"
			default: return ""
			}
		}()

		header.configure(title: sectionTitle)
		return header
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: collectionView.frame.width, height: 50)  // Adjust the height as needed
	}


	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			guard let data = viewModel.outputTourData.value?.response.body.items?.item else { return 0 }
			return data.count
		case 1:
			guard let data = viewModel.outputCultureData.value?.response.body.items?.item else { return 0 }
			return data.count
		case 2:
			guard let data = viewModel.outputFestivalData.value?.response.body.items?.item else { return 0 }
			return data.count
		case 3:
			guard let data = viewModel.outputHotelData.value?.response.body.items?.item else { return 0 }
			return data.count
		case 4:
			guard let data = viewModel.outputShoppingData.value?.response.body.items?.item else { return 0 }
			return data.count
		case 5:
			guard let data = viewModel.outputRestaurantData.value?.response.body.items?.item else { return 0 }
			return data.count
		default:
			return 0
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultcell", for: indexPath) as! ResultCollectionViewCell


		let item: Item? = {
			switch indexPath.section {
			case 0: return viewModel.outputTourData.value?.response.body.items?.item?[indexPath.row]
			case 1: return viewModel.outputCultureData.value?.response.body.items?.item?[indexPath.row]
			case 2: return viewModel.outputFestivalData.value?.response.body.items?.item?[indexPath.row]
			case 3: return viewModel.outputHotelData.value?.response.body.items?.item?[indexPath.row]
			case 4: return viewModel.outputShoppingData.value?.response.body.items?.item?[indexPath.row]
			case 5: return viewModel.outputRestaurantData.value?.response.body.items?.item?[indexPath.row]
			default: return nil
			}
		}()

		if let cellItem = item {
			cell.titleLabel.text = cellItem.title
			cell.addressLabel.text = cellItem.addr1

			let url = URL(string: cellItem.firstimage)
			cell.thumbnailImageView.kf.setImage(with: url)

			return cell
			}
		return cell
		}
	}


