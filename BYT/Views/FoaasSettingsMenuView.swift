//
//  FoaasSettingsMenuView.swift
//  BYT-anama118118
//
//  Created by Ana Ma on 1/13/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class FoaasSettingsMenuView: UIView, UIScrollViewDelegate, FoaasColorPickerViewDelegate {
    
    @IBOutlet weak var profanitySwitch: UISwitch!
    @IBOutlet weak var shareImageButton: UIButton!
    @IBOutlet weak var cameraRollButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!

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
            
            setupViewHierarchy()
            configureConstraints()
            self.profanitySwitch.onTintColor = ColorManager.shared.currentColorScheme.accent
            self.profanitySwitch.tintColor = ColorManager.shared.currentColorScheme.accent
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateVersionLabels() {
        self.versionNumberLabel.text = "V\(VersionManager.shared.currentVersion.number)"
        self.versionMessageLabel.text = "\(VersionManager.shared.currentVersion.message.uppercased())  GITHUB.COM/ACCESSLITE/BYT-GOLDEN"
    }
    
    private func configureConstraints() {
        foaasColorPickerView?.translatesAutoresizingMaskIntoConstraints = false
        [ foaasColorPickerView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
          foaasColorPickerView!.centerYAnchor.constraint(equalTo: self.colorPaletteLabel.centerYAnchor),
        ].activate()
    }
    
    private func setupViewHierarchy() {
        let colorManagerColors = ColorManager.shared.colorSchemes.map { $0.primary }
        foaasColorPickerView = FoaasColorPickerView(colors: colorManagerColors, baseUnit: 60.0)
        foaasColorPickerView?.delegate = self
        
        self.addSubview(foaasColorPickerView!)
    }
    
    // trying here to re initialize the colorPicker but not working properly
    
//    func reloadColorPicker() {
//        self.foaasColorPickerView?.removeConstraints((self.foaasColorPickerView?.constraints)!)
//        self.foaasColorPickerView = nil
//        
//        self.setupViewHierarchy()
//        self.configureConstraints()
//    }
    
    
    // MARK: - Color Picker Functions
    func didChangeColorPickerIndex(to index: Int) {
        // TODO: there should be a funciton to update the color scheme rather that directly assigning it
        //       to the singleton, from the singleton.
        ColorManager.shared.currentColorScheme = ColorManager.shared.colorSchemes[index]
        self.profanitySwitch.tintColor = ColorManager.shared.currentColorScheme.accent
        self.profanitySwitch.onTintColor = ColorManager.shared.currentColorScheme.accent
        self.delegate?.colorSwitcherScrollViewScrolled()
    }
    
    
    // MARK: - Actions
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


