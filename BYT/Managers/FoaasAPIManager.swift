//
//  FoaasAPIManager.swift
//  AC3.2-BiteYourThumb
//
//  Created by Louis Tur on 11/15/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

protocol FoaasAPIManagerDelegate: class {
  func didFinishOperationsRequest(data: Data)
  func didFinishFoaasRequest(data: Data)
}

internal class FoaasAPIManager {
  private static let backgroundSessionIdentifier: String = "foaasBackgroundSession"
  
  private static let debugURL = URL(string: "https://www.foaas.com/awesome/louis")!
  private static let extendedDebugURL = URL(string: "https://www.foaas.com/greed/cat/louis")!
  private static let extendedTwoDebugURL = URL(string: "https://www.foaas.com/madison/louis/paul")!
  private static let operationsURL = URL(string: "https://www.foaas.com/operations")!
  
  private static let defaultSession = URLSession(configuration: .default)
  internal private(set) weak static var delegate: FoaasAPIManagerDelegate?
  
  
  // MARK: - GET Requests -
  
  // MARK: Foaas GET
  // TODO: Make these calls more concise, but still safely unwrapping values - @Liam
  internal class func getFoaas(url: URL = FoaasAPIManager.extendedTwoDebugURL, completion: @escaping (Foaas?)->Void) {
    
    var request: URLRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    defaultSession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
      guard error == nil else {
        print("Error: \(error.unsafelyUnwrapped)")
        return
      }
      
      guard let validData = data else {
        print("Error: Data returned was nil")
        return
      }
        
        do {
          let foaasJson = try JSONSerialization.jsonObject(with: validData, options: []) as? [String: AnyObject]
          
          guard
            let validFoaas = foaasJson,
            let newFoaas = Foaas(json: validFoaas)
          else {
            print("There was an error initiating a Foaas object")
            completion(nil)
            return
          }
          
          completion(newFoaas)
        }
        catch {
          print("There was an error parsing data: \(error)")
        }
    
    }).resume()
  }
  
  
  // MARK: Operations GET
  internal class func getOperations(completion: @escaping ([FoaasOperation]?)->Void ) {
    
    defaultSession.dataTask(with: FoaasAPIManager.operationsURL, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
      guard error == nil else {
        print("Error: \(error.unsafelyUnwrapped)")
        return
      }
      
      guard let validData = data else {
        print("Error: Data returned was nil")
        return
      }
      
        do {
          guard let operationsJson = try JSONSerialization.jsonObject(with: validData, options: []) as? [Any]
          else {
              print("Error attempting to serialize JSON")
              return
          }
          
          var operations: [FoaasOperation]? = []
          for case let operation as [String : AnyObject] in operationsJson {
            guard let foaasOp = FoaasOperation(json: operation) else { continue }
            operations?.append(foaasOp)
          }
          
          completion(operations)
        }
        catch {
          print("Error attempting to deserialize operations json: \(error)")
        }
    }).resume()
  }
  
  internal class func assignDelegate(_ delegate: FoaasAPIManagerDelegate) {
    self.delegate = delegate
  }
  
  
  // MARK: - Helpers
  // TODO: have this take custom error types to better handle issues before fully implementing - @Liam
  private static func handle(_ error: Error?, response: URLResponse?) {
    if let e = error{
      print(e.localizedDescription)
    }
    if let httpReponse = response as? HTTPURLResponse {
      print(httpReponse.statusCode)
    }
  }

}
