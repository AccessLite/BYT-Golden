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
    
    var jsonDict: [String: Any]
    
    init(record_url: String,
         version_name: String,
         number: String,
         date_released: String,
         message: String,
         jsonDict: [String: Any]) {
        self.record_url = record_url
        self.version_name = version_name
        self.number = number
        self.date_released = date_released
        self.message = message
        self.jsonDict = jsonDict
    }
    
    convenience init? (from dict: [String:Any]) {
        if let record_url = dict["record_url"] as? String,
            let version_name = dict["version_name"] as? String,
            let number = dict["number"] as? String,
            let date_released = dict["date_released"] as? String,
            let message = dict["message"] as? String {
            
            self.init(record_url: record_url,
                      version_name: version_name,
                      number: number,
                      date_released: date_released,
                      message: message,
                      jsonDict: dict)
        } else {
            return nil
        }
    }
    
    convenience required init?(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            if let validJson = json {
                self.init(from: validJson)
            } else {
                return nil
            }
        }
        catch {
            print("Problem recreating currentVersion from data: \(error)")
            return nil
        }
    }

    
    static func parseVersion(from data: Data) -> Version? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let validArr = json as? [[String: Any]], validArr.count > 0 else { return nil }
            if let version = Version(from: validArr.last!) {
                return version
            }
        }
        catch {
            print(error)
        }
        return nil
    }
    
    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self.jsonDict, options: [])
    }
    
}
