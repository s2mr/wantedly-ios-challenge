//
//  WantedListRepository.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/29.
//  Copyright © 2017年 kazu. All rights reserved.
//

import Foundation
import RxSwift

protocol WantedListRepository {
	func findAll(query: String, page: Int) -> Observable<WantedListModel>
}

class WantedListRepositoryImpl: WantedListRepository {
	let api = WanAPI()

	func findAll(query: String, page: Int) -> Observable<WantedListModel> {
		return api.send(req: WanAPI.WantedListRequest(q: query, page: page))
	}
}
