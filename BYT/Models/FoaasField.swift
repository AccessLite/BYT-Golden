//
//  FoaasField.swift
//  AC3.2-BiteYourThumb
//
//  Created by Louis Tur on 11/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal struct FoaasField: JSONConvertible, CustomStringConvertible {
  let name: String
  let field: String
  
  var description: String {
    return "Name: \(name)   Field: \(field)"
  }
  
  init?(json: [String : AnyObject]) {
    guard
      let jName = json["name"] as? String,
      let jField = json["field"] as? String
      else { return nil }
    
    self.name = jName
    self.field = jField
  }
  
  func toJson() -> [String : AnyObject] {
    return [
      "name" : name as AnyObject,
      "field" : field as AnyObject
    ]
  }
}
