//
//  WantedListCollectionViewCell.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/30.
//  Copyright © 2017年 kazu. All rights reserved.
//

import UIKit

class WantedListCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var companyLogoView: UIImageView!
	@IBOutlet weak var companyNameLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var roleLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	func updateCell(imageUrl: String, companyLogoUrl: String, companyName: String, title: String, description: String, role: String) {
		companyNameLabel.text = companyName
		titleLabel.text = title
		descriptionLabel.text = description
		roleLabel.text = role
	}
}
