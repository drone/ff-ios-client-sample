//
//  FeatureCard.swift
//  CFiOSExample
//
//  Created by Dusan Juranovic on 15.2.21..
//

import Foundation
import UIKit

protocol FeatureCardRepresentable {
	var featureImageName: String {get set}
	var featureName: FeatureName {get set}
	var featureDescription: String {get set}
	var featureTrialPeriod: Int? {get set}
	var enabled: Bool {get set}
	var available: Bool {get set}
	var hasRibbon: Bool {get set}
}

enum FeatureName: String {
	case Delivery
	case Verification
	case Integration
	case Features
	case Efficiency
}

class CDModule: FeatureCardRepresentable {
	var featureImageName: String
	var featureName: FeatureName
	var featureDescription: String
	var featureTrialPeriod: Int?
	var enabled: Bool
	var available: Bool
	var hasRibbon: Bool
	
	init() {
		self.featureImageName = "cd"
		self.featureName = .Delivery
		self.featureDescription = ""
		self.featureTrialPeriod = 0
		self.enabled = true
		self.available = true
		self.hasRibbon = false
	}
}

class CVModule: FeatureCardRepresentable {
	var featureImageName: String
	var featureName: FeatureName
	var featureDescription: String
	var featureTrialPeriod: Int?
	var enabled: Bool
	var available: Bool
	var hasRibbon: Bool
	
	init() {
		self.featureImageName = "cv"
		self.featureName = .Verification
		self.featureDescription = "Deploy in peace, verify activities that take place in the system. Identify risk early."
		self.featureTrialPeriod = 0
		self.enabled = false
		self.available = false
		self.hasRibbon = false
	}
}

class CIModule: FeatureCardRepresentable {
	var featureImageName: String
	var featureName: FeatureName
	var featureDescription: String
	var featureTrialPeriod: Int?
	var enabled: Bool
	var available: Bool
	var hasRibbon: Bool
	
	init() {
		self.featureImageName = "ci"
		self.featureName = .Integration
		self.featureDescription = "Commit, build, and test your code at a whole new level."
		self.featureTrialPeriod = 0
		self.enabled = false
		self.available = false
		self.hasRibbon = false
	}
}

class CEModule: FeatureCardRepresentable {
	var featureImageName: String
	var featureName: FeatureName
	var featureDescription: String
	var featureTrialPeriod: Int?
	var enabled: Bool
	var available: Bool
	var hasRibbon: Bool
	
	init() {
		self.featureImageName = "ce"
		self.featureName = .Efficiency
		self.featureDescription = "Efficiency Spot and quickly debug inefficiencies and optimize them to reduce costs."
		self.featureTrialPeriod = 0
		self.enabled = false
		self.available = false
		self.hasRibbon = false
	}
}

class CFModule: FeatureCardRepresentable {
	var featureImageName: String
	var featureName: FeatureName
	var featureDescription: String
	var featureTrialPeriod: Int?
	var enabled: Bool
	var available: Bool
	var hasRibbon: Bool
	
	init() {
		self.featureImageName = "cf"
		self.featureName = .Features
		self.featureDescription = "Decouple release from deployment and rollout features safely and quickly."
		self.featureTrialPeriod = 0
		self.enabled = false
		self.available = false
		self.hasRibbon = false
	}
}
