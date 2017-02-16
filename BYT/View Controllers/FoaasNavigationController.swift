//
//  FoaasNavigationController.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasNavigationController: UINavigationController, UINavigationControllerDelegate {
  struct FoaasNavImages {
    let addButton: UIImage = UIImage(named: "add_button_grayscale")!
    let backButton: UIImage = UIImage(named: "add_button_grayscale")!
    let closeButton: UIImage = UIImage(named: "add_button_grayscale")!
    let doneButton: UIImage = UIImage(named: "add_button_grayscale")!
  }
  
  let buttonDiameter: CGFloat = 54.0
  let buttonMargin: CGFloat = 48.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.delegate = self
    UIApplication.shared.statusBarStyle = .lightContent
    self.addFloatingButtons()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNavigationBarHidden(true, animated: false)

  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard let mainWindow = UIApplication.shared.keyWindow else { return }
    mainWindow.bringSubview(toFront: leftFloatingButton)
    mainWindow.bringSubview(toFront: rightFloatingButton)
    //    FoaasNavigationController.keyWindowCheck(at: "viewDiDAppear")
  }
  
  class func keyWindowCheck(at point: String = "") {
    guard UIApplication.shared.keyWindow != nil else {
      print("\n\nNO MAIN WINDOW EXISTS at \(point)\n\n")
      return }
    
    print("\n\n~~~~~ YES WINDOW EXISTS at \(point) ~~~~~~~~\n\n")
  }
  
  private func addFloatingButtons() {
    FoaasNavigationController.keyWindowCheck()
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
  
  private func updateFloatingButtonImages(left: UIImage? = nil, right: UIImage? = nil) {
    
  }
  
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    
    switch viewController {
    case is FoaasViewController:
      print("main foaas view controller")
      
    case is FoaasOperationsTableViewController:
      print("operations table vc")
      
    case is FoaasPrevewViewController:
      print("Foaas preview vc")
      
    default:
      print("Nope")
    }
    
    // TODO: add implementation for floating buttons in V2 here
    // the current implementation works for positioning, but the buttons need actions, methods to update images & actions
    // and shadows
    //    addFloatingButtons()
  }
  
  
  
  // MARK: Lazy Inits
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
