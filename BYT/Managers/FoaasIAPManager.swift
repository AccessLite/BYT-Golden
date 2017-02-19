//
//  FoaasIAPManager.swift
//  BYT
//
//  Created by Louis Tur on 2/18/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import Foundation
import StoreKit

internal class FoaasIAPManager: NSObject, SKProductsRequestDelegate, SKRequestDelegate {
  
  static let shared: FoaasIAPManager = FoaasIAPManager()
  private let iapIdentifier: Set<String> = ["com.accesslite.byt.devsupport"]
//  private let iapIdentifier: Set<String> = []
  private let productsRequest: SKProductsRequest!
  private let request: SKRequest!
  
  private override init() {
    productsRequest = SKProductsRequest(productIdentifiers: iapIdentifier)
    request = SKRequest()
    
    super.init()
    productsRequest.delegate = self
    request.delegate = self
    request.start()
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
  
  func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Request Did Fail")
    print("Error: \(error)")
  }
  
  func requestDidFinish(_ request: SKRequest) {
    print("Request Did Finish")
  }
}
