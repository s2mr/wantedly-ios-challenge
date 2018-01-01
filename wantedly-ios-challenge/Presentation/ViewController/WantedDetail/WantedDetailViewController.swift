//
//  WantedDetailViewController.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2018/01/01.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit

class WantedDetailViewController: UIViewController {
	var viewModel: WantedDetailViewModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let label = UITextView(frame: self.view.frame)
		label.text = dump(viewModel.model).debugDescription
		self.view.addSubview(label)
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
