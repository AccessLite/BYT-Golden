//
//  FoaasView.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

protocol FoaasViewDelegate: class {
    func didTapActionButton()
    func didTapSettingsButton()
}

class FoaasView: UIView {
    
    internal var delegate: FoaasViewDelegate?
    
    var subtitleLabelConstraint = NSLayoutConstraint()
  
  
    // MARK: - Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViewHierarchy()
        self.configureConstraints()
    }
    
    internal func setupViewHierarchy() {
        self.addSubview(resizingView)
        self.addSubview(addButton)
        self.addSubview(settingsMenuButton)
        resizingView.addSubview(self.mainTextLabel)
        resizingView.addSubview(self.subtitleTextLabel)
        
        resizingView.accessibilityIdentifier = "resizingView"
        addButton.accessibilityIdentifier = "addButton"
        settingsMenuButton.accessibilityIdentifier = "settingsMenuButton"
        mainTextLabel.accessibilityIdentifier = "mainTextLabel"
        subtitleTextLabel.accessibilityIdentifier = "subtitleTextLabel"
        
        stripAutoResizingMasks(self, resizingView, mainTextLabel, subtitleTextLabel , addButton, settingsMenuButton)
        self.backgroundColor = .purple
        self.settingsMenuButton.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
        self.addButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchDown)
    }
    
    internal func configureConstraints() {
        let resizingViewConstraints = [
            resizingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            resizingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            resizingView.topAnchor.constraint(equalTo: self.topAnchor),
            resizingView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -48.0)
        ]
        
        //self.subtitleLabelConstraint = subtitleTextLabel.leadingAnchor.constraint(equalTo: resizingView.leadingAnchor, constant: 225.0)
        self.subtitleLabelConstraint = subtitleTextLabel.leadingAnchor.constraint(greaterThanOrEqualTo: resizingView.leadingAnchor, constant: 16.0)
        
        let labelConstraints = [
            mainTextLabel.leadingAnchor.constraint(equalTo: resizingView.leadingAnchor, constant: 16.0),
            mainTextLabel.topAnchor.constraint(equalTo: resizingView.topAnchor, constant: 16.0),
            mainTextLabel.trailingAnchor.constraint(equalTo: resizingView.trailingAnchor, constant: -16.0),
            mainTextLabel.heightAnchor.constraint(equalTo: resizingView.heightAnchor, multiplier: 0.7),
            
            subtitleLabelConstraint,
            //subtitleTextLabel.leadingAnchor.constraint(equalTo: resizingView.leadingAnchor, constant: 16.0),
            subtitleTextLabel.trailingAnchor.constraint(equalTo: resizingView.trailingAnchor, constant: -16.0),
            subtitleTextLabel.topAnchor.constraint(equalTo: self.mainTextLabel.bottomAnchor, constant: 16.0),
            subtitleTextLabel.bottomAnchor.constraint(equalTo: resizingView.bottomAnchor, constant: -16.0),
        ]
        
        let buttonConstraints = [
            addButton.widthAnchor.constraint(equalToConstant: 54.0),
            addButton.heightAnchor.constraint(equalToConstant: 54.0),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48.0),
            addButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -48.0),
            
            settingsMenuButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            settingsMenuButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
        ]
        
        let _ = [resizingViewConstraints, labelConstraints, buttonConstraints].map{ $0.map{ $0.isActive = true } }
    }
    
    override func layoutSubviews() {
        // TOOD: adjust sizing
        self.configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Actions
    internal func didTapButton(sender: UIButton) {
        let newTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        let originalTransform = sender.imageView!.transform
        
        UIView.animate(withDuration: 0.1, animations: {
            sender.layer.transform = CATransform3DMakeAffineTransform(newTransform)
        }, completion: { (complete) in
            sender.layer.transform = CATransform3DMakeAffineTransform(originalTransform)
            self.delegate?.didTapActionButton()
        })
        
    }
    
    internal func didTapSettingsButton() {
        self.delegate?.didTapSettingsButton()
    }
  
  
    // MARK: - Lazy Inits
    internal lazy var resizingView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // TODO: fix this label to properly expand/shrink
    internal lazy var mainTextLabel: UILabel = {
        let label = UILabel()
        label.text = " "

        //updating font and color according to PM notes
        label.font = UIFont.Roboto.light(size: 56.0)

        label.textColor = UIColor.white
        label.alpha = 1.0
        
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        label.numberOfLines = 0
        return label
    }()
    
    internal lazy var subtitleTextLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        
        //updating font and color according to PM notes
        label.font = UIFont.Roboto.regular(size: 34.0)

        label.textColor = UIColor.white
        label.alpha = 0.70
        
        //PM spec has subtitle text aligned to the left
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.25
        label.numberOfLines = 0
        return label
    }()
    
    internal lazy var addButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "add_button")!, for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 8
        return button
    }()
    
    internal lazy var settingsMenuButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "disclosure_up"), for: .normal)
        return button
    }()
}
