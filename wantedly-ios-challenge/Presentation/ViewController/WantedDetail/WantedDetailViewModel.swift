//
//  WantedDetailViewModel.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2018/01/01.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation

protocol WantedDetailViewModel {
	var model: WantedListModel! { get }
}

class WantedDetailViewModelImpl: WantedDetailViewModel {
	let vc: WantedDetailViewController!
	var model: WantedListModel!
	
	init(_ vc: WantedDetailViewController, model: WantedListModel) {
		self.vc = vc
		self.model = model
	}
}
