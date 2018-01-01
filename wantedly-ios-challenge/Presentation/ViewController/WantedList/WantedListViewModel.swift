//
//  WantedListViewModel.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/29.
//  Copyright © 2017年 kazu. All rights reserved.
//

import Foundation
import RxSwift

protocol WantedListViewModel {
	func fetchWantedList(query: String, shouldReset: Bool)
	var wantedListItems: [WantedListModel] { get }
	var page: Int { get set }
}

class WantedListViewModelImpl: WantedListViewModel {
	let vc: WantedListViewController
	let repository = WantedListRepositoryImpl()
	let disposeBag = DisposeBag()
	
	var page = 0
	var wantedListItems: [WantedListModel] = []
	
	init(vc: WantedListViewController) {
		self.vc = vc
	}
	
	func fetchWantedList(query: String, shouldReset: Bool) {
		if shouldReset {
			page = 0
		} else {
			page += 1
		}
		repository.findAll(query: query, page: page)
			.subscribe({ event in
				switch event {
				case .next(let v):
					if let models = v.model {
						if shouldReset {
							self.wantedListItems = models
							self.vc.collectionView.reloadData()
						} else {
							self.wantedListItems += models
							//UIView.setAnimationsEnabled(false) // TODO: disable animation
//							self.vc.collectionView.performBatchUpdates({
								self.vc.collectionView.reloadData()
//							}, completion: { _ in
//								UIView.setAnimationsEnabled(true)
//							})
						}
					}
				case .error(let e):
					print(e)
				case .completed:
					print("completed")
				}
			})
			.disposed(by: disposeBag)
	}
}
