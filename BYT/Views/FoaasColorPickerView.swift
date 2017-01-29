//
//  FoaasColorPickerView.swift
//  BYT
//
//  Created by Louis Tur on 1/28/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasColorPickerView: UIView, UIScrollViewDelegate {
  private let baseUnit: CGFloat = 80.0
  
  var containerWith: CGFloat { return baseUnit * 2.5 }
  var containerHeight: CGFloat { return baseUnit }
  var scrollWidth: CGFloat { return baseUnit * 1.5 }
  var scrollHeight: CGFloat { return baseUnit }
  var colorViewWidth: CGFloat { return baseUnit }
  var colorViewHeight: CGFloat { return baseUnit / 2.0 }
  var interViewMargin: CGFloat { return baseUnit / 2.0 }
  var bookendViewVisibilityWidth: CGFloat { return baseUnit / 4.0 }
  var clippedMarginWidth: CGFloat { return baseUnit * 0.75 }
  var intervalOffsets: CGFloat { return baseUnit * 1.5}

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViewHierarchy()
    configureConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func configureConstraints() {
    // TODO
  }
  
  private func setupViewHierarchy() {
    self.addSubview(containerView)
    self.containerView.addSubview(scrollView)
    
    self.scrollView.delegate = self
  }
  
  // MARK: - Adjusting Views
  func setCurrentIndex(_ index: Int) {
    let offSetPoint = CGPoint(x: intervalOffsets * CGFloat(index), y: 0.0)
    self.scrollView.setContentOffset(offSetPoint, animated: true)
  }
  
  
  // MARK: - ScrollView Delegate
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    // http://stackoverflow.com/questions/31106427/unsafemutablepointeruint8-to-uint8-without-memory-copy?noredirect=1&lq=1
    // http://en.swifter.tips/unsafe/
    let unsafeBuffer = UnsafeMutableBufferPointer(start: targetContentOffset, count: 1)
    let cgPointArray = Array.init(unsafeBuffer)
    
    guard let finalCGPoint = cgPointArray.first else {
      print("Error with empty CGPoint array following unsafe pointer conversion")
      return
    }
    
    let currentVisibleViewIndex = finalCGPoint.x / intervalOffsets
    print("Current Index: \(currentVisibleViewIndex)      Current Offset: \(finalCGPoint)")
  }
  
  
  // MARK: - Lazys
  internal lazy var scrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.backgroundColor = .gray
    scroll.isPagingEnabled = true
    scroll.clipsToBounds = false
    return scroll
  }()
  
  internal lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .yellow
    return view
  }()
}
