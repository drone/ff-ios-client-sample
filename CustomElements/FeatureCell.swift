//
//  FeatureCell.swift
//  CFiOSExample
//
//  Created by Dusan Juranovic on 15.2.21..
//

import UIKit

class FeatureCell: UICollectionViewCell {
	@IBOutlet weak var baseCardView: UIView!
	@IBOutlet weak var featureImage: UIImageView!
	@IBOutlet weak var featureDescription: UITextView?
	@IBOutlet weak var trialLabel: UILabel!
	@IBOutlet weak var enabledButton: UIButton!
	@IBOutlet weak var newImageView: UIImageView!
	
	var darkMode: Bool?
	
	func configure(feature: FeatureCardRepresentable?) {
		guard let feature = feature else {return}
		self.featureDescription?.isHidden = feature.enabled
		self.trialLabel.isHidden = feature.enabled
		self.enabledButton.isHidden = feature.enabled
		self.featureDescription?.text = feature.featureDescription
		self.trialLabel.text = "\(feature.featureTrialPeriod ?? 0)-Day Trial"
		self.newImageView.image = UIImage(named: "new")
		self.newImageView.isHidden = !feature.hasRibbon
		self.isHidden = !feature.available
		configureCell(feature.featureImageName)
	}
	
	func configureCell(_ imageName: String) {
		if let darkMode = darkMode {
			if darkMode {
				self.baseCardView.backgroundColor = UIColor.black
				self.featureImage.image = UIImage(named: imageName.appending("_dark"))
				self.baseCardView.layer.shadowColor = UIColor.white.withAlphaComponent(0.2).cgColor
				self.enabledButton.layer.borderColor = UIColor(red: 89/255, green: 179/255, blue: 255/255, alpha: 1).cgColor
				self.enabledButton.setTitleColor(UIColor(red: 89/255, green: 179/255, blue: 255/255, alpha: 1), for: .normal)
				self.trialLabel.textColor = UIColor(red: 144/255, green: 159/255, blue: 172/255, alpha: 1)

			} else {
				self.baseCardView.backgroundColor = UIColor.white
				self.featureImage.image = UIImage(named: imageName)
				self.baseCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
				self.enabledButton.layer.borderColor = UIColor(red: 50/255, green: 125/255, blue: 255/255, alpha: 1).cgColor
				self.enabledButton.setTitleColor(UIColor(red: 50/255, green: 125/255, blue: 255/255, alpha: 1), for: .normal)
				self.trialLabel.textColor = UIColor(red: 107/255, green: 123/255, blue: 137/255, alpha: 1)
			}
		}
		self.layer.cornerRadius = 15
		self.baseCardView.layer.cornerRadius = 15
		self.baseCardView.layer.shadowOpacity = 1
		self.baseCardView.layer.shadowOffset = CGSize(width: 3, height: 3)
		self.enabledButton.layer.borderWidth = 1
		self.enabledButton.layer.cornerRadius = 5
	}
	
	override func prepareForReuse() {
		self.newImageView.isHidden = true
		self.trialLabel.text = ""
		self.darkMode = false
	}
}
