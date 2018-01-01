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
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var roleLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var companyLogoView: UIImageView!
	@IBOutlet weak var companyNameLabel: UILabel!
	@IBOutlet weak var peopleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupModel()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func setupUI() {
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		companyLogoView.contentMode = .scaleAspectFill
		companyLogoView.clipsToBounds = true
		
		titleLabel.lineBreakMode = .byWordWrapping
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
		
		descriptionLabel.font = UIFont.systemFont(ofSize: 13)
		descriptionLabel.lineBreakMode = .byTruncatingTail
		descriptionLabel.numberOfLines = 2
		
		roleLabel.font = UIFont.systemFont(ofSize: 15)
		roleLabel.layer.cornerRadius = 3
		roleLabel.layer.borderWidth = 1
		roleLabel.layer.borderColor = UIColor.blue.cgColor
		roleLabel.layer.backgroundColor = UIColor.blue.cgColor
		roleLabel.textColor = UIColor.white
		
		peopleLabel.lineBreakMode = .byWordWrapping
		peopleLabel.numberOfLines = 0
	}
	
	func setupModel() {
		imageView.image = UIImage(named: "placeholder")
		if let url = URL(string: viewModel.model.imageUrl ?? "") {
			imageView.af_setImage(withURL: url)
		}
		companyLogoView.image = UIImage(named: "placeholder")
		if let url = URL(string: viewModel.model.companyLogoUrl ?? "") {
			companyLogoView.af_setImage(withURL: url)
		}
		companyNameLabel.text = viewModel.model.companyName
		
		let peoplesStr = NSMutableAttributedString()
		for p in viewModel.model.staffings ?? [] {
			if let name = p.name {
				peoplesStr.append(NSAttributedString(string: "\(name)\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)]))
				if let description = p.description {
					peoplesStr.append(NSAttributedString(string: "\(description)\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]))
				}
			}
		}
		peopleLabel.attributedText = peoplesStr
		
		titleLabel.text = viewModel.model.title
		descriptionLabel.text = viewModel.model.description
		roleLabel.text = viewModel.model.lookingFor
		roleLabel.sizeToFit()
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
