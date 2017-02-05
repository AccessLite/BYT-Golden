//
//  FoaasColorPickerView.swift
//  BYT
//
//  Created by Louis Tur on 1/28/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasColorView: UIView {
    private var baseUnit: CGFloat = 0.0
    internal private(set) var managedColor: UIColor = UIColor.white
    
    var colorViewWidth: CGFloat { return baseUnit }
    var colorViewHeight: CGFloat { return baseUnit / 2.0 }
    
    convenience init(baseUnit: CGFloat, managedColor: UIColor) {
        self.init(frame: CGRect.zero)
        self.baseUnit = baseUnit
        self.managedColor = managedColor
        
        self.backgroundColor = managedColor
        
        self.layer.cornerRadius = 3.0
        configureConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        [ self.widthAnchor.constraint(equalToConstant: colorViewWidth),
          self.heightAnchor.constraint(equalToConstant: colorViewHeight) ].activate()
    }
    
}

protocol FoaasColorPickerViewDelegate: class {
    func didChangeColorPickerIndex(to index: Int)
}

class FoaasColorPickerView: UIView, UIScrollViewDelegate {
    private var baseUnit: CGFloat = 80.0
    
    var containerWith: CGFloat { return baseUnit * 2.5 }
    var containerHeight: CGFloat { return baseUnit / 2.0 }
    var scrollWidth: CGFloat { return baseUnit * 1.5 }
    var scrollHeight: CGFloat { return baseUnit / 2.0 } // updated this
    var interViewMargin: CGFloat { return baseUnit / 2.0 }
    var bookendViewVisibilityWidth: CGFloat { return baseUnit / 4.0 }
    var clippedMarginWidth: CGFloat { return baseUnit * 0.75 }
    var intervalOffsets: CGFloat { return baseUnit * 1.5}
    
    var foaasColorViews: [FoaasColorView] = []
    weak var delegate: FoaasColorPickerViewDelegate?
    
    convenience init(colors: [UIColor], baseUnit: CGFloat = 80.0) {
        self.init(frame: CGRect.zero)
        
        foaasColorViews = colors.map { FoaasColorView(baseUnit: baseUnit, managedColor: $0) }
        self.baseUnit = baseUnit
        
        setupViewHierarchy()
        configureConstraints()
        
        applyGradient()
    }
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureConstraints() {
        // container
        [ containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
          containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
          containerView.topAnchor.constraint(equalTo: self.topAnchor),
          containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
          containerView.heightAnchor.constraint(equalToConstant: containerHeight),
          containerView.widthAnchor.constraint(equalToConstant: containerWith),
          
          // scrollview
            scrollView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: scrollWidth),
            scrollView.heightAnchor.constraint(equalToConstant: scrollHeight),
            ].activate()
        
        guard
            let firstColorView = foaasColorViews.first,
            let lastColorView = foaasColorViews.last
            else { return }
        
        // first and last views trailing and leading
        [ firstColorView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: bookendViewVisibilityWidth),
          lastColorView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -bookendViewVisibilityWidth)
            ].activate()
        
        // all views center Y
        _ = foaasColorViews.map{
            $0.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        }
        
        // chaining views together
        var priorColorView: FoaasColorView?
        for colorView in foaasColorViews {
            guard priorColorView != nil else {
                priorColorView = colorView
                continue
            }
            colorView.leadingAnchor.constraint(equalTo: priorColorView!.trailingAnchor, constant: interViewMargin).isActive = true
            priorColorView = colorView
        }
        
    }
    
    private func setupViewHierarchy() {
        self.addSubview(containerView)
        self.containerView.addSubview(scrollView)
        _ = self.foaasColorViews.map {
            self.scrollView.addSubview($0)
        }
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.delegate = self
        self.setCurrentIndex(1)
        
        // we need to extend the bounds of the scroll view, so we add its panGestureRecognizer to its container view
        let panGesture = self.scrollView.panGestureRecognizer
        self.containerView.addGestureRecognizer(panGesture)
    }
    
    internal func applyGradient() {
        let fullGradient = CAGradientLayer()
        fullGradient.frame = self.containerView.bounds
        
        fullGradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor,
            UIColor.black.cgColor,
            UIColor.clear.cgColor,
        ]
        
        // Start Point & End Point are used in describing the direction of the gradient.
        // by changing the X-values only, we describe a horizontal gradient
        fullGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        fullGradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        // first 10%, last 10% of width
        fullGradient.locations = [0.0, 0.1, 0.9, 1.0]
        
        self.containerView.layer.mask = fullGradient
    }
    
    // MARK: - Adjusting Views
    func setCurrentIndex(_ index: Int) {
        let offSetPoint = CGPoint(x: intervalOffsets * CGFloat(index), y: 0.0)
        self.scrollView.setContentOffset(offSetPoint, animated: true)
    }
    
    func currentIndex() -> Int {
        let currentOffset = self.scrollView.contentOffset
        return Int(currentOffset.x / intervalOffsets)
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
        self.delegate?.didChangeColorPickerIndex(to: Int(currentVisibleViewIndex))
        print("Current Index: \(currentVisibleViewIndex)      Current Offset: \(finalCGPoint)")
    }
    
    
    // MARK: - Lazys
    internal lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.clipsToBounds = false
        return scroll
    }()
    
    internal lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
}
