//
//  VersionManager.swift
//  BYT
//
//  Created by Tom Seymour on 1/29/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import Foundation

class VersionManager {
    
    static let shared: VersionManager = VersionManager()
    
    private init() {}

    var currentVersion: Version! {
        didSet {
            self.saveCurrentVersion()
        }
    }
    
    private let defaultVersionDict: [String: Any] = [
        "id" : 0,
        "record_url" : "https://fieldbook.com/records/5873aafdbc9912030079d38b",
        "version_name" : "default",
        "number" : "0.0.0",
        "date_released" : "2017-01-01",
        "message" : "\"Made with ❤️\""
    ]
    
    private static let currentVersionKey: String = "CurrentVersionKey"
    private static let defaults = UserDefaults.standard
    
    func saveCurrentVersion() {
        do {
            let currentVersionData: Data = try VersionManager.shared.currentVersion.toData()
            VersionManager.defaults.set(currentVersionData, forKey: VersionManager.currentVersionKey)
            print("think I successfully saved the currentVersion")
        } catch {
            print("Error converting currentVersion to data")
        }
    }
    
    func loadCurrentVersion() {
        if let savedDataFromDefaults = VersionManager.defaults.value(forKey: VersionManager.currentVersionKey) as? Data {
            self.currentVersion = Version(data: savedDataFromDefaults)
        } else {
            // If the is no saved color scheme, the app set the current color scheme to default purple
            self.currentVersion = Version(from: self.defaultVersionDict)
        }
    }


    
    
}
