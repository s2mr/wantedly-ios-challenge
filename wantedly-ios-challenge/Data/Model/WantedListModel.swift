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
	var pageView: Int?
	var location: String?
	var locationSuffix: String?
	var description: String?
	var lookingFor: String?
	var imageUrl: String?
	var companyName: String?
	var companyLogoUrl: String?
	var staffings: [Staffing]?
	
	struct Staffing: Unboxable {
		var isLeader: Bool?
		var name: String?
		var facebookUid: String?
		var description: String?
		
		init(unboxer: Unboxer) throws {
			isLeader = unboxer.unbox(key: "is_leader")
			name = unboxer.unbox(key: "name")
			facebookUid = unboxer.unbox(key: "facebook_uid")
			description = unboxer.unbox(key: "description")
		}
	}
	
	init(unboxer: Unboxer) throws {
		title = unboxer.unbox(key: "title")
		pageView = unboxer.unbox(key: "page_view")
		location = unboxer.unbox(key: "location")
		locationSuffix = unboxer.unbox(key: "location_suffix")
		description = unboxer.unbox(key: "description")
		lookingFor = unboxer.unbox(key: "looking_for")
		imageUrl = unboxer.unbox(keyPath: "image.i_320_131_x2")
		companyName = unboxer.unbox(keyPath: "company.name")
		companyLogoUrl = unboxer.unbox(keyPath: "company.avatar.s_50")
		staffings = unboxer.unbox(key: "staffings")
	}
}

struct MetaDataModel: Unboxable {
	var totalObjects: Int?
	var perPage: Int?
	var totalPages: Int?
	
	init(unboxer: Unboxer) throws {
		totalObjects = unboxer.unbox(key: "total_objects")
		perPage = unboxer.unbox(key: "per_page")
		totalPages = unboxer.unbox(key: "total_pages")
	}
}
