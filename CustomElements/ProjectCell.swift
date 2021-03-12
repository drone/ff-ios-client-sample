//
//  ProjectCell.swift
//  CFiOSExample
//
//  Created by Dusan Juranovic on 14.1.21..
//

import UIKit
import ff_ios_client_sdk

class ProjectCell: UITableViewCell {
	@IBOutlet weak var accountIdLabel: UILabel!
	@IBOutlet weak var labelBackground: UIView!
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView! {
		didSet {
			loadingIndicator.isHidden = true
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func configure(account: String) {
		self.labelBackground.layer.cornerRadius = self.labelBackground.frame.size.height / 2
		self.accountIdLabel.text = account
	}
	
	func startAnimating() {
		self.loadingIndicator.isHidden = false
		self.loadingIndicator.startAnimating()
	}
	
	func stopAnimating() {
		self.loadingIndicator.isHidden = true
		self.loadingIndicator.stopAnimating()
	}
}
