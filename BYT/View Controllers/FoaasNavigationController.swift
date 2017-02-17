//
//  FoaasNavigationController.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

struct FoaasNavImages {
  static let addButton: UIImage = UIImage(named: "add_button_grayscale")!
  static let backButton: UIImage = UIImage(named: "back_button_grayscale")!
  static let closeButton: UIImage = UIImage(named: "close_button_grayscale")!
  static let doneButton: UIImage = UIImage(named: "done_button_grayscale")!
}

enum FoaasNavType {
  case add, back, close, done, none
}

protocol FoaasNavigationActionDelegate {
  func leftAction()
  func rightAction()
}

// TODO: read me 👇
/*
 This navigation controller functionallity will be further implemented in v2. Currently, there are some dependancies on the
 existing action buttons that will require a bit more work that desired. For example, sizing and layout is done relative to 
 the "addButton" in the FoaasView.
 
 When this is ready for testing/implementation, all that is needed to begin is: 
 - uncomment setting delegation, setupViewHierarchy & configureConstraints in viewDidLoad
 - conform all view controllers to FoaasNavigationActionDelegate. in each protocol function, implement the proper push/pops
 */

class FoaasNavigationController: UINavigationController, UINavigationControllerDelegate {
  let buttonDiameter: CGFloat = 54.0
  let buttonMargin: CGFloat = 48.0
  var navigationActionDelegate: FoaasNavigationActionDelegate?
  
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UIApplication.shared.statusBarStyle = .lightContent
    
    // uncomment below to start testing
//    self.delegate = self
//    setupViewHierarchy()
//    configureConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.bringFloatingButtonsToTop()
  }
  
  
  // MARK: - Setup
  private func setupViewHierarchy() {
    guard let mainWindow = UIApplication.shared.keyWindow else { return }
    mainWindow.addSubview(leftFloatingButton)
    mainWindow.addSubview(rightFloatingButton)
    
    let leftTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(runLeftAction))
    leftFloatingButton.addGestureRecognizer(leftTapGesture)
    
    let rightTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(runRightAction))
    rightFloatingButton.addGestureRecognizer(rightTapGesture)
  }
  
  private func configureConstraints() {
    guard let mainWindow = UIApplication.shared.keyWindow else { return }
    stripAutoResizingMasks(leftFloatingButton, rightFloatingButton)
    
    [ leftFloatingButton.leadingAnchor.constraint(equalTo: mainWindow.leadingAnchor, constant: buttonMargin),
      leftFloatingButton.bottomAnchor.constraint(equalTo: mainWindow.bottomAnchor, constant: -buttonMargin),
      leftFloatingButton.heightAnchor.constraint(equalToConstant: buttonDiameter),
      leftFloatingButton.widthAnchor.constraint(equalToConstant: buttonDiameter),
      
      rightFloatingButton.trailingAnchor.constraint(equalTo: mainWindow.trailingAnchor, constant: -buttonMargin),
      rightFloatingButton.bottomAnchor.constraint(equalTo: mainWindow.bottomAnchor, constant: -buttonMargin),
      rightFloatingButton.heightAnchor.constraint(equalToConstant: buttonDiameter),
      rightFloatingButton.widthAnchor.constraint(equalToConstant: buttonDiameter),
      ].activate()
  }
  
  /// Called just before viewWillAppear in order to place the buttons over all other views
  private func bringFloatingButtonsToTop() {
    guard
      let mainWindow = UIApplication.shared.keyWindow,
      mainWindow.subviews.contains(leftFloatingButton),
      mainWindow.subviews.contains(rightFloatingButton)
    else { return }
    
    mainWindow.bringSubview(toFront: leftFloatingButton)
    mainWindow.bringSubview(toFront: rightFloatingButton)
  }
  
  
  // MARK: - Actions
  @objc private func runLeftAction() {
    navigationActionDelegate?.leftAction()
  }
  
  @objc private func runRightAction() {
    navigationActionDelegate?.rightAction()
  }
  
  
  // MARK: - Navigation Changes
  private func updateNavigation(left: FoaasNavType, right: FoaasNavType) {
    switch left {
    case FoaasNavType.add: leftFloatingButton.setImage(FoaasNavImages.addButton, for: .normal)
    case FoaasNavType.back: leftFloatingButton.setImage(FoaasNavImages.backButton, for: .normal)
    case FoaasNavType.close: leftFloatingButton.setImage(FoaasNavImages.closeButton, for: .normal)
    case FoaasNavType.done: leftFloatingButton.setImage(FoaasNavImages.doneButton, for: .normal)
    case FoaasNavType.none: leftFloatingButton.setImage(nil, for: .normal)
    }
    
    switch right {
    case FoaasNavType.add: rightFloatingButton.setImage(FoaasNavImages.addButton, for: .normal)
    case FoaasNavType.back: rightFloatingButton.setImage(FoaasNavImages.backButton, for: .normal)
    case FoaasNavType.close: rightFloatingButton.setImage(FoaasNavImages.closeButton, for: .normal)
    case FoaasNavType.done: rightFloatingButton.setImage(FoaasNavImages.doneButton, for: .normal)
    case FoaasNavType.none: rightFloatingButton.setImage(nil, for: .normal)
    }
  }
  
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    switch viewController {
    case is FoaasViewController: updateNavigation(left: .none, right: .add)
    case is FoaasOperationsTableViewController: updateNavigation(left: .none, right: .close)
    case is FoaasPrevewViewController: updateNavigation(left: .back, right: .done)
    default: print("Unhandled view controller type")
    }
    // TODO: the current implementation works for positioning, but the buttons need actions, methods to update images & actions and shadows
  }
  
  
  // MARK: Lazy Inits
  internal lazy var leftFloatingButton: UIButton = UIButton()
  internal lazy var rightFloatingButton: UIButton =  UIButton()
}
