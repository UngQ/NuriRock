//
//  OnboardingViewController.swift
//  NuriRock
//
//  Created by ungQ on 3/7/24.
//

import UIKit
import SnapKit


final class OnboardingViewController: BaseViewController {

	let choiceLabel = UILabel()
	lazy var countryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionView())
	let okButton = UIButton()

	var currentLanguage = Country.from(languageCode: Locale.current.language.languageCode?.identifier ?? "en") {
		didSet {
			UserDefaults.standard.set(currentLanguage.rawValue, forKey: Language.Code.rawValue)
			print(UserDefaults.standard.string(forKey: Language.Code.rawValue))
		}
	}

	var test = true

    override func viewDidLoad() {
        super.viewDidLoad()



		UserDefaults.standard.set(currentLanguage.rawValue, forKey: Language.Code.rawValue)

    }

	override func configureHierarchy() {
		view.addSubview(choiceLabel)
		view.addSubview(countryCollectionView)
		view.addSubview(okButton)
	}

	override func configureLayout() {
		countryCollectionView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
			make.width.equalToSuperview()
			make.height.equalTo(countryCollectionView.snp.width)
		}

		choiceLabel.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalTo(countryCollectionView.snp.top).offset(8)
			make.width.equalToSuperview()
			make.height.equalTo(36)
		}

		okButton.snp.makeConstraints { make in
			make.top.equalTo(countryCollectionView.snp.bottom).offset(8)
			make.centerX.equalToSuperview()
			make.width.equalTo(108)
			make.height.equalTo(36)
		}
	}

	override func configureView() {
		choiceLabel.text = NSLocalizedString(LocalString.LanguageSetting.rawValue, comment: "")
		choiceLabel.textAlignment = .center
		countryCollectionView.backgroundColor = .darkGray
		okButton.backgroundColor = .text

		countryCollectionView.delegate = self
		countryCollectionView.dataSource = self
		countryCollectionView.register(CountryCollectionViewCell.self, forCellWithReuseIdentifier: "CountryCollectionViewCell")

	}

	private func configureCollectionView() -> UICollectionViewFlowLayout {


		let layout = UICollectionViewFlowLayout()
		let spacing: CGFloat = 12
		let cellWidth = UIScreen.main.bounds.width - (spacing * 3)

		layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 2)
		layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: 0, right: spacing)
		layout.minimumLineSpacing = spacing
		layout.minimumInteritemSpacing = 0
		layout.scrollDirection = .vertical

		return layout

	}


}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Country.allCases.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryCollectionViewCell", for: indexPath) as! CountryCollectionViewCell

		cell.flagLabel.text = Country.allCases[indexPath.row].flag

		if currentLanguage == Country.allCases[indexPath.row] {
			cell.flagLabel.layer.borderWidth = 4
			cell.flagLabel.layer.borderColor = UIColor.red.cgColor
		} else {
			cell.flagLabel.layer.borderWidth = 4
			cell.flagLabel.layer.borderColor = UIColor.green.cgColor
		}


		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryCollectionViewCell", for: indexPath) as! CountryCollectionViewCell

		
		currentLanguage = Country.allCases[indexPath.row]
		print("hi")
		collectionView.reloadData()
	}



}
