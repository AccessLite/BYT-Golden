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
  
    @IBOutlet weak var versionNumberLabel: UILabel!
    @IBOutlet weak var versionMessageLabel: UILabel!
    @IBOutlet weak var offLabel: UILabel!
    @IBOutlet weak var onLabel: UILabel!
  @IBOutlet weak var profanityLabel: UILabel!
  @IBOutlet weak var colorPaletteLabel: UILabel!
  
    internal private(set) var foaasColorPickerView: FoaasColorPickerView?
  
    
    var delegate : FoaasSettingMenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let view = Bundle.main.loadNibNamed("FoaasSettingsMenuView", owner: self, options: nil)?.first as? UIView {
            //add a view to the subview
            self.addSubview(view)
            view.frame = self.bounds
          
//          let colorManagerColors = ColorManager.shared.colorSchemes.map { $0.primary }
          foaasColorPickerView = FoaasColorPickerView(colors: [.red, .blue, .green], baseUnit: 60.0)
          foaasColorPickerView?.translatesAutoresizingMaskIntoConstraints = false 
          self.addSubview(foaasColorPickerView!)
        
          [ foaasColorPickerView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            foaasColorPickerView!.centerYAnchor.constraint(equalTo: self.colorPaletteLabel.centerYAnchor),
          ].activate()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateVersionLabels() {
        self.versionNumberLabel.text = "V\(VersionManager.shared.currentVersion.number)"
        self.versionMessageLabel.text = "\(VersionManager.shared.currentVersion.message.uppercased()) BYT@BOARDINGPASS.COM"
    }

//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        //http://sweettutos.com/2015/04/13/how-to-make-a-horizontal-paging-uiscrollview-with-auto-layout-in-storyboards-swift/
//        //set the width
//        var number = 0
//        var pageWidth:CGFloat = self.colorSwitcherScrollView.frame.width
//        if number % 2 == 0 {
//            pageWidth = self.colorSwitcherScrollView.frame.width
//            number += 1
//        } else {
//            pageWidth = self.colorSwitcherScrollView.frame.width - CGFloat(40)
//            number += 1
//        }
//        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
//        
//        ColorManager.shared.currentColorScheme = ColorManager.shared.colorSchemes[Int(currentPage)]
//        self.delegate?.colorSwitcherScrollViewScrolled()
//    }
  
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
}


