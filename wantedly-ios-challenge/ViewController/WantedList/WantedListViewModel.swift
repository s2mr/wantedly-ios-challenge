//
//  WantedListViewModel.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/29.
//  Copyright © 2017年 kazu. All rights reserved.
//

import Foundation

protocol WantedListViewModel {
	func fetchWantedList()
}

class WantedListViewModelImpl: WantedListViewModel {
	let repository = WantedListRepositoryImpl()
	func fetchWantedList() {
		repository.findAll(query: "swift", page: 1)
			.subscribe({ event in
				print(event)
		})
	}
}
