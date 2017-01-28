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
        }
    }
    
    func saveColorSchemes() {
        let colorSchemesData: [Data] = ColorManager.shared.colorSchemes.flatMap { try? $0.toData() }
        ColorManager.defaults.set(colorSchemesData, forKey: ColorManager.colorSchemesKey)
    }
    
    func loadColorSchemes() {
        if let savedDataFromDefaults = ColorManager.defaults.value(forKey: ColorManager.colorSchemesKey) as? [Data] {
            self.colorSchemes = savedDataFromDefaults.flatMap { ColorScheme(data: $0) }
            print("Succesfully loaded colorSchems")
        }
    }
    
}
