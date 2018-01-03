//
//  WantedDetailViewModel.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2018/01/01.
//  Copyright © 2018年 kazu. All rights reserved.
//

import Foundation

protocol WantedDetailViewModelType {
	var listModel: WantedListModel! { get }
}

final class WantedDetailViewModel: WantedDetailViewModelType {
	internal var listModel: WantedListModel!
	
	init(_ model: WantedListModel) {
		self.listModel = model
	}
}
