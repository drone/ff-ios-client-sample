//
//  ViewController.swift
//  CFiOSExample
//
//  Created by Dusan Juranovic on 13.1.21..
//

import UIKit
import ff_ios_client_sdk

enum Accounts:String, CaseIterable {
	case Aptiv = "Aptiv"
	case Experian = "Experian"
	case Fiserv = "Fiserv"
	case Harness = "Harness"
	case PaloAltoNetworks = "Palo Alto Networks"
	
	static var allKeys: [String] {
		return Accounts.allCases.map {$0.rawValue}
	}
}
class ViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	var project: CfProject?
	var authorizedAccount = ""
	
	var evaluations: [Evaluation]? {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "CF mobile SDK Demo"
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.barStyle = .default
		self.navigationController?.navigationBar.tintColor = .black
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
	}
    
	@IBAction func envButton(_ sender: UIBarButtonItem) {
		
        let alert = UIAlertController(title: "Choose your environment", message: nil, preferredStyle: .actionSheet)
		let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
		
		alert.addAction(cancel)
		self.present(alert, animated: true, completion: nil)
	}
	
	func authorizeWith(account: String, onCompletion:@escaping(Bool)->()) {
		
        authorizedAccount = account
		
        let config = CfConfiguration.builder()
            .setStreamEnabled(true)
//            .setConfigUrl("https://config.feature-flags.uat.harness.io/api/1.0")
//            .setEventUrl("https://event.feature-flags.uat.harness.io/api/1.0")
//            .setStreamUrl("https://config.feature-flags.uat.harness.io/api/1.0/stream")
            .build()
		
        let target = CfTarget.builder().setName(account).setIdentifier(account).build()
        
		CfClient.sharedInstance.initialize(
            
            apiKey: "d92cf64f-7f00-43ce-8d30-5760d0c2bec9",
            configuration:config,
            target: target
        
        ) { [weak self] result in
			switch result {
				case .failure(let error):
					self?.showAlert(title: error.errorData.title ?? "", message: error.errorData.localizedMessage ?? "")
					onCompletion(false)
				case .success():
					onCompletion(true)
			}
		}
	}
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Accounts.allKeys.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProjectCell
		cell.configure(account:Accounts.allKeys[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! ProjectCell
		cell.startAnimating()
		self.authorizeWith(account: Accounts.allKeys[indexPath.row]) { initialized in
			DispatchQueue.main.async {
				cell.stopAnimating()
				self.performSegue(withIdentifier: SegueIdentifiers.detailSegue.rawValue, sender: self)
			}
		}
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerLabel = UILabel()
		
		headerLabel.text = "Choose your account"
		headerLabel.textAlignment = .center
		headerLabel.textColor = .white
		headerLabel.backgroundColor = UIColor(red: 61/255, green: 173/255, blue: 228/255, alpha: 1)
		return headerLabel
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == SegueIdentifiers.detailSegue.rawValue {
			let destination = segue.destination as? FeatureViewController
			destination?.title = authorizedAccount
		}
	}
}
