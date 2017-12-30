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
	func fetchWantedList(query: String, page: Int)
	var wantedListItems: [WantedListModel] { get }
}

class WantedListViewModelImpl: WantedListViewModel {
	let vc: WantedListViewController
	let repository = WantedListRepositoryImpl()
	let disposeBag = DisposeBag()
	
	var wantedListItems: [WantedListModel] = []
	
	init(vc: WantedListViewController) {
		self.vc = vc
	}
	
	func fetchWantedList(query: String, page: Int) {
		repository.findAll(query: query, page: page)
			.subscribe({ event in
				switch event {
				case .next(let v):
					if let models = v.model {
						self.wantedListItems = models
						self.vc.collectionView.reloadData()
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
