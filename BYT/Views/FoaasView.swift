//
//  FoaasView.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

protocol FoaasViewDelegate: class {
  func didTapActionButton()
}

class FoaasView: UIView {
  internal var delegate: FoaasViewDelegate?
  
  // MARK: - Setup
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setupViewHierarchy()
    self.configureConstraints()
  }
  
  internal func setupViewHierarchy() {
    self.addSubview(resizingView)
    self.addSubview(addButton)
    resizingView.addSubview(textField)
    
    stripAutoResizingMasks(self, resizingView, textField, addButton)
    self.backgroundColor = .yellow
    
    self.addButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchDown)
  }
  
  internal func configureConstraints() {
    let resizingViewConstraints = [
      resizingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      resizingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      resizingView.topAnchor.constraint(equalTo: self.topAnchor),
      resizingView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -48.0)
    ]
    
    let fieldConstraints = [
      textField.leadingAnchor.constraint(equalTo: resizingView.leadingAnchor),
      textField.topAnchor.constraint(equalTo: resizingView.topAnchor),
      ]
    
    let buttonConstraints = [
      addButton.widthAnchor.constraint(equalToConstant: 54.0),
      addButton.heightAnchor.constraint(equalToConstant: 54.0),
      addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48.0),
      addButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -48.0)
    ]
    
    let _ = [resizingViewConstraints, fieldConstraints, buttonConstraints].map{ $0.map{ $0.isActive = true } }
  }
  
  override func layoutSubviews() {
    // TOOD: adjust sizing
    self.configureConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
  
  // MARK: - Actions
  internal func didTapButton(sender: UIButton) {
    let newTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    let originalTransform = sender.imageView!.transform
    
    UIView.animate(withDuration: 0.1, animations: {
      sender.layer.transform = CATransform3DMakeAffineTransform(newTransform)
    }, completion: { (complete) in
      sender.layer.transform = CATransform3DMakeAffineTransform(originalTransform)
    })
    
    self.delegate?.didTapActionButton()
  }
  
  
  // MARK: - Lazy Inits
  internal lazy var resizingView: UIView = {
    let view: UIView = UIView()
    view.backgroundColor = .red
    return view
  }()
  
  // TODO: fix this textfield to properly expand/shrink
  internal lazy var textField: UITextField = {
    let textField = UITextField(frame: CGRect.zero)
    textField.font = UIFont.systemFont(ofSize: 64.0)
    textField.textColor = .black
    textField.textAlignment = .left
    textField.isUserInteractionEnabled = false
    textField.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    return textField
  }()
  
  internal lazy var addButton: UIButton = {
    let button: UIButton = UIButton(type: .custom)
    button.setBackgroundImage(UIImage(named: "add_button")!, for: .normal)
    return button
  }()
}
