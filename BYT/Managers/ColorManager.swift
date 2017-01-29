//
//  ColorManager.swift
//  BYT
//
//  Created by Tom Seymour on 1/26/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import Foundation

class ColorManager {
    
    static let shared = ColorManager()
    
    var currentColorScheme: ColorScheme! {
        didSet {
            self.saveCurrentColorScheme()
        }
    }
    
    var colorSchemes: [ColorScheme]! {
        didSet {
            self.saveColorSchemes()
        }
    }

    private static let currentColorSchemeKey: String = "CurrentColorSchemeKey"
    private static let colorSchemesKey: String = "colorSchemesKey"
    private static let defaults = UserDefaults.standard
    
    private let defaultColorDict: [String: Any] = [
        "id" : 1,
        "record_url" : "https://fieldbook.com/records/5873b13ebc9912030079d409",
        "color_scheme_name" : "purple",
        "_50" : "#F3E5F5",
        "_100" : "#E1BEE7",
        "_200" : "#CE93D8",
        "_300" : "#BA68C8",
        "_400" : "#AB47BC",
        "_500" : "#9C27B0",
        "_600" : "#8E24AA",
        "_700" : "#7B1FA2",
        "_800" : "#6A1B9A",
        "_900" : "#4A148C",
        "a200" : "#69F0AE",
        "premium" : "false"
    ]

    private init() {}
    
    func saveCurrentColorScheme() {
        do {
            let currentColorSchemeData: Data = try ColorManager.shared.currentColorScheme.toData()
            ColorManager.defaults.set(currentColorSchemeData, forKey: ColorManager.currentColorSchemeKey)
            print("think I successfully saved the currentColorScheme")
        } catch {
            print("Error converting currentColorScheme to data")
        }
    }
    
    func loadCurrentColorScheme() {
        if let savedDataFromDefaults = ColorManager.defaults.value(forKey: ColorManager.currentColorSchemeKey) as? Data {
            self.currentColorScheme = ColorScheme(data: savedDataFromDefaults)
        } else {
            // If the is no saved color scheme, the app set the current color scheme to default purple
            self.currentColorScheme = ColorScheme(from: self.defaultColorDict)
        }
    }
    
    func saveColorSchemes() {
        let colorSchemesData: [Data] = ColorManager.shared.colorSchemes.flatMap { try? $0.toData() }
        ColorManager.defaults.set(colorSchemesData, forKey: ColorManager.colorSchemesKey)
    }
    
    func loadColorSchemes() {
        if let savedDataFromDefaults = ColorManager.defaults.value(forKey: ColorManager.colorSchemesKey) as? [Data] {
            self.colorSchemes = savedDataFromDefaults.flatMap { ColorScheme(data: $0) }
            print("Succesfully loaded colorSchemes")
        } else {
            // if there are no saved clorSchemes then it will set an array of just the default colorScheme
            self.colorSchemes = [ColorManager.shared.currentColorScheme]
        }
    }
}
