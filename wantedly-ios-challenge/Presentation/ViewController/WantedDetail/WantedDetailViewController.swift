//
//  WantedDetailViewController.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2018/01/01.
//  Copyright © 2018年 kazu. All rights reserved.
//

import UIKit

final class WantedDetailViewController: UIViewController {
	static func make(listModel: WantedListModel) -> WantedDetailViewController {
		let viewController = R.storyboard.wantedDetailViewController.instantiateInitialViewController()!
		viewController.viewModel = WantedDetailViewModel(listModel)
		return viewController
	}
	
	var viewModel: WantedDetailViewModelType!
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var roleLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var companyLogoView: UIImageView!
	@IBOutlet weak var companyNameLabel: UILabel!
	@IBOutlet weak var memberTitleLabel: UILabel!
	@IBOutlet weak var peopleLabel: UILabel!
	@IBOutlet weak var descriptionTitleLabel: UILabel!
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
		titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
		
		descriptionLabel.font = UIFont.systemFont(ofSize: 17)
		descriptionLabel.lineBreakMode = .byTruncatingTail
		descriptionLabel.numberOfLines = 0
		
		roleLabel.font = UIFont.systemFont(ofSize: 15)
		
		companyNameLabel.font = UIFont.systemFont(ofSize: 14)
		companyNameLabel.textColor = UIColor.lightGray
		
		memberTitleLabel.font = UIFont.boldSystemFont(ofSize: 19)
		
		peopleLabel.lineBreakMode = .byWordWrapping
		peopleLabel.numberOfLines = 0
		peopleLabel.font = UIFont.systemFont(ofSize: 16)
		
		descriptionTitleLabel.font = UIFont.boldSystemFont(ofSize: 19)
		descriptionLabel.font = UIFont.systemFont(ofSize: 16)
	}
	
	func setupModel() {
		if let url = viewModel.listModel.imageUrl.flatMap({ URL(string: $0) }) {
			imageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "placeholder"))
		}

		if let url = viewModel.listModel.companyLogoUrl.flatMap({ URL(string: $0) }) {
			companyLogoView.af_setImage(withURL: url, placeholderImage: UIImage(named: "placeholder"))
		}

		let peoplesStr = NSMutableAttributedString()
		viewModel.listModel.staffings?.forEach { staff in
			if let name = staff.name {
				peoplesStr.append(NSAttributedString(string: "\(name)\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)]))
			}

			if let description = staff.description {
				peoplesStr.append(NSAttributedString(string: "\(description)\n\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]))
			}
		}
		peopleLabel.attributedText = peoplesStr

		companyNameLabel.text = viewModel.listModel.companyName
		titleLabel.text = viewModel.listModel.title
		descriptionLabel.text = viewModel.listModel.description
		roleLabel.text = viewModel.listModel.lookingFor
		roleLabel.sizeToFit()
	}
}
