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

enum Underlined {
  case yes, no
}

protocol FoaasTextFieldDelegate: class {
    func foaasTextField(_ textField: FoaasTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func foaasTextFieldShouldReturn(_ textField: FoaasTextField) -> Bool
    func foaasTextFieldDidEndEditing(_ textField: FoaasTextField)
}


// TODO: create helper function to locate textfield w/ identifier
class FoaasTextField: UIView, UITextFieldDelegate {

  internal final var textField: UITextField!
  internal final var textLabel: UILabel!
  private var textLabelPlaceholder: String!
  internal var identifier: String = ""
  
  internal weak var foaasTextFieldDelegate: FoaasTextFieldDelegate?
  
  let largeLabelFont = UIFont.Roboto.medium(size: 18.0)
  let smallLabelFont = UIFont.Roboto.medium(size: 14.0)
  
  private var labelEmptyConstraint: NSLayoutConstraint!
  private var labelFilledConstraint: NSLayoutConstraint!
  private var animatedTextFieldLineTrailingConstraint: NSLayoutConstraint!
  private var animatedTextFieldLine: UIView = {
    let view = UIView()
    view.backgroundColor = ColorManager.shared.currentColorScheme.accent
    return view
  }()
  
  // MARK: - Drawing
  override func draw(_ rect: CGRect) {
    let lineWidth: CGFloat = 2.0
    
    let startPoint = CGPoint(x: 8.0, y: rect.height - lineWidth)
    let endPoint = CGPoint(x: rect.width - 8.0, y: rect.height - lineWidth)
    
    let context = UIGraphicsGetCurrentContext()
    context?.setLineWidth(2.0)
    
    //PM spec appears to show that the stroke color is white
    context?.setStrokeColor(UIColor.white.cgColor)
    
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
    
    //PM spec appears to show the textField "line" with a brighter white. I am removing the alpha value from here and applying it only to the placeholderText
    
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
    animatedTextFieldLine.translatesAutoresizingMaskIntoConstraints = false
    
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
    
    // animated line 
    animatedTextFieldLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0).isActive = true
    animatedTextFieldLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    animatedTextFieldLine.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
    self.animatedTextFieldLineTrailingConstraint = animatedTextFieldLine.trailingAnchor.constraint(equalTo: self.leadingAnchor)
    self.animatedTextFieldLineTrailingConstraint.isActive = true
  }
  
  private func setupViewHierarchy() {
    textLabel = UILabel()
    textLabel.text = textLabelPlaceholder
    textLabel.textColor = UIColor.white
    textLabel.font = largeLabelFont
    textLabel.textAlignment = .left
    
    textField = UITextField()
    textField.borderStyle = .none
    textField.placeholder = ""
    textField.delegate = self
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .words
    textField.textColor = UIColor.white
    textField.font = UIFont.Roboto.medium(size: 18.0)
    
    self.addSubview(textLabel)
    self.addSubview(textField)
    self.addSubview(animatedTextFieldLine)
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
    animateUnderline(.yes)
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
    animateUnderline(.no)
    guard textFieldHasText() else {
      slideLabel(direction: .down)
      return
    }
    
    slideLabel(direction: .up)
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return self.foaasTextFieldDelegate?.foaasTextField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
  }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        return self.foaasTextFieldDelegate?.foaasTextFieldShouldReturn(self) ?? true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.foaasTextFieldDelegate?.foaasTextFieldDidEndEditing(self)
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
  
  // MARK: - Line Animations
  private func animateUnderline(_ underlined: Underlined) {
    switch underlined {
    case .yes:
      self.removeConstraint(self.animatedTextFieldLineTrailingConstraint)
      self.animatedTextFieldLineTrailingConstraint = animatedTextFieldLine.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0)
      self.animatedTextFieldLineTrailingConstraint.isActive = true
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0.0, options: [], animations: {
        self.layoutIfNeeded()
      }, completion: nil)
      
    case .no:
      self.removeConstraint(self.animatedTextFieldLineTrailingConstraint)
      self.animatedTextFieldLineTrailingConstraint = animatedTextFieldLine.trailingAnchor.constraint(equalTo: self.leadingAnchor)
      self.animatedTextFieldLineTrailingConstraint.isActive = true
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.175, delay: 0.0, options: [], animations: {
        self.layoutIfNeeded()
      }, completion: nil)
      
    }
  }
  
}

