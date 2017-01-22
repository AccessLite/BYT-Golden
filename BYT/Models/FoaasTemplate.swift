//
//  FoaasTemplate.swift
//  AC3.2-BiteYourThumb
//
//  Created by Louis Tur on 11/17/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal struct FoaasKey {
  internal static let from: String = "from"
  internal static let company: String = "company"
  internal static let tool: String = "tool"
  internal static let name: String = "name"
  internal static let doAction: String = "do"
  internal static let something: String = "something"
  internal static let thing: String = "thing"
  internal static let behavior: String = "behavior"
  internal static let language: String = "language"
  internal static let reaction: String = "reaction"
  internal static let noun: String = "noun"
  internal static let reference: String = "reference"
}

internal struct FoaasTemplate {
  let from: String
  let company: String?
  let tool: String?
  let name: String?
  let doAction: String?
  let something: String?
  let thing: String?
  let behavior: String?
  let language: String?
  let reaction: String?
  let noun: String?
  let reference: String?
}

extension FoaasTemplate: JSONConvertible {
  init?(json: [String : AnyObject]) {
    
    guard let jFrom = json[FoaasKey.from] as? String else {
      return nil
    }
    
    self.from = jFrom
    self.company = json[FoaasKey.company] as? String
    self.tool = json[FoaasKey.tool] as? String
    self.name = json[FoaasKey.name] as? String
    self.doAction = json[FoaasKey.doAction] as? String
    self.something = json[FoaasKey.something] as? String
    self.thing = json[FoaasKey.thing] as? String
    self.behavior = json[FoaasKey.behavior] as? String
    self.language = json[FoaasKey.language] as? String
    self.reaction = json[FoaasKey.reaction] as? String
    self.noun = json[FoaasKey.noun] as? String
    self.reference = json[FoaasKey.reference] as? String
  }
  
  func toJson() -> [String : AnyObject] {
    return [:]
  }
}
