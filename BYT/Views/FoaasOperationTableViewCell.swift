//
//  FoaasOperationTableViewCell.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasOperationsTableViewCell: UITableViewCell {
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupViewHierarchy()
    configureConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  // MARK: - Setup
  private func configureConstraints() {
    stripAutoResizingMasks(operationNameLabel)
    
    [ self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64.0),
      self.operationNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
      self.operationNameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor) ].activate()
  }
  
  private func setupViewHierarchy() {
    self.contentView.addSubview(operationNameLabel)
  }
  
  
  // MARK: Lazy Inits
  internal lazy var operationNameLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 28.0)
    return label
  }()
  
}
