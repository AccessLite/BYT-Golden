//
//  AppDelegate.swift
//  BYT
//
//  Created by Louis Tur on 1/21/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    ColorManager.shared.loadCurrentColorScheme()
    ColorManager.shared.loadColorSchemes()
    VersionManager.shared.loadCurrentVersion()
    
    FoaasDataManager.shared.requestOperations { (operations: [FoaasOperation]?) in
      if operations != nil {
        print("Loaded operations")
        
        for op in operations! {
          let builder = FoaasPathBuilder(operation: op)
          
          builder.update(key: "from", value: "From Cat")
          builder.update(key: "name", value: "Name Cat")
          print(builder.build())
        }
      }
    }
    
    let navigationVC = FoaasNavigationController(rootViewController: FoaasViewController())
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = navigationVC
    self.window?.makeKeyAndVisible()
    return true
  }
  
}

