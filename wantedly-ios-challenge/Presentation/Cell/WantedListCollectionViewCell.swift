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
		contentView.backgroundColor = UIColor.white
		
		titleLabel.lineBreakMode = .byWordWrapping
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
		
		descriptionLabel.font = UIFont.systemFont(ofSize: 13)
		descriptionLabel.lineBreakMode = .byTruncatingTail
		descriptionLabel.numberOfLines = 2
		
//		let frame = roleLabel.frame // TODO: extend frame width
//		roleLabel.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width+15, height: frame.height)
		roleLabel.font = UIFont.systemFont(ofSize: 15)
		roleLabel.layer.cornerRadius = 3
		roleLabel.layer.borderWidth = 1
		roleLabel.layer.borderColor = UIColor.blue.cgColor
		roleLabel.layer.backgroundColor = UIColor.blue.cgColor
		roleLabel.textColor = UIColor.white
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
		roleLabel.sizeToFit()
	}
}
