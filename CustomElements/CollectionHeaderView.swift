//
//  CollectionHeaderView.swift
//  CFiOSExample
//
//  Created by Dusan Juranovic on 15.2.21..
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
	@IBOutlet weak var headerTitle: UILabel!
	
	func configureFor(_ darkMode: Bool) {
		if darkMode {
			headerTitle.textColor = UIColor.white
		} else {
			headerTitle.textColor = UIColor.black
		}
	}
}
