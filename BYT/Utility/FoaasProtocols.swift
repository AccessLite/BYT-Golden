//
//  Protocols.swift
//  AC3.2-BiteYourThumb
//
//  Created by Louis Tur on 11/20/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation
import UIKit

protocol JSONConvertible {
  init?(json: [String : AnyObject])
  func toJson() -> [String : AnyObject]
}

protocol DataConvertible {
  init?(data: Data)
  func toData() throws -> Data
}

protocol FoaasSettingMenuDelegate {
    func colorSwitcherScrollViewScrolled()
    func profanitfySwitchChanged()
    func twitterButtonTapped()
    func facebookButtonTapped()
    func camerarollButtonTapped()
    func shareButtonTapped()
    func uploadData()
}

protocol ColorSchemeDelegate {
    func colorSchemeDidChange()
}

func stripAutoResizingMasks(_ views: [UIView]) {
  let _ = views.map{ $0.translatesAutoresizingMaskIntoConstraints = false }
}

func stripAutoResizingMasks(_ views: UIView...) {
  stripAutoResizingMasks(views)
}

extension Array where Element: NSLayoutConstraint {
  func activate() {
    let _ = self.map{ $0.isActive = true}
  }
}

extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach{ self.addSubview($0) }
  }
}

