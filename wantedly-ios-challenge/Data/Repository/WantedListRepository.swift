//
//  WantedListRepository.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2018/01/03.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation
import RxSwift

protocol WantedListRepositoryType {
	func findAll(query: String, page: Int) -> Single<WantedListAPIResult>
}

final class WantedListRepository: WantedListRepositoryType {
	private let api = WanAPI()
	
	func findAll(query: String, page: Int) -> Single<WantedListAPIResult> {
		return api.send(req: WanAPI.WantedListRequest(q: query, page: page))
	}
}
