//
//  Version.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 1/22/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Version {
    var record_url: String
    var version_name: String
    var number: String
    var date_released: String
    var message: String
    var color_schemes: [ColorSchemeInVersion]
    
    init(record_url: String,
         version_name: String,
         number: String,
         date_released: String,
         message: String,
         color_schemes: [ColorSchemeInVersion]) {
        self.record_url = record_url
        self.version_name = version_name
        self.number = number
        self.date_released = date_released
        self.message = message
        self.color_schemes = color_schemes
    }
    
    convenience init? (from dict: [String:Any]) {
        if let record_url = dict["record_url"] as? String,
            let version_name = dict["version_name"] as? String,
            let number = dict["version_name"] as? String,
            let date_released = dict["date_released"] as? String,
            let message = dict["message"] as? String,
            let color_schemesArrayOfDict = dict["color_schemes"] as? [[String: Any]] {
            var c = [ColorSchemeInVersion]()
            for dict in color_schemesArrayOfDict {
                //guard let color = ColorSchemeInVersion(from: dict) else { return }
                //c.append(color)
            }
            self.init(record_url: record_url,
                      version_name: version_name,
                      number: number,
                      date_released: date_released,
                      message: message,
                      color_schemes: [])
        } else {
            return nil
        }
    }
    
    static func parseVersion(from data: Data) -> [Version]? {
        var versionArr = [Version]()
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let validArr = json as? [[String: Any]] else { return nil }
            for version in validArr {
                if let v = Version(from: version) {
                    versionArr.append(v)
                }
            }
        }
        catch {
            print(error)
        }
        return versionArr
    }

}

class ColorSchemeInVersion {
    var id: Int
    var color_scheme_name: String
    init(id: Int, color_scheme_name: String) {
        self.id = id
        self.color_scheme_name = color_scheme_name
    }
}
