//
//  FoaasViewController.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasViewController: UIViewController, FoaasViewDelegate {
  
  let foaasView: FoaasView = FoaasView(frame: CGRect.zero)
  // TODO: Settings view
  
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.foaasView.delegate = self
    
    setupViewHierarchy()
    configureConstraints()
    addGesturesAndActions()
    registerForNotifications()
    
    makeRequest()
  }
  
  
  // MARK: - Setup
  private func configureConstraints() {
    let _ = [
      foaasView.topAnchor.constraint(equalTo: self.view.topAnchor),
      foaasView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      foaasView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      foaasView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
      ].map{ $0.isActive = true }
  }
  
  private func setupViewHierarchy() {
    self.view.backgroundColor = .white
    self.view.addSubview(foaasView)
  }
  
  private func addGesturesAndActions() {
    let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(toggleMenu(sender:)))
    swipeUpGesture.direction = .up
    foaasView.addGestureRecognizer(swipeUpGesture)
    
    let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(toggleMenu(sender:)))
    swipeDownGesture.direction = .down
    foaasView.addGestureRecognizer(swipeDownGesture)
  }
  
  
  // MARK: - Notifications
  private func registerForNotifications() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
  }
  
  internal func updateFoaas(sender: Any) {
    // TODO
  }
  
  
  // MARK: - Updating Foaas
  // TODO: replace this
  internal func makeRequest() {
    FoaasAPIManager.getFoaas { (foaas: Foaas?) in
      
      if foaas != nil {
        //        self.foaasLabel.alpha = 0.0
        
        DispatchQueue.main.async {
          self.foaasView.textField.text = foaas!.description.lowercased()
          
          UIView.animate(withDuration: 0.25, animations: {
            //            self.foaasLabel.alpha = 1.0
          })
        }
      }
    }
  }
  
  
  // MARK: - View Delegate
  func didTapActionButton() {
    guard let navVC = self.navigationController else { return }
    
    let dtvc = FoaasOperationsTableViewController()
    navVC.pushViewController(dtvc, animated: true)
  }
  
  
  // MARK: - Animating Menu
  internal func toggleMenu(sender: UISwipeGestureRecognizer) {
    switch sender.direction {
    case UISwipeGestureRecognizerDirection.up:
      animateMenu(show: true, duration: 0.35, dampening: 0.7, springVelocity: 0.6)
      
    case UISwipeGestureRecognizerDirection.down:
      animateMenu(show: false, duration: 0.1)
      
    default: print("Not interested")
    }
  }
  
  private func animateMenu(show: Bool, duration: TimeInterval, dampening: CGFloat = 0.005, springVelocity: CGFloat = 0.005) {
    // ignore toggle request if already in proper position
    switch show {
    case true:
      if self.foaasView.frame.origin.y != 0 { return }
    case false:
      if self.foaasView.frame.origin.y == 0 { return }
    }
    
    let multiplier: CGFloat = show ? -1 : 1
    let originalFrame = self.foaasView.frame
    
    // TODO: Adjust and update this animation
//    let newFrame = originalFrame.offsetBy(dx: 0.0, dy: self.foaasSettingsView.frame.size.height * multiplier)
//    UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: dampening, initialSpringVelocity: springVelocity, options: [], animations: {
//      self.foaasView.frame = newFrame
//    }, completion: nil)
  }
  

  
}
