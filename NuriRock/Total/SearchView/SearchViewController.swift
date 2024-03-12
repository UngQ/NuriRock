//
//  SearchViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/8/24.
//

import UIKit

class SearchViewController: BaseViewController {

	enum Section: CaseIterable {
		case history
	}

	let emptyImageView = UIImageView()
	let emptyLabel = UILabel()

	var currentSearchLabel = UILabel()

	var allDeleteButton = UIButton()

	lazy var searchHistoryCollectionView = {
		let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
//		view.delegate = self
		return view
	}()

	var dataSource: UICollectionViewDiffableDataSource<Section, SearchedKeyword>!

	let repository = SearchHistoryRepository()
	var list: [SearchedKeyword] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		list = repository.fetchHistory()
		configureDataSource()
		updateSnapshot()
	}


	override func configureHierarchy() {
		view.addSubview(emptyImageView)
		view.addSubview(emptyLabel)
		view.addSubview(currentSearchLabel)
		view.addSubview(allDeleteButton)
		view.addSubview(searchHistoryCollectionView)
	}

	override func configureLayout() {
		emptyImageView.snp.makeConstraints { make in
			make.centerX.centerY.equalToSuperview()
			make.size.equalTo(100)
		}

		emptyLabel.snp.makeConstraints { make in
			make.top.equalTo(emptyImageView.snp.bottom).offset(8)
			make.centerX.equalToSuperview()
		}

		currentSearchLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.leading.equalTo(4)

		}

		allDeleteButton.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.trailing.equalTo(-4)
		}

		searchHistoryCollectionView.snp.makeConstraints { make in
			make.top.equalTo(currentSearchLabel.snp.bottom).offset(4)
			make.horizontalEdges.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}


	override func configureView() {
		emptyImageView.backgroundColor = .brown

		currentSearchLabel.text = " 최근 검색"
		currentSearchLabel.font = .boldSystemFont(ofSize: 15)
		currentSearchLabel.textColor = .black
		currentSearchLabel.textAlignment = .left

		allDeleteButton.setTitle("모두 지우기", for: .normal)
		allDeleteButton.setTitleColor(.black, for: .normal)
		allDeleteButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
		allDeleteButton.titleLabel?.textAlignment = .right

		allDeleteButton.addTarget(self, action: #selector(clearHistory), for: .touchUpInside)


		emptyLabel.text = "최근 검색어가 없어요"
		emptyLabel.font = .boldSystemFont(ofSize: 16)
		emptyLabel.textColor = .black
		emptyLabel.textAlignment = .center

//		if searchHistory == [] {
//			mainView.currentSearchLabel.isHidden = true
//			mainView.allDeleteButton.isHidden = true
//		} else {
//			mainView.emptyImageView.isHidden = true
//			mainView.emptyLabel.isHidden = true
//		}


	}

	@objc private func clearHistory() {
		repository.deleteAllKeyword()
		updateSnapshot()
	}

	private func configureCollectionViewLayout() -> UICollectionViewLayout {

		var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
		configuration.showsSeparators = true
		configuration.separatorConfiguration.color = .white
		configuration.backgroundColor = .white


		return UICollectionViewCompositionalLayout.list(using: configuration)
	}

	private func configureDataSource() {

		//cellRegistration의 역할 = cell.textLabel.text = "고래밥"
		let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchedKeyword> { cell, indexPath, itemIdentifier in

			//이전에 cellForItemAt 부분

			var content = UIListContentConfiguration.subtitleCell()
			content.text = itemIdentifier.keyword
			content.textProperties.color = .white
			content.textProperties.font = .boldSystemFont(ofSize: 14)
			content.textProperties.alignment = .center
			cell.contentConfiguration = content



			var background = UIBackgroundConfiguration.listPlainCell()
			background.backgroundColor = .systemBlue

			cell.backgroundConfiguration = background
		}

		//datasource의 역할 = let cell= collectionView.dequereusable~~~
		dataSource = UICollectionViewDiffableDataSource(collectionView: searchHistoryCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in

			let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)

			return cell
		})

	}

	func updateSnapshot() {
		list = repository.fetchHistory()

		var snapshot = NSDiffableDataSourceSnapshot<Section, SearchedKeyword>()
		snapshot.appendSections(Section.allCases)
		snapshot.appendItems(list, toSection: .history)


		dataSource.apply(snapshot) //reloadData
	}
}
