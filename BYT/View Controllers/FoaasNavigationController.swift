//
//  FoaasNavigationController.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasNavigationController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.shared.statusBarStyle = .lightContent
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNavigationBarHidden(true, animated: false)
  }
  
}
