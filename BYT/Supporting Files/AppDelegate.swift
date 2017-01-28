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
    
    let navigationVC = FoaasNavigationController(rootViewController: FoaasViewController())
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = navigationVC
    self.window?.makeKeyAndVisible()
    
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
    
    ColorManager.shared.loadCurrentColorScheme()
    ColorManager.shared.loadColorSchemes()
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

