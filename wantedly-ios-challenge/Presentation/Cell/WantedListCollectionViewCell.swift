//
//  WantedListCollectionViewCell.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/30.
//  Copyright © 2017年 kazu. All rights reserved.
//

import UIKit
import AlamofireImage

class WantedListCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var companyLogoView: UIImageView!
	@IBOutlet weak var companyNameLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var roleLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		titleLabel.lineBreakMode = .byWordWrapping
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
		
		descriptionLabel.lineBreakMode = .byTruncatingTail
		descriptionLabel.numberOfLines = 2
	}
	
	func updateCell(imageUrl: String, companyLogoUrl: String, companyName: String, title: String, description: String, role: String) {
		var description = description
		if let url = URL(string: imageUrl) {
			imageView.af_setImage(withURL: url)
		}
		if let url = URL(string: companyLogoUrl) {
			companyLogoView.af_setImage(withURL: url)
		}
		companyNameLabel.text = companyName
		titleLabel.text = title
		while let range = description.range(of: "\r\n") {
			description.replaceSubrange(range, with: "")
		}
		descriptionLabel.text = description
		roleLabel.text = role
	}
}
