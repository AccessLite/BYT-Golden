//
//  FoaasBuilder.swift
//  AC3.2-BiteYourThumb
//
//  Created by Louis Tur on 11/27/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

enum FoaasBuilderError: Error {
  case keyDoesNotExist(key: String)
  case keyIndexNotFound(key: String)
}

class FoaasPathBuilder {
  var operation: FoaasOperation!
  var operationFields: [String : String]!
  private let baseURLString: String = "https://www.foaas.com"
  
  /**
   Flattens an array of [FoaasField] with identical keys, into a one-dimensional array of [String:String] while performing
   a case-insensitive comparison of key-value pairs to store only unique keys.
   
   - parameter operation: The `FoaasOperation` to use in building a URL path.
   */
  init(operation: FoaasOperation) {
    self.operation = operation
    var dict: [String:String] = [:]
    for eachArray in operation.fields {
        dict[eachArray.name.lowercased()] = eachArray.field.lowercased()
    }
    self.operationFields = dict
    /*
    self.operation = operation
    
    // 1. iterrates through the operation's [FoaasField] and converts to json
    self.operationFields = self.operation.fields.reduce( [:] ) { (current: [String:String], field: FoaasField) in
      
      var temp = current
      let fieldJson = field.toJson() as! [String : String]
      // 2. reverses the key/values
      for (key, value) in fieldJson {
        temp[value.lowercased()] = key // New keys that differ by only capitalization are ignored
      }
      
      // 3. appends to a new dictionary of [String : String]
      return temp
      }
  */
  }
  
  /**
   Goes through a `FoaasOperation.url` to replace placeholder text with its corresponding value stored in self.operationsField
   in the correct order. The String is also passed back with percent encoding automatically applied.
   
   example:
   ```
   self.operationFields = [ "from" : "Grumpy Cat", "name" : "Nala Cat"]
   self.operation.url = "/bus/:name/:from/"
   
   build() // returns "/bus/Nala%20Cat/Grumpy%20Cat"
   ```
   
   - returns: A `String` that contains baseURLString and updated FoaasOperation.url needed to create a `URL` to request a `Foaas` object
   */
  func build() -> String {
    var urlString = self.operation.url
    for (key,value) in operationFields {
        urlString = urlString.replacingOccurrences(of: ":\(key)", with: value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)
    }
    return baseURLString + urlString
    /*
    
    let components = self.operation.url.components(separatedBy: "/:")
    
    let orderedComponents = components.flatMap { (component: String) -> String? in
      
      // check that its index exists to ensure it is in self.operationFields
      // check that allKeys has the component to ensure it exists in our operation
      guard let _ = self.indexOf(key: component),
        self.allKeys().contains(component)
      else { return nil }
      
      return self.operationFields[component]
    }
    
    return baseURLString + orderedComponents.reduce(components.first!) { (current: String, component: String) -> String in
      return "\(current)/\(component)"
    }.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
     */
  }
  
  /**
   Updates the `value` of an element with the corresponding `key`. If the `key` does not exist, nothing happens. 
   
   - parameter key: The key of an element in `self.operationFields`
   - parameter value: The value to change to.
   */
  func update(key: String, value: String)  {
    guard
      self.allKeys().contains(key),
      let _ = indexOf(key: key)
    else {
      return
    }
    
    self.operationFields[key] = value
  }
  
  /**
   Utility function to get the index of a specified key in its correct order in the `FoaasOperation.url` property. 
    
   For example, for the Ballmer operation, its corresponding FoaasOperation.url is `/ballmer/:name/:company/:from`
   
   - indexOf(key: "name") // should return 0
   - indexOf(key: "company") // should return 1
   - indexOf(key: "from") // should return 2
   - indexOf(key: ":name") // should return nil
   - indexOf(key: "tool") // should return nil
   
   - parameter key: The key in self.operationFields to search for. 
   - returns: The index position of the key if it exists in self.operationFields. `nil` otherwise.
   - seealso: `FoaasPathBuilder.allKeys`
  */
  func indexOf(key: String) -> Int? {
    let components = self.operation.url.components(separatedBy: "/:")
    let keyComponent = components.first { (component) -> Bool in
      if component == key {
        return true
      }
      return false
    }
    
    guard let locatedPosition = keyComponent else { return nil }
    
    return components.index(of: locatedPosition)
  }
  
  /**
   Utility method that returns all of the keys for a `FoaasOperation`'s `field`s
   
   - returns: The keys contained in `self.operation.fields` as `[String]`
  */
  func allKeys() -> [String] {
    return self.operation.fields.map { $0.field }
  }
    
    /**
     Check if the `FoaasOpertion`'s `field` keys are same as the `FoaasOperation`'s `field`'s values, or if the `value` is an empty string
     - returns: `true` if any key or value pais are the same, else returns false
     */
    func entryIsValid() -> Bool {
        for (key,value) in operationFields {
          let cleanedValueString: String = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if key == cleanedValueString || cleanedValueString == "" {
                return false
            }
        }
        return true
    }
  
}
