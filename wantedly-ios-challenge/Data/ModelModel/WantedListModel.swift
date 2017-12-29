//
//  WantedListViewModel.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/29.
//  Copyright © 2017年 kazu. All rights reserved.
//

import Foundation
import Unbox

struct WantedListAPIResult: Unboxable {
	var model: [WantedListModel]?
	var metaData: MetaDataModel?
	
	init(unboxer: Unboxer) throws {
		model = unboxer.unbox(key: "data")
		metaData = unboxer.unbox(key: "_metadata")
	}
}

struct WantedListModel: Unboxable {
	var title: String?
	var publishedAt: Date?
	var pageView: Int?
	var location: String?
	var locationSuffix: String?
	var description: String?
	var lookingFor: String?
	var imageUrl: String?
	
	init(unboxer: Unboxer) throws {
		title = unboxer.unbox(key: "title")
	}
}

struct MetaDataModel: Unboxable {
	var totalObjects: Int?
	init(unboxer: Unboxer) throws {
		totalObjects = unboxer.unbox(key: "total_objects")
	}
}
