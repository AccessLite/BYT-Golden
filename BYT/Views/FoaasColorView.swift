//
//  FoaasColorView.swift
//  BYT
//
//  Created by Louis Tur on 2/6/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasColorView: UIView {
  private var baseUnit: CGFloat = 0.0
  internal private(set) var managedColor: UIColor = UIColor.white
  
  var colorViewWidth: CGFloat { return baseUnit }
  var colorViewHeight: CGFloat { return baseUnit / 2.0 }
  
  convenience init(baseUnit: CGFloat, managedColor: UIColor) {
    self.init(frame: CGRect.zero)
    self.baseUnit = baseUnit
    self.managedColor = managedColor
    
    self.backgroundColor = managedColor
    
    self.layer.cornerRadius = 3.0
    configureConstraints()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func configureConstraints() {
    self.translatesAutoresizingMaskIntoConstraints = false
    [ self.widthAnchor.constraint(equalToConstant: colorViewWidth),
      self.heightAnchor.constraint(equalToConstant: colorViewHeight) ].activate()
  }
  
}
