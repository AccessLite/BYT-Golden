//
//  FoaasPreviewViewController.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasPrevewViewController: UIViewController, UITextFieldDelegate {
  
  internal private(set) var operation: FoaasOperation?
  private var pathBuilder: FoaasPathBuilder?

  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupViewHeirarchy()
    self.configureConstraints()
    
    self.foaasPreviewView.createTextFields(for: self.pathBuilder!.allKeys())
  }
  
  
  // MARK: - View Setup
  internal func setupViewHeirarchy() {
    self.view.addSubview(foaasPreviewView)
  }
  
  internal func configureConstraints() {
    
    let _ = [
      foaasPreviewView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
      foaasPreviewView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0),
      foaasPreviewView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0),
      foaasPreviewView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
      ].map { $0.isActive = true }
    
  }
  
  
  // TODO: test if working in preview view
  // MARK: - Keyboard Notification
//  private func registerForNotifications() {
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//    
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//  }
//  
//  deinit {
//    NotificationCenter.default.removeObserver(self)
//  }
//  
//  internal func keyboardDidAppear(notification: Notification) {
//    self.shouldShowKeyboard(show: true, notification: notification, completion: nil)
//  }
//  
//  internal func keyboardWillDisappear(notification: Notification) {
//    self.shouldShowKeyboard(show: false, notification: notification, completion: nil)
//  }
//  
//  private func shouldShowKeyboard(show: Bool, notification: Notification, completion: ((Bool) -> Void)? ) {
//    if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect,
//      let animationNumber = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
//      let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
//      let animationOption = UIViewAnimationOptions(rawValue: animationNumber.uintValue)
//      
//      scrollViewBottomConstraint.constant = keyboardFrame.size.height * (show ? 1 : -1)
//      UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOption, animations: {
//        self.view.layoutIfNeeded()
//      }, completion: completion)
//      
//    }
//  }
  
  
  // TODO: make sure working in previewView
  private func updateTextFieldHeight(animated: Bool) {
//    let textContainterInsets = self.previewTextView.textContainerInset
//    let usedRect = self.previewTextView.layoutManager.usedRect(for: self.previewTextView.textContainer)
//    
//    self.previewTextViewHeightConstraint.constant = usedRect.size.height + textContainterInsets.top + textContainterInsets.bottom
//    // TODO: ensure that after typing, if additional lines are added that the textfield expands to accomodate this as well
//    //    self.previewTextView.textContainer.heightTracksTextView = true
//    
//    if !animated { return }
//    UIView.animate(withDuration: 0.2, animations: {
//      self.view.layoutIfNeeded()
//    })
  }
  
  
  // MARK: - Actions
  @IBAction func didPressDone(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  // MARK: - Other
  internal func set(operation: FoaasOperation?) {
    guard let validOp = operation else { return }
    
    self.operation = validOp
    self.pathBuilder = FoaasPathBuilder(operation: validOp)
    
    self.request(operation: validOp)
  }
  
  internal func request(operation: FoaasOperation) {
    guard
      let validPathBulder = self.pathBuilder,
      let url = URL(string: validPathBulder.build())
      else {
        return
    }
    
    FoaasAPIManager.getFoaas(url: url, completion: { (foaas: Foaas?) in
      guard let validFoaas = foaas else {
        return
      }
      
      self.foaasPreviewView.updateLabel(text: validFoaas.message + "\n" + validFoaas.subtitle)
      
//      DispatchQueue.main.async {
        // TODO update text, update textfield size
//        self.previewTextView.text = validFoaas.message + "\n" + validFoaas.subtitle
//        self.updateTextFieldHeight(animated: true)
//      }
    })
  }
  
  
  // MARK: - UITextField Delegate
  func textFieldDidEndEditing(_ textField: UITextField) {
    
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    return true
  }
  
  
  // TODO: add in delegation
  // MARK: - Lazy Inits
  internal lazy var foaasPreviewView: FoaasPreviewView = {
    let previewView = FoaasPreviewView()
    return previewView
  }()

}
