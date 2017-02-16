//
//  FoaasOperation.swift
//  AC3.2-BiteYourThumb
//
//  Created by Louis Tur on 11/20/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal struct FoaasOperation: JSONConvertible, DataConvertible {
  let name: String
  let url: String
  let fields: [FoaasField]
  
  // MARK: - JSONConvertible
  init?(json: [String : AnyObject]) {
    guard
      let jName = json["name"] as? String,
      let jUrl = json["url"] as? String,
      let jFields = json["fields"] as? [[String : AnyObject]]
    else { return nil }
        
    switch jName {
    case "Who the fuck are you anyway":
        self.name = "Anyway"
    case "This Thing In Particular":
        self.name = "Particular"
    case "Fuck You And The Horse You Rode In On" :
        self.name = "Horse"
    case "{Name} You Are Being The Usual Slimy Hypocritical Asshole... You May Have Had Value Ten Years Ago, But People Will See That You Don't Anymore.":
        self.name = "Hypocritical"
    case "That's Fucking Ridiculous":
        self.name = "Ridiculous"
    default:
        self.name = jName.capitalized
    }
    
    self.url = jUrl
    self.fields = jFields.flatMap { FoaasField(json: $0) }
  }
  
  func toJson() -> [String : AnyObject] {
    return [
      "name": self.name as AnyObject,
      "url" : self.url as AnyObject,
      "fields" : self.fields.map{ $0.toJson() } as AnyObject
    ]
  }
  
  // MARK: - Data Convertible
  init?(data: Data) {
    guard
      let json = try? JSONSerialization.jsonObject(with: data, options: []),
      let jsonValid = json as? [String : AnyObject],
      let operation = FoaasOperation(json: jsonValid)
    else {
      return nil
    }
    self = operation
  }
  
  func toData() throws -> Data {
    return try JSONSerialization.data(withJSONObject: self.toJson(), options: [])
  }

}
