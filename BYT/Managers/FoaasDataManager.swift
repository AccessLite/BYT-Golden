//
//  FoaasDataManager.swift
//  AC3.2-BiteYourThumb
//
//  Created by Louis Tur on 11/20/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal class FoaasDataManager {
  private static let operationsKey: String = "FoaasOperationsKey"
  private static let defaults = UserDefaults.standard
  internal private(set) var operations: [FoaasOperation]?
    
  static let foaasURL = URL(string: "http://www.foaas.com/awesome/Someone")
  
  // MARK: Singleton
  internal static let shared: FoaasDataManager = FoaasDataManager()
  private init() {}
  
  
  // MARK: API Request
  
  /// Opportunistically loads `[FoaasOperation]` from `UserDefaults` if present. Otherwise, makes an API
  /// request to `FoaasAPIManager` to retrieve data. Additionally, saves valid `FoaasOperation`.
  ///
  /// - Parameter operations: If located in `UserDefaults` or the API call is successful, 
  ///    the converted `[FoaasOperation]` based on latest server info
  internal func requestOperations(_ operations: @escaping ([FoaasOperation]?)->Void) {
    if self.load() {
      operations(self.operations!)
      return
    }
    
    FoaasAPIManager.getOperations { (apiOperations: [FoaasOperation]?) in
      operations(apiOperations)

      guard apiOperations != nil else { return }
      self.save(operations: apiOperations!)
    }
  }
  
  
  // MARK: - Save/Load
  // TODO: Improve logging print statements
  
  /// Saves `[FoaasOperation]` to `UserDefaults` as `Data`
  ///
  /// - Parameter operations: The array of `FoaaasOperation` to store to `UserDefaults`
  private func save(operations: [FoaasOperation]) {
    self.operations = operations
    let opsData = operations.flatMap{ try? $0.toData() }
    
    print("Successful conversion of [FoaasOperation] to [Data]. Storing...")
    FoaasDataManager.defaults.set(opsData, forKey: FoaasDataManager.operationsKey)
  }
  
  /// Loads all `[FoaasOperation]` stored in `UserDefaults`. Sets manager's `var operations: [FoaasOperation]?` property to located `[FoaasOperation]`
  ///
  /// - Returns: `true` if `[FoaasOperation]` was found, `false` otherwise
  private func load() -> Bool {
    guard
      let opsData = FoaasDataManager.defaults.object(forKey: FoaasDataManager.operationsKey) as? [Data]
    else { return false }
    
    print("Found [Data], converting to FoaasOperation")
    self.operations = opsData.flatMap { FoaasOperation(data: $0) }
    return true
  }
  
  
  // MARK: - Delete
  internal func deleteStoredOperations() {
    guard self.load() else {
      return
    }
    
    print("Deleting stored [FoaasOperation]")
    FoaasDataManager.defaults.removeObject(forKey: FoaasDataManager.operationsKey)
    self.operations = nil
  }
    
    internal func requestFoaas(url: URL, _ operations: @escaping (Foaas?) -> Void) {
        FoaasAPIManager.getFoaas(url: url) { (foaas: Foaas?) in
            operations(foaas)
        }
    }
    
    internal func requestData(endpoint: String, _ operations: @escaping (Data?) -> Void) {
        FoaasAPIManager.getData(endpoint: endpoint) { (data: Data?) in
            operations(data)
        }
    }
    
    internal func requestColorSchemeData(endpoint: String, _ operations: @escaping (Data?) -> Void) {
        FoaasAPIManager.getData(endpoint: endpoint) { (data: Data?) in
            operations(data)
        }
    }
    
    internal func requestVersionData(endpoint: String, _ operations: @escaping (Data?) -> Void) {
        FoaasAPIManager.getData(endpoint: endpoint) { (data: Data?) in
            operations(data)
        }
    }
  
}
