//
//  FoaasPreviewView.swift
//  BYT
//
//  Created by Louis Tur on 1/24/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

// TODO: implement delegation for textfields, make delegate protocol for use in view controller
class FoaasPreviewView: UIView {
  internal private(set) var slidingTextFields: [FoaasTextField] = []
  
  private var scrollviewBottomConstraint: NSLayoutConstraint? = nil
  private var previewTextViewHeightConstraint: NSLayoutConstraint? = nil
  private var slidingTextFieldBottomConstraint: NSLayoutConstraint? = nil
  
  
  // -------------------------------------
  // MARK: Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    registerForNotifications()
    
    setupViewHierarchy()
    configureConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  // -------------------------------------
  // MARK: - Config
  private func configureConstraints() {
    stripAutoResizingMasks(self, scrollView, contentContainerView, previewTextView, previewLabel)
    
    // we need to keep a reference to both these constraints because they will be changing later. the scrollViewBottomConstraint
    // update with the keyboard show/hiding. and the previewTextViewHeightConstraint changes with the length of the 
    // foaas operation preview text
    scrollviewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0)
    previewTextViewHeightConstraint = previewTextView.heightAnchor.constraint(equalToConstant: 0.0)
  
    [ // preview label
      previewLabel.leadingAnchor.constraint(equalTo: self.contentContainerView.leadingAnchor, constant: 16.0),
      previewLabel.topAnchor.constraint(equalTo: self.contentContainerView.topAnchor, constant: 16.0),
      
      // scroll view
      scrollView.topAnchor.constraint(equalTo: self.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      scrollviewBottomConstraint!,

      // container view 
      contentContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentContainerView.widthAnchor.constraint(equalTo: self.widthAnchor),
      
      // preview text view
      previewTextView.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 8.0),
      previewTextView.leadingAnchor.constraint(equalTo: self.contentContainerView.leadingAnchor, constant: 16.0),
      previewTextView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -32.0),
      previewTextViewHeightConstraint!,
      
      ].activate()
  }
  
  private func setupViewHierarchy() {
    self.backgroundColor = .white
    self.scrollView.backgroundColor = .yellow
    
    
    self.addSubview(scrollView)
    scrollView.addSubview(contentContainerView)
    contentContainerView.addSubview(previewLabel)
    contentContainerView.addSubview(previewTextView)
  }
  
  
  // -------------------------------------
  // MARK: - FoaasTextFields
  
  /// Creates the same number of `FoaasTextFields` as the `.count` of the `keys` parameter. Each `FoaasTextField` is given
  /// an identifier `String` with the same value as the key at that index. Each `FoaasTextField` created is added to the 
  /// `contentContainerView` and given constraints. 
  /// - Parameters:
  ///   - keys: The keys to be used to generate `FoaasTextField`
  internal func createTextFields(for keys: [String]) {
    for key in keys {
      let newSlidingTextField = FoaasTextField(placeHolderText: key)
      newSlidingTextField.identifier = key // used to later identify the textfields if needed
      slidingTextFields.append(newSlidingTextField)
      self.contentContainerView.addSubview(newSlidingTextField)
    }
    
    arrangeSlidingTextFields()
  }
  
  /// This dynamically lays out as many `FoaasTextField` as needed, based on the contents of `self.slidingTextFields`
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
        if slidingTextFields.count == 1 {
          // if there is only 1 textfield, we need to fallthrough to the "last" textfield case
          fallthrough
        }

      // last view needs to be pinned to the bottom, in addition to all of the other constraints
      case slidingTextFields.count - 1:
        textField.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -16.0).isActive = true
        if slidingTextFields.count > 1 {
          // we only have to fallthrough for more constraints if this is textField #1 or greater AND it's the last one
          fallthrough
        }
        
      // middle views need to be pinned to prior view
      default:
        textField.topAnchor.constraint(equalTo: priorTextField!.bottomAnchor, constant: 8.0).isActive = true
        textField.leadingAnchor.constraint(equalTo: priorTextField!.leadingAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: priorTextField!.widthAnchor).isActive = true
        
      }
      priorTextField = textField
    }
  }

  internal func setTextFieldsDelegate(_ delegate: FoaasTextFieldDelegate) {
    slidingTextFields.forEach { (textField) in
      textField.foaasTextFieldDelegate = delegate
    }
  }
  
  
  // -------------------------------------
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
      
      scrollviewBottomConstraint?.constant = keyboardFrame.size.height * (show ? -1 : 1)
      UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOption, animations: {
        self.layoutIfNeeded()
      }, completion: completion)
      
    }
  }
  
  
  // MARK: - Updating Text
  internal func updatehe(text: String) {
    DispatchQueue.main.async {
      self.previewTextView.text = text
      self.updateTextViewdHeight(animated: true)
    }
  }
  
  // TODO: needs testing 
  internal func updateAttributedText(text: NSMutableAttributedString) {
    DispatchQueue.main.async {
      self.previewTextView.attributedText = text
      self.updateTextViewdHeight(animated: true)
    }
  }
  
  /// See https://medium.com/@louistur/dynamic-sizing-of-uitextview-with-autolayout-6dbcfa8e5e2d#.rhnheioqn for details
  private func updateTextViewdHeight(animated: Bool) {
    let textContainterInsets = self.previewTextView.textContainerInset
    
    //Change from usedRect into usedSize because the attributed text is not responding to usedRect
    //let usedRect = self.previewTextView.layoutManager.usedRect(for: self.previewTextView.textContainer)
    
    let usedSize = self.previewTextView.contentSize
    self.previewTextViewHeightConstraint?.constant = usedSize.height + textContainterInsets.top + textContainterInsets.bottom
    
    // TODO: ensure that after typing, if additional lines are added that the textfield expands to accomodate this as well
    //    self.previewTextView.textContainer.heightTracksTextView = true
    
    if !animated { return }
    UIView.animate(withDuration: 0.2, animations: {
      self.layoutIfNeeded()
    })
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
    textView.font = UIFont.systemFont(ofSize: 32.0)
    textView.isEditable = false
    return textView
  }()
  
  internal lazy var scrollView: UIScrollView = {
    let scroll: UIScrollView = UIScrollView()
    scroll.keyboardDismissMode = .onDrag
    scroll.alwaysBounceVertical = true
    return scroll
  }()
  
  internal lazy var contentContainerView: UIView = {
    let view = UIView()
    return view
  }()
}
