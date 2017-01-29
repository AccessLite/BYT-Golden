//
//  FoaasTextField.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

enum SlideDirection {
  case up, down
}

protocol FoaasTextFieldDelegate: class {
  func foaasTextField(_ textField: FoaasTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}


// TODO: create helper function to locate textfield w/ identifier
class FoaasTextField: UIView, UITextFieldDelegate {

  internal final var textField: UITextField!
  internal final var textLabel: UILabel!
  private var textLabelPlaceholder: String!
  internal var identifier: String = ""
  internal var foaasTextFieldDelegate: FoaasTextFieldDelegate?
  
  let largeLabelFont = UIFont.Roboto.medium(size: 18.0)
  let smallLabelFont = UIFont.Roboto.medium(size: 18.0)
  
  private var labelEmptyConstraint: NSLayoutConstraint!
  private var labelFilledConstraint: NSLayoutConstraint!
  
  // MARK: - Drawing
  override func draw(_ rect: CGRect) {
    let lineWidth: CGFloat = 2.0
    
    let startPoint = CGPoint(x: 8.0, y: rect.height - lineWidth)
    let endPoint = CGPoint(x: rect.width - 8.0, y: rect.height - lineWidth)
    
    let context = UIGraphicsGetCurrentContext()
    context?.setLineWidth(2.0)
    context?.setStrokeColor(UIColor.red.cgColor)
    context?.move(to: startPoint)
    context?.addLine(to: endPoint)
    
    context?.strokePath()
  }
  
  
  // MARK: - Initialization
  convenience init(placeHolderText: String) {
    self.init(frame: CGRect.zero)
    self.backgroundColor = .clear
    self.clipsToBounds = false
    self.textLabelPlaceholder = placeHolderText
    
    self.setupViewHierarchy()
    self.configureConstraints()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  // MARK: - View Setup
  private func configureConstraints() {
    self.translatesAutoresizingMaskIntoConstraints = false
    textField.translatesAutoresizingMaskIntoConstraints = false
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    
    self.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
    
    // label left/right
    textLabel.leadingAnchor.constraint(equalTo: self.textField.leadingAnchor, constant: 2.0).isActive = true
    //    textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
    
    // label empty text state
    labelEmptyConstraint = textLabel.centerYAnchor.constraint(equalTo: self.textField.centerYAnchor, constant: -4.0)
    labelEmptyConstraint.isActive = true
    
    // label non-empty text state
    labelFilledConstraint = textLabel.bottomAnchor.constraint(equalTo: self.textField.topAnchor, constant: 0.0)
    labelFilledConstraint.isActive = false
    
    // textfield
    textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0).isActive = true
    textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12.0).isActive = true
    textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4.0).isActive = true
  }
  
  private func setupViewHierarchy() {
    textLabel = UILabel()
    textLabel.text = textLabelPlaceholder
    textLabel.font = largeLabelFont
    textLabel.textAlignment = .left
    
    textField = UITextField()
    textField.borderStyle = .none
    textField.placeholder = ""
    textField.delegate = self
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .words
    
    self.addSubview(textLabel)
    self.addSubview(textField)
    
  }
  
  private func textFieldHasText() -> Bool {
    guard
      let textFieldText = textField.text,
      !textFieldText.isEmpty
      else {
        return false
    }
    
    return true
  }
  
  // MARK: - TextField Delegate
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    slideLabel(direction: .up)
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
    guard textFieldHasText() else {
      slideLabel(direction: .down)
      return
    }
    
    slideLabel(direction: .up)
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    return self.foaasTextFieldDelegate?.foaasTextField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
  }
  
  
  // MARK: - Helpers
  private func slideLabel(direction: SlideDirection) {
    
    switch direction {
    case .up:
      self.labelFilledConstraint.isActive = true
      self.labelEmptyConstraint.isActive = false
      self.textLabel.font = smallLabelFont
      
    case .down:
      self.labelFilledConstraint.isActive = false
      self.labelEmptyConstraint.isActive = true
      self.textLabel.font = largeLabelFont
    }
    
    self.setNeedsUpdateConstraints()
    UIView.animate(withDuration: 0.2, animations: {
      self.layoutIfNeeded()
    })
    
  }
  
  
}

