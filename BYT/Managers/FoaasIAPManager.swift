//
//  FoaasIAPManager.swift
//  BYT
//
//  Created by Louis Tur on 2/18/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import Foundation
import StoreKit

internal class FoaasIAPManager: NSObject, SKProductsRequestDelegate {
  
  static let shared: FoaasIAPManager = FoaasIAPManager()
  private let iapIdentifier: Set<String> = ["com.accesslite.byt"]
  private let productsRequest: SKProductsRequest!
  
  private override init() {
    productsRequest = SKProductsRequest()
    
    super.init()
    productsRequest.delegate = self
    productsRequest.start()
  }
  
  
  // MARK: - In App Purchase Delegate
  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    guard response.products.count > 0 else {
      print("No products found!")
      return
    }
    
    for prod in response.products {
      print(prod.productIdentifier)
    }
  }
}
