//
//  WantedListRequest.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/29.
//  Copyright © 2017年 kazu. All rights reserved.
//

import Foundation
import Alamofire

extension WanAPI {
	struct WantedListRequest {
		let q: String
		let page: Int
	}
}

extension WanAPI.WantedListRequest: WanAPIRequest {
	typealias Response = WantedListModel
	
	var path: String {
		return "/projects"
	}
	
	var headers: HTTPHeaders? {
		return nil
	}
	
	var method: HTTPMethod {
		return .get
	}
	
	var parameters: Parameters? {
		return ["q": q,
				"page": page]
	}
}
