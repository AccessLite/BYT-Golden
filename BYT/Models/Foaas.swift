//
//  Foaas.swift
//  AC3.2-BiteYourThumb
//
//  Created by Louis Tur on 11/15/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal struct Foaas: JSONConvertible, CustomStringConvertible {
  
  let message: String
  let subtitle: String
  
  var description: String {
    return "\(message)\n\(subtitle)"
  }
  
  init(message: String, subtitle: String) {
        self.message = message
        self.subtitle = subtitle
    }
    
  init?(json: [String : AnyObject]) {
    guard
      let message = json["message"] as? String,
      let subtitle = json["subtitle"] as? String
      else {
        return nil 
    }
    self.init(message: message, subtitle: subtitle)
  }
  
  func toJson() -> [String : AnyObject] {
    return [ "message": self.message as AnyObject,
             "subtitle" : self.subtitle as AnyObject ]
  }
}
