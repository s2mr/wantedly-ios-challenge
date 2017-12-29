//
//  WanAPI.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/29.
//  Copyright © 2017年 kazu. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class WanAPI {
	let baseURL = "https://www.wantedly.com/api/v1"
	let parameterEncoding: ParameterEncoding!
	
	init() {
		self.parameterEncoding = URLEncoding.methodDependent
	}
	
	func send<Req: WanAPIRequest>(req: Req) -> Observable<Req.Response> {
		let url = baseURL.appending(req.path)
		let req = Alamofire.request(url, method: req.method, parameters: req.parameters, encoding: parameterEncoding, headers: req.headers)
		print(req.debugDescription)
		return Observable.create({ observer in
			req.responseJSON(completionHandler: { dataResponse in
				print(dataResponse.debugDescription)
				switch dataResponse.result {
				case .success(let v):
					print(v)
				case .failure(let e):
					observer.onError(e)
				}
			})
			return Disposables.create()
		})
	}
}
