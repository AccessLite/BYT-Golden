//
//  FoaasPreviewViewController.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasPrevewViewController: UIViewController, FoaasTextFieldDelegate, FoaasPrevewViewDelegate {
  
  internal private(set) var operation: FoaasOperation?
  private var pathBuilder: FoaasPathBuilder?

  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupViewHeirarchy()
    self.configureConstraints()
    
    self.foaasPreviewView.createTextFields(for: self.pathBuilder!.allKeys())
    self.foaasPreviewView.setTextFieldsDelegate(self)
    self.foaasPreviewView.delegate = self
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
  
  
  // MARK: - FoaasButtonDelegateMethods
  
    internal func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    internal func doneButtonPressed() {
        let messageAndSubtitle = self.foaasPreviewView.previewTextView.text.components(separatedBy: "\n")
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: Foaas(message: messageAndSubtitle[0], subtitle: messageAndSubtitle[1]))
        _ = navigationController?.popToRootViewController(animated: true)

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
    })
  }
  
  
  // TODO: needs live updating
  // MARK: - UITextField Delegate
  func foaasTextField(_ textField: FoaasTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//    textField.identifier == key
//    foaasPreviewView.updateLabel(text: "")
    return true
  }
  
  
  // TODO: add in delegation
  // MARK: - Lazy Inits
  internal lazy var foaasPreviewView: FoaasPreviewView = {
    let previewView = FoaasPreviewView()
    return previewView
  }()

}
