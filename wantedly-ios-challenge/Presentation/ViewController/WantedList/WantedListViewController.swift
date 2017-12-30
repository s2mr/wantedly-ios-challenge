//
//  WantedListViewController.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/29.
//  Copyright © 2017年 kazu. All rights reserved.
//

import UIKit

class WantedListViewController: UIViewController {
	var viewModel: WantedListViewModel!
	
	@IBOutlet weak var collectionView: UICollectionView!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		viewModel.fetchWantedList(query: "", page: 1)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func setupUI() {
		self.title = "募集一覧"
		let nib = UINib(nibName: "WantedListCollectionViewCell", bundle: nil) //FIXME: use R.swift
		collectionView.register(nib, forCellWithReuseIdentifier: "WantedListCollectionViewCell")
	}
}

extension WantedListViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.wantedListItems.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let c = collectionView.dequeueReusableCell(withReuseIdentifier: "WantedListCollectionViewCell", for: indexPath) as? WantedListCollectionViewCell //FIXME: use R.swift
		guard let cell = c else {
			return collectionView.dequeueReusableCell(withReuseIdentifier: "WantedListCollectionViewCell", for: indexPath)
		}
		let item = viewModel.wantedListItems[indexPath.row]
		cell.updateCell(imageUrl: item.imageUrl ?? "",
						companyLogoUrl: item.companyLogoUrl ?? "",
						companyName: item.companyName ?? "",
						title: item.title ?? "",
						description: item.description ?? "",
						role: item.lookingFor ?? "")
		return cell
	}
}

extension WantedListViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.view.bounds.width - 16, height: 300)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
	}
}
