//
//  UIViewController+Alert.swift
//  ff-ios-client-sdk
//
//  Created by Dusan Juranovic on 15.1.21..
//

import UIKit

extension UIViewController {
	func showAlert(title: String, message: String) {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(okButton)
			self.present(alert, animated: true, completion: nil)
		}
	}
}
