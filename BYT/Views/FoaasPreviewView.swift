//
//  FoaasPreviewView.swift
//  BYT
//
//  Created by Louis Tur on 1/24/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit


class FoaasPreviewView: UIView {
  internal private(set) var slidingTextFields: [FoaasTextField] = []
  
  private var scrollviewBottomConstraint: NSLayoutConstraint? = nil
  private var previewTextViewHeightConstraint: NSLayoutConstraint? = nil
  private var slidingTextFieldBottomConstraint: NSLayoutConstraint? = nil
  private var scrollViewHeightAnchor: (min: NSLayoutConstraint, max:NSLayoutConstraint)? = nil
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    registerForNotifications()
    
    setupViewHierarchy()
    configureConstraints()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  // MARK: - Config
  private func configureConstraints() {
    stripAutoResizingMasks(self, scrollView, previewTextView, previewLabel)
    
    scrollviewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    previewTextViewHeightConstraint = previewTextView.heightAnchor.constraint(equalToConstant: 200.0)
    
    let scrollMin = scrollView.heightAnchor.constraint(equalTo: self.heightAnchor)
    let scrollMax = scrollView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor)
    scrollMin.priority = 750.0
    scrollMax.priority = 1000.0
    scrollViewHeightAnchor = (scrollMin, scrollMax)
    
    let _ = [
      // preview label
      previewLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 16.0),
      previewLabel.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 16.0),
      
      // scroll view
      scrollView.topAnchor.constraint(equalTo: self.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      scrollviewBottomConstraint!,
      scrollView.widthAnchor.constraint(equalTo: self.widthAnchor),
//      scrollView.heightAnchor.constraint(equalTo: self.heightAnchor),
      scrollViewHeightAnchor!.min,
      scrollViewHeightAnchor!.max,
      
      // preview text view
      previewTextView.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 8.0),
      previewTextView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 16.0),
      previewTextView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -32.0),
      previewTextViewHeightConstraint!,
      
      ].map { $0.isActive = true }
    
  }
  
  private func setupViewHierarchy() {
    self.backgroundColor = .white
    self.scrollView.backgroundColor = .yellow
    
    
    self.addSubview(scrollView)
    scrollView.addSubview(previewLabel)
    scrollView.addSubview(previewTextView)
  }
  
  
  // MARK: - FoaasTextFields
  internal func createTextFields(for keys: [String]) {
    for key in keys {
      let newSlidingTextField = FoaasTextField(placeHolderText: key)
      newSlidingTextField.identifier = key
      slidingTextFields.append(newSlidingTextField)
      self.scrollView.addSubview(newSlidingTextField)
    }
    
    arrangeSlidingTextFields()
  }
  
  private func arrangeSlidingTextFields() {
    guard self.slidingTextFields.count != 0 else { return }
    
    var priorTextField: FoaasTextField?
    for (idx, textField) in slidingTextFields.enumerated() {
      
      switch idx {
      // first view needs to be pinned to preview view
      case 0:
        textField.topAnchor.constraint(equalTo: previewTextView.bottomAnchor, constant: 8.0).isActive = true
        textField.leadingAnchor.constraint(equalTo: previewTextView.leadingAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: previewTextView.widthAnchor).isActive = true
        
      // last view needs to be pinned to the bottom, in addition to all of the other constraints
      case slidingTextFields.count - 1:
        textField.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: 0.0).isActive = true
        fallthrough
        
      // middle views need to be pinned to prior view
      default:
        textField.topAnchor.constraint(equalTo: priorTextField!.bottomAnchor, constant: 8.0).isActive = true
        textField.leadingAnchor.constraint(equalTo: priorTextField!.leadingAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: priorTextField!.widthAnchor).isActive = true
        
      }
      priorTextField = textField
    }
  }
  
  private func updateTextViewdHeight(animated: Bool) {
    let textContainterInsets = self.previewTextView.textContainerInset
    let usedRect = self.previewTextView.layoutManager.usedRect(for: self.previewTextView.textContainer)
    
    self.previewTextViewHeightConstraint?.constant = usedRect.size.height + textContainterInsets.top + textContainterInsets.bottom
    // TODO: ensure that after typing, if additional lines are added that the textfield expands to accomodate this as well
    //    self.previewTextView.textContainer.heightTracksTextView = true
    
    if !animated { return }
    UIView.animate(withDuration: 0.2, animations: {
      self.layoutIfNeeded()
    })
  }
  
  private func updateTextViewHeightClosure(animated: Bool = true) -> ((Bool) -> Void) {
    return { animated in
      let textContainterInsets = self.previewTextView.textContainerInset
      let usedRect = self.previewTextView.layoutManager.usedRect(for: self.previewTextView.textContainer)
      
      self.previewTextViewHeightConstraint?.constant = usedRect.size.height + textContainterInsets.top + textContainterInsets.bottom
      // TODO: ensure that after typing, if additional lines are added that the textfield expands to accomodate this as well
      //    self.previewTextView.textContainer.heightTracksTextView = true
      
      if !animated { return }
      UIView.animate(withDuration: 0.001, animations: {
        self.previewTextView.layoutIfNeeded()
      })

    }
  }
  
  
  // MARK: - Keyboard Notification
  private func registerForNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  internal func keyboardDidAppear(notification: Notification) {
    self.shouldShowKeyboard(show: true, notification: notification, completion: nil)
  }
  
  internal func keyboardWillDisappear(notification: Notification) {
    self.shouldShowKeyboard(show: false, notification: notification, completion: nil)
  }
  
  private func shouldShowKeyboard(show: Bool, notification: Notification, completion: ((Bool) -> Void)? ) {
    if let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect,
      let animationNumber = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
      let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
      let animationOption = UIViewAnimationOptions(rawValue: animationNumber.uintValue)
      
      scrollviewBottomConstraint?.constant = keyboardFrame.size.height * (show ? 1 : -1)
      UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOption, animations: {
        self.layoutIfNeeded()
      }, completion: completion)
      
    }
  }
  
  
  // MARK: - Updating Labels
  internal func updateLabel(text: String) {
    DispatchQueue.main.async {
      self.previewTextView.text = text
      self.updateTextViewdHeight(animated: true)
    }
  }
  
  
  // MARK: - Lazy Inits
  internal lazy var previewLabel: UILabel = {
    let label: UILabel = UILabel()
    label.text = "Preview"
    label.font = UIFont.systemFont(ofSize: 18.0)
    return label
  }()
  
  internal lazy var previewTextView: UITextView = {
    let textView: UITextView = UITextView()
    
    return textView
  }()
  
  internal lazy var scrollView: UIScrollView = {
    let scroll: UIScrollView = UIScrollView()
    scroll.keyboardDismissMode = .onDrag
    scroll.alwaysBounceVertical = true
    return scroll
  }()
  
}
