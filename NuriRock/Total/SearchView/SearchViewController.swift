//
//  SearchViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/8/24.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
	func didSelectSearchResult(keyword: String)
}

final class SearchViewController: BaseViewController {

	private enum Section: CaseIterable {
		case history
	}

	weak var delegate: SearchViewControllerDelegate?

	private let emptyMainLabel = UILabel()
	private let emptyLabel = UILabel()

	private var currentSearchLabel = UILabel()

	private var allDeleteButton = UIButton()

	private lazy var searchHistoryCollectionView = {
		let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
		view.delegate = self
		return view
	}()

	private var dataSource: UICollectionViewDiffableDataSource<Section, SearchedKeyword>!

	private let repository = SearchHistoryRepository()
	var list: [SearchedKeyword] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		list = repository.fetchHistory()
		configureDataSource()
		updateSnapshot()

		print(#function)
	}


	override func configureHierarchy() {

		view.addSubview(emptyMainLabel)
		view.addSubview(emptyLabel)
		view.addSubview(currentSearchLabel)
		view.addSubview(allDeleteButton)
		view.addSubview(searchHistoryCollectionView)
	}

	override func configureLayout() {



		emptyLabel.snp.makeConstraints { make in

			make.centerX.centerY.equalToSuperview()
			make.width.greaterThanOrEqualTo(0)
			make.height.equalTo(20)

		}
		emptyMainLabel.snp.makeConstraints { make in

			make.bottom.equalTo(emptyLabel.snp.top).offset(4)
			make.centerX.equalToSuperview()
			make.size.equalTo(100)
		}

		currentSearchLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.leading.equalTo(8)
			make.width.greaterThanOrEqualTo(0)
			make.height.equalTo(20)


		}

		allDeleteButton.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.trailing.equalTo(-8)
			make.width.greaterThanOrEqualTo(0)
			make.height.equalTo(20)
		}

		searchHistoryCollectionView.snp.makeConstraints { make in
			make.top.equalTo(currentSearchLabel.snp.bottom).offset(4)
			make.horizontalEdges.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}


	override func configureView() {

		currentSearchLabel.text = NSLocalizedString(LocalString.recentSearchHistory.rawValue, comment: "")
		currentSearchLabel.font = .boldSystemFont(ofSize: 15)
		currentSearchLabel.textColor = .text
		currentSearchLabel.textAlignment = .left

		allDeleteButton.setTitle(NSLocalizedString(LocalString.clearAll.rawValue, comment: ""), for: .normal)
		allDeleteButton.setTitleColor(.text, for: .normal)
		allDeleteButton.titleLabel?.font = .boldSystemFont(ofSize: 13)
		allDeleteButton.titleLabel?.textAlignment = .right


		allDeleteButton.addTarget(self, action: #selector(clearHistory), for: .touchUpInside)


		emptyMainLabel.text = "텅~"
		emptyMainLabel.font = .boldSystemFont(ofSize: 50)
		emptyMainLabel.textAlignment = .center

		emptyLabel.text = NSLocalizedString(LocalString.noHistory.rawValue, comment: "")
		emptyLabel.font = .boldSystemFont(ofSize: 16)
		emptyLabel.textColor = .text
		emptyLabel.textAlignment = .center
	}

	@objc private func clearHistory() {
		repository.deleteAllKeyword()
		updateSnapshot()
	}

	private func configureCollectionViewLayout() -> UICollectionViewLayout {

		var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
		configuration.showsSeparators = true
		configuration.separatorConfiguration.color = .background
		configuration.backgroundColor = .background


		return UICollectionViewCompositionalLayout.list(using: configuration)
	}

	private func configureDataSource() {

		//cellRegistration의 역할 = cell.textLabel.text = "고래밥"
		let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchedKeyword> { cell, indexPath, itemIdentifier in

			//이전에 cellForItemAt 부분

			var content = UIListContentConfiguration.subtitleCell()
			content.text = itemIdentifier.keyword
			content.textProperties.color = .background
			content.textProperties.font = .boldSystemFont(ofSize: 14)
			content.textProperties.alignment = .center
			cell.contentConfiguration = content



			var background = UIBackgroundConfiguration.listPlainCell()
			background.backgroundColor = .point

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

		if list == [] {
			searchHistoryCollectionView.isHidden = true
			currentSearchLabel.isHidden = true
			allDeleteButton.isHidden = true
		} else {
			searchHistoryCollectionView.isHidden = false
			currentSearchLabel.isHidden = false
			allDeleteButton.isHidden = false
		}

		var snapshot = NSDiffableDataSourceSnapshot<Section, SearchedKeyword>()
		snapshot.appendSections(Section.allCases)
		snapshot.appendItems(list, toSection: .history)


		dataSource.apply(snapshot) //reloadData
	}
}

extension SearchViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let keyword = list[indexPath.item].keyword
		delegate?.didSelectSearchResult(keyword: keyword)

		repository.addKeyword(keyword: list[indexPath.item].keyword)
		list = repository.fetchHistory()
		updateSnapshot()



	}
}


