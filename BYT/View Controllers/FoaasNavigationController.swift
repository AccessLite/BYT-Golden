//
//  FoaasNavigationController.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasNavigationController: UINavigationController, UINavigationControllerDelegate {
  let buttonDiameter: CGFloat = 54.0
  let buttonMargin: CGFloat = 48.0
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.delegate = self
    UIApplication.shared.statusBarStyle = .lightContent
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNavigationBarHidden(true, animated: false)
  }
  
  internal func addFloatingButtons() {
    guard let mainWindow = UIApplication.shared.keyWindow else { return }
    mainWindow.addSubview(leftFloatingButton)
    mainWindow.addSubview(rightFloatingButton)
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
  
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    // TODO: add implementation for floating buttons in V2 here
    // the current implementation works for positioning, but the buttons need actions, methods to update images & actions
    // and shadows
//    addFloatingButtons()
  }
  
  internal lazy var leftFloatingButton: UIButton = {
    let button: UIButton = UIButton()
//    button.setImage(UIImage(named: "back_button"), for: .normal)
    return button
  }()
  
  internal lazy var rightFloatingButton: UIButton = {
    let button: UIButton = UIButton()
//    button.setImage(UIImage(named: "done_button"), for: .normal)
    return button
  }()
}
