//
//  FoaasSettingsMenuView.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 1/13/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class FoaasSettingsMenuView: UIView, UIScrollViewDelegate {
    
    @IBOutlet weak var profanitySwitch: UISwitch!
    @IBOutlet weak var shareImageButton: UIButton!
    @IBOutlet weak var cameraRollButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var colorSwitcherScrollView: UIScrollView!
    
    var delegate : FoaasSettingMenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let view = Bundle.main.loadNibNamed("FoaasSettingsMenuView", owner: self, options: nil)?.first as? UIView {
            //add a view to the subview
            self.addSubview(view)
            view.frame = self.bounds
            // Color Scroll View
            self.colorSwitcherScrollView.translatesAutoresizingMaskIntoConstraints = false
            self.colorSwitcherScrollView.backgroundColor = .clear
            self.colorSwitcherScrollView.contentSize = CGSize(width: self.view1.frame.width * CGFloat(3) + CGFloat(40), height: self.view1.frame.height)
            self.colorSwitcherScrollView.delegate = self
            
            self.colorSwitcherScrollView.addSubview(self.view1)
            self.colorSwitcherScrollView.addSubview(self.view2)
            self.colorSwitcherScrollView.addSubview(self.view3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //http://sweettutos.com/2015/04/13/how-to-make-a-horizontal-paging-uiscrollview-with-auto-layout-in-storyboards-swift/
        //set the width
        var number = 0
        var pageWidth:CGFloat = self.colorSwitcherScrollView.frame.width
        if number % 2 == 0 {
            pageWidth = self.colorSwitcherScrollView.frame.width
            number += 1
        } else {
            pageWidth = self.colorSwitcherScrollView.frame.width - CGFloat(40)
            number += 1
        }
        
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1

        if Int(currentPage) == 0{
            print("\(currentPage) is 0")
            self.delegate?.colorSwitcherScrollViewScrolled(color: self.view1.backgroundColor!)
        }else if Int(currentPage) == 1{
            print("\(currentPage) is 1")
            self.delegate?.colorSwitcherScrollViewScrolled(color: self.view2.backgroundColor!)
        }else if Int(currentPage) == 2{
            print("\(currentPage) is 2")
            self.delegate?.colorSwitcherScrollViewScrolled(color: self.view3.backgroundColor!)
        }else{
             print("\(currentPage) is others")
        }
    }
    
    @IBAction func profanitySwitchDidChange(_ sender: UISwitch) {
        self.delegate?.profanitfySwitchChanged()
        print("Profanity Switch Did Change")
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        self.delegate?.shareButtonTapped()
        print("shareButtonTapped")
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        self.delegate?.camerarollButtonTapped()
         print("cameraButtonTapped")
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        self.delegate?.facebookButtonTapped()
        print("facebookButtonTapped")
    }
    
    @IBAction func twitterButtonTapped(_ sender: UIButton) {
        self.delegate?.twitterButtonTapped()
        print("twitterButtonTapped")
    }

    lazy var view1 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.frame = CGRect(x: 10, y: 0, width: 90, height: 30)
        return view
    }()
    
    lazy var view2 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .purple
        view.frame = CGRect(x: 110, y: 0, width: 90, height: 30)
        return view
    }()
    
    lazy var view3 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.frame = CGRect(x: 210, y: 0, width: 90, height: 30)
        return view
    }()
    
}


