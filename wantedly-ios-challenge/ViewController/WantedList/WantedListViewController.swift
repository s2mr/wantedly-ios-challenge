//
//  WantedListViewController.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/29.
//  Copyright © 2017年 kazu. All rights reserved.
//

import UIKit

class WantedListViewController: UIViewController {
	var viewModel: WantedListViewModel!

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.fetchWantedList(query: "swift", page: 1)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
