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
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.makeKey()
    
    ColorManager.shared.loadCurrentColorScheme()
    ColorManager.shared.loadColorSchemes()
    VersionManager.shared.loadCurrentVersion()
    
    FoaasDataManager.shared.requestOperations()
    requestColorSchemes()
    requestVersionInfo()
    
    let navigationVC = FoaasNavigationController(rootViewController: FoaasViewController())
    self.window?.rootViewController = navigationVC
    self.window?.makeKeyAndVisible()
    return true
  }
  
  func requestColorSchemes() {
    FoaasDataManager.shared.requestColorSchemeData(endpoint: FoaasAPIManager.colorSchemeURL) { (data: Data?) in
      guard let validData = data else { return }
      guard let colorSchemes = ColorScheme.parseColorSchemes(from: validData) else { return }
      ColorManager.shared.colorSchemes = colorSchemes
      
      var colorUpdateNotification = Notification(name: Notification.Name.init(rawValue: FoaasColorPickerView.colorViewsShouldUpdateNotification))
      colorUpdateNotification.userInfo = [ FoaasColorPickerView.updatedColorsKey : ColorManager.shared.colorSchemes.map{ $0.primary }]
      NotificationCenter.default.post(colorUpdateNotification)
    }
  }
  
  func requestVersionInfo() {
    FoaasDataManager.shared.requestVersionData(endpoint: FoaasAPIManager.versionURL) { (data: Data?) in
      guard let validData = data else { return }
      guard let version = Version.parseVersion(from: validData) else { return }
      
      if version.number != VersionManager.shared.currentVersion.number {
        VersionManager.shared.currentVersion = version
        
        var versionUpdateNotification: Notification = Notification(name: Notification.Name.init(rawValue: VersionManager.versionDidUpdateNotification))
        versionUpdateNotification.userInfo = [VersionManager.versionUpdatedKey : VersionManager.shared.currentVersion]
        NotificationCenter.default.post(versionUpdateNotification)
      }
    }
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    requestColorSchemes()
    requestVersionInfo()
  }
  
}

