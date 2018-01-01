//
//  WantedListCollectionViewCell.swift
//  wantedly-ios-challenge
//
//  Created by 下村一将 on 2017/12/30.
//  Copyright © 2017年 kazu. All rights reserved.
//

import UIKit
import AlamofireImage
import FontAwesome_swift

class WantedListCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var viewCountLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var companyLogoView: UIImageView!
	@IBOutlet weak var companyNameLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var roleLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		let goldColor = UIColor(red: 183/255, green: 163/255, blue: 92/255, alpha: 1)
		viewCountLabel.layer.borderColor = goldColor.cgColor
		viewCountLabel.layer.backgroundColor = goldColor.cgColor
		viewCountLabel.layer.cornerRadius = 3
		viewCountLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
		viewCountLabel.textColor = UIColor.white
		
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		companyLogoView.contentMode = .scaleAspectFill
		companyLogoView.clipsToBounds = true
		
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
	
	func updateCell(viewCount: Int, imageUrl: String, companyLogoUrl: String, companyName: String, title: String, description: String, role: String) {
		var description = description
		
		viewCountLabel.text = "\(viewCount) View"
		let _starLabel = starLabel(viewCount: viewCount)
		viewCountLabel.addSubview(_starLabel)
		
		imageView.image = UIImage(named: "placeholder")
		if let url = URL(string: imageUrl) {
			imageView.af_setImage(withURL: url)
		}
		companyLogoView.image = UIImage(named: "placeholder")
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
	
	func starLabel(viewCount: Int) -> UILabel {
		let star = String.fontAwesomeIcon(name: .star)
		let starLabel = UILabel(frame: CGRect(x: -10, y: -15, width: 150, height: 20))
		starLabel.font = UIFont.fontAwesome(ofSize: 14)
		starLabel.textColor = UIColor.black
		switch viewCount {
		case 0..<1000:
			break
		case ..<2500:
			starLabel.text = "\(star)"
		case ..<5000:
			starLabel.text = "Hot!\(star)\(star)"
		default:
			starLabel.text = "Hot!\(star)\(star)\(star)"
		}
		return starLabel
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		for v in viewCountLabel.subviews {
			v.removeFromSuperview()
		}
	}
}
