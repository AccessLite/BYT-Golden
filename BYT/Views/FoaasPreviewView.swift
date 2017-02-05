//
//  FoaasPreviewView.swift
//  BYT
//
//  Created by Louis Tur on 1/24/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

// TODO: implement delegation for textfields, make delegate protocol for use in view controller
protocol FoaasPrevewViewDelegate {
    func backButtonPressed()
    func doneButtonPressed()
}

class FoaasPreviewView: UIView {
  internal private(set) var slidingTextFields: [FoaasTextField] = []
  
    internal var delegate: FoaasPrevewViewDelegate?
    
  private var scrollviewBottomConstraint: NSLayoutConstraint? = nil
  private var previewTextViewHeightConstraint: NSLayoutConstraint? = nil
  private var slidingTextFieldBottomConstraint: NSLayoutConstraint? = nil
  private var newTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
  
  
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
    stripAutoResizingMasks(self, scrollView, contentContainerView, previewTextView/*, previewLabel*/, backButton, doneButton)
    
    // we need to keep a reference to both these constraints because they will be changing later. the scrollViewBottomConstraint
    // update with the keyboard show/hiding. and the previewTextViewHeightConstraint changes with the length of the 
    // foaas operation preview text
    scrollviewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0)
    previewTextViewHeightConstraint = previewTextView.heightAnchor.constraint(equalToConstant: 0.0)
  
    [// scroll view
        scrollView.topAnchor.constraint(equalTo: self.topAnchor),
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        scrollviewBottomConstraint!,

      // container view 
      contentContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -72),
      contentContainerView.widthAnchor.constraint(equalTo: self.widthAnchor),
      
      // preview text view
      previewTextView.topAnchor.constraint(equalTo: self.contentContainerView.topAnchor, constant: 24.0),
      previewTextView.leadingAnchor.constraint(equalTo: self.contentContainerView.leadingAnchor, constant: 16.0),
      previewTextView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -32.0),
      previewTextViewHeightConstraint!,
      
    //buttons
      backButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -48),
        backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 48),
        backButton.heightAnchor.constraint(equalToConstant: 54),
        backButton.widthAnchor.constraint(equalToConstant: 54),
        
        doneButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -48),
        doneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48),
        doneButton.heightAnchor.constraint(equalToConstant: 54),
        doneButton.widthAnchor.constraint(equalToConstant: 54)
      ].activate()
  }
  
  private func setupViewHierarchy() {
    self.backgroundColor = .white
    self.scrollView.backgroundColor = ColorManager.shared.currentColorScheme.primary
    self.previewTextView.backgroundColor = ColorManager.shared.currentColorScheme.primary
    
    self.addSubview(scrollView)
    scrollView.addSubview(contentContainerView)
    scrollView.addSubviews([backButton, doneButton])
    
    contentContainerView.addSubview(previewTextView)
    scrollView.accessibilityIdentifier = "ScrollView"
    contentContainerView.accessibilityIdentifier = "ContentContainerView"
    previewTextView.accessibilityIdentifier = "PreviewTextView"
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
            
            //PM spec indicates the placeholder text should be all caps.
            let newSlidingTextField = FoaasTextField(placeHolderText: key.uppercased())
            
            //I only want the placeholder text to have this alpha value in order to mimic the PM spec as accurately as the Sketch displays.
            newSlidingTextField.textLabel.alpha = 0.34
            
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
  internal func updateLabel(text: String) {
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
    let textContainer = self.previewTextView.textContainer
    
    // ensureLayout must be called for the bounding rect of attributed text to be properly accounted for
    self.previewTextView.layoutManager.ensureLayout(for: textContainer)
    let usedRect = self.previewTextView.layoutManager.usedRect(for: textContainer)

    self.previewTextViewHeightConstraint?.constant = usedRect.height + textContainterInsets.top + textContainterInsets.bottom

    if !animated { return }
    UIView.animate(withDuration: 0.2, animations: {
      self.layoutIfNeeded()
    })
  }
  
  // MARK: - Lazy Inits
  
  internal lazy var previewTextView: UITextView = {
    let textView: UITextView = UITextView()
    
    //updating font and color according to PM notes
    textView.font = UIFont.Roboto.light(size: 24.0)
    textView.textColor = .white
    textView.alpha = 1.0
    
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
    
    internal lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(doneButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        button.setImage(UIImage(named: "checkmark_symbol")!, for: .normal)
        button.backgroundColor = ColorManager.shared.currentColorScheme.accent
        button.layer.cornerRadius = 26
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 5
        button.clipsToBounds = false
        
        return button
    }()
    
    internal lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(backButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        button.setImage(UIImage(named: "arrow_symbol")!, for: .normal)
        button.backgroundColor = ColorManager.shared.currentColorScheme.accent
        button.layer.cornerRadius = 26
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 5
        button.clipsToBounds = false
        return button
    }()
    
    //MARK: Button Actions
    internal func backButtonClicked(sender: UIButton) {
        let originalTransform = sender.imageView!.transform
        
        UIView.animate(withDuration: 0.1, animations: {
            sender.layer.transform = CATransform3DMakeAffineTransform(self.newTransform)
        }, completion: { (complete) in
            sender.layer.transform = CATransform3DMakeAffineTransform(originalTransform)
            self.delegate?.backButtonPressed()
        })
    }
    
    internal func doneButtonClicked(sender: UIButton) {
        let originalTransform = sender.imageView!.transform
        
        
        
        UIView.animate(withDuration: 0.1, animations: {
            sender.layer.transform = CATransform3DMakeAffineTransform(self.newTransform)
        }, completion: { (complete) in
            sender.layer.transform = CATransform3DMakeAffineTransform(originalTransform)
            self.delegate?.doneButtonPressed()
        })

    }
    
}
