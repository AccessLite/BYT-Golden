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
    
    self.name = jName
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
