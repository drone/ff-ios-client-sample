//
//  FeatureViewController.swift
//  CFiOSExample
//
//  Created by Dusan Juranovic on 14.1.21..
//

import UIKit
import ff_ios_client_sdk

class FeatureViewController: UIViewController {
	@IBOutlet weak var collectionView: UICollectionView!
	var needHelpButton: UIButton!
	var enabledFeatures = [CDModule()]
	var availableFeatures: [FeatureCardRepresentable] = [CVModule(), CIModule(), CEModule(), CFModule()]
	
	var ceTrial: Int = 0
	var cfTrial: Int = 0
	var ciTrial: Int = 0
	var cvTrial: Int = 0
	var darkMode: Bool = false
	var topConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNeedHelpButton()
		setupLayoutFlow()
		
		CfClient.sharedInstance.registerEventsListener() { (result) in
			switch result {
				case .failure(let error):
					print(error)
				case .success(let eventType):
					switch eventType {
						case .onPolling(let evaluations):
							for eval in evaluations! {
								self.setupViewPreferences(evaluation: eval)
							}
						case .onEventListener(let evaluation):
							guard let evaluation = evaluation else {
								return
							}
							self.setupViewPreferences(evaluation: evaluation)
						case .onComplete:
							print("Stream has completed")
						case .onOpen:
							print("Stream has been opened")
						case .onMessage(let messageObj):
							print(messageObj?.event ?? "Message received")
					}
			}
		}
	}
	
	func setupLayoutFlow() {
		let minSpacing: CGFloat = 10
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		layout.itemSize = CGSize(width: self.view.bounds.width / 2 - minSpacing, height: 220)
		layout.minimumInteritemSpacing = minSpacing
		layout.minimumLineSpacing = minSpacing
		collectionView.collectionViewLayout = layout
	}
	@IBAction func getById(_ sender: Any) {
		var id = ""
		let alert = UIAlertController(title: "Get by ID", message: nil, preferredStyle: .alert)
		alert.addTextField { (textField) in
			textField.placeholder = "Enter EvaluationId"
		}
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
			id = alert.textFields![0].text!
			CfClient.sharedInstance.boolVariation(evaluationId: id) { (eval) in
				print(eval!)
			}
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	@IBAction func destroy(_ sender: Any) {
		CfClient.sharedInstance.destroy()
		self.navigationController?.popToRootViewController(animated: true)
	}
	
	func setupNeedHelpButton() {
		let helpButton = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 50))
		self.needHelpButton = helpButton
		self.needHelpButton.translatesAutoresizingMaskIntoConstraints = false
		self.needHelpButton.setAttributedTitle(NSAttributedString(string: "Need Help? ✋", attributes:
																	[NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: .bold),
																	 NSAttributedString.Key.foregroundColor : UIColor.white]), for: .normal)
		self.needHelpButton.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
		self.needHelpButton.backgroundColor = UIColor.systemGreen
		self.needHelpButton.layer.cornerRadius = 5
		self.needHelpButton.transform = self.needHelpButton.transform.rotated(by: -CGFloat.pi / 2)
		self.view.addSubview(self.needHelpButton)
		self.topConstraint = NSLayoutConstraint(item: self.needHelpButton!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 210)
		NSLayoutConstraint.activate([NSLayoutConstraint(item: self.needHelpButton!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 20),
									 self.topConstraint,
									NSLayoutConstraint(item: self.needHelpButton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50),
									NSLayoutConstraint(item: self.needHelpButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 130)])
	}
	
	func setupViewPreferences(evaluation: Evaluation) {
		let flagType = FlagType(flag: evaluation.flag)
		let value = evaluation.value

		switch flagType {
			case .HarnessAppDemoCfRibbon:
				guard let enableRibbon = value.boolValue else {return}
				updateRibbon(.Features, ribbon: enableRibbon)
				
			case .HarnessAppDemoDarkMode:
				guard let darkMode = value.boolValue else {return}
				self.darkMode = darkMode
				if darkMode {
					self.view.backgroundColor = UIColor.black
					self.navigationController?.navigationBar.barStyle = .black
					self.navigationController?.navigationBar.tintColor = .white
					self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
				} else {
					self.view.backgroundColor = UIColor(red: 248/255, green: 249/255, blue: 250/255, alpha: 1)
					self.navigationController?.navigationBar.barStyle = .default
					self.navigationController?.navigationBar.tintColor = .black
					self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
				}
				
			case .HarnessAppDemoCeTrialLimit:
				guard let int = value.intValue else {return}
				ceTrial = int
				updateTrial(.Efficiency, trial: int)
				
			case .HarnessAppDemoCfTrialLimit:
				guard let int = value.intValue else {return}
				cfTrial = int
				updateTrial(.Features, trial: int)
				
			case .HarnessAppDemoCiTrialLimit:
				guard let int = value.intValue else {return}
				ciTrial = int
				updateTrial(.Integration, trial: int)
				
			case .HarnessAppDemoCvTrialLimit:
				guard let int = value.intValue else {return}
				cvTrial = int
				updateTrial(.Verification, trial: int)
				
			case .HarnessAppDemoEnableCeModule:
				guard let enabled = value.boolValue else {return}
				let card = CEModule()
				card.featureTrialPeriod = ceTrial
				if enabled {
					self.insertCard(card)
				} else {
					self.removeCard(card)
				}
			case .HarnessAppDemoEnableCfModule:
				guard let enabled = value.boolValue else {return}
				let card = CFModule()
				card.featureTrialPeriod = cfTrial
				if enabled {
					self.insertCard(card)
				} else {
					self.removeCard(card)
				}
			case .HarnessAppDemoEnableCiModule:
				guard let enabled = value.boolValue else {return}
				let card = CIModule()
				card.featureTrialPeriod = ciTrial
				if enabled {
					self.insertCard(card)
				} else {
					self.removeCard(card)
				}
			case .HarnessAppDemoEnableCvModule:
				guard let enabled = value.boolValue else {return}
				let card = CVModule()
				card.featureTrialPeriod = cvTrial
				if enabled {
					self.insertCard(card)
				} else {
					self.removeCard(card)
				}
			case .HarnessAppDemoEnableGlobalHelp:
				guard let enable = value.boolValue else {return}
				self.needHelpButton.isHidden = !enable
			default:
				break
		}
		self.reloadCollection()
	}
	
	func insertCard(_ card: FeatureCardRepresentable) {
		for var c in availableFeatures {
			if c.featureName == card.featureName {
				c.available = true
			}
		}
	}
	func removeCard(_ card: FeatureCardRepresentable) {
		for var c in availableFeatures {
			if c.featureName == card.featureName {
				c.available = false
			}
		}
	}
	
	func updateTrial(_ card: FeatureName, trial:Int) {
		for var c in availableFeatures {
			if c.featureName == card {
				c.featureTrialPeriod = trial
			}
		}
	}
	func updateRibbon(_ card: FeatureName, ribbon:Bool) {
		for var c in availableFeatures {
			if c.featureName == card {
				c.hasRibbon = ribbon
			}
		}
	}
	
	private func reloadCollection() {
		self.collectionView.reloadData()
		self.collectionView.collectionViewLayout.invalidateLayout()
		self.collectionView.layoutSubviews()
	}
	
	enum FlagType {
		case HarnessAppDemoCfRibbon
		case HarnessAppDemoDarkMode
		case HarnessAppDemoCeTrialLimit
		case HarnessAppDemoCfTrialLimit
		case HarnessAppDemoCiTrialLimit
		case HarnessAppDemoCvTrialLimit
		case HarnessAppDemoEnableCeModule
		case HarnessAppDemoEnableCfModule
		case HarnessAppDemoEnableCiModule
		case HarnessAppDemoEnableCvModule
		case HarnessAppDemoEnableGlobalHelp
		case NoFlag
		
		init(flag: String) {
			switch flag {
				case "harnessappdemocfribbon": 		   self = .HarnessAppDemoCfRibbon
				case "harnessappdemodarkmode": 		   self = .HarnessAppDemoDarkMode
				case "harnessappdemocetriallimit": 	   self = .HarnessAppDemoCeTrialLimit
				case "harnessappdemocftriallimit": 	   self = .HarnessAppDemoCfTrialLimit
				case "harnessappdemocitriallimit": 	   self = .HarnessAppDemoCiTrialLimit
				case "harnessappdemocvtriallimit": 	   self = .HarnessAppDemoCvTrialLimit
				case "harnessappdemoenablecemodule":   self = .HarnessAppDemoEnableCeModule
				case "harnessappdemoenablecfmodule":   self = .HarnessAppDemoEnableCfModule
				case "harnessappdemoenablecimodule":   self = .HarnessAppDemoEnableCiModule
				case "harnessappdemoenablecvmodule":   self = .HarnessAppDemoEnableCvModule
				case "harnessappdemoenableglobalhelp": self = .HarnessAppDemoEnableGlobalHelp
				default:							   self = .NoFlag
			}
		}
	}
	
	enum FlagValue {
		case color(String)
		case bool(Bool)
		case int(Int)

		var colorValue: UIColor {
			switch self {
				case .color(let color):
					switch color.lowercased().replacingOccurrences(of: "\"", with: "") {
						case "red": return UIColor.red
						case "green": return UIColor.green
						case "blue": return UIColor.blue
						default: return UIColor.gray
					}
				case .bool(_): return UIColor.gray
				case .int(_): return UIColor.gray
			}
		}
	}
}

extension FeatureViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if section == 0 {
			return enabledFeatures.count
		}
		return availableFeatures.filter{$0.available}.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featureCell", for: indexPath) as! FeatureCell
		cell.darkMode = self.darkMode
		if indexPath.section == 0 {
			cell.configure(feature: enabledFeatures[indexPath.row])
		} else {
			cell.configure(feature: availableFeatures.filter{$0.available}[indexPath.row])
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
			case UICollectionView.elementKindSectionHeader:
				let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! CollectionHeaderView
				headerView.configureFor(self.darkMode)
				if indexPath.section == 0 {
					headerView.headerTitle.text = "Modules Enabled"
				} else {
					headerView.headerTitle.text = "Enable More Modules"
				}
				return headerView
			default: return UICollectionReusableView()
		}
	}
}

extension FeatureViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if indexPath.section == 0 {
			self.topConstraint.isActive = false
			self.topConstraint = NSLayoutConstraint(item: self.needHelpButton!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: cell.center.y)
			NSLayoutConstraint.activate([topConstraint])
		}
	}
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//		return CGSize(width: self.collectionView.frame.size.width/2 - 20, height: self.collectionView.frame.size.width/2 + 20)
//	}
}
