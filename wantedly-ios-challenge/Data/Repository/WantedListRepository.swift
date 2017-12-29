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
	func findAll(query: String, page: Int) -> Observable<WantedListAPIResult>
}

class WantedListRepositoryImpl: WantedListRepository {
	let api = WanAPI()

	func findAll(query: String, page: Int) -> Observable<WantedListAPIResult> {
		return api.send(req: WanAPI.WantedListRequest(q: query, page: page))
//		return v.map {$0.model!}
//		return api.send(req: WanAPI.WantedListRequest(q: query, page: page))
//			.map { $0.model! }
	}
}
