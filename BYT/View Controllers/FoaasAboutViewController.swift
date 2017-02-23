//
//  FoaasAboutViewController.swift
//  BYT
//
//  Created by C4Q on 2/8/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasAboutViewController: UIViewController, FoaasTeamMemberViewDelegate {
    
    let safari = UIApplication.shared
    var teamMembers: [FoaasMember] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseTeamMembers()
        configureViewColours()
        setUpViewHierarchy()
        configureConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpOctoView()
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.octoImageView.removeFromSuperview()
    }
    
    func setUpViewHierarchy() {
        self.view.addSubview(primaryColourStatusBar)
        self.view.addSubview(closeButton)
        self.setUpMemberViews()
    }
    
    func configureConstraints() {
        stripAutoResizingMasks([closeButton, primaryColourStatusBar, octoImageView])
        
        _ = [
            closeButton.heightAnchor.constraint(equalToConstant: 54),
            closeButton.widthAnchor.constraint(equalToConstant: 54),
            closeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            closeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -48),
            
            primaryColourStatusBar.heightAnchor.constraint(equalToConstant: UIApplication.shared.statusBarFrame.height),
            primaryColourStatusBar.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            primaryColourStatusBar.topAnchor.constraint(equalTo: self.view.topAnchor)
            ].map { $0.isActive = true }
        
    }
    
    func setUpOctoView () {
        self.view.addSubview(octoImageView)
        self.view.sendSubview(toBack: octoImageView)
        _ = [ octoImageView.topAnchor.constraint(equalTo: primaryColourStatusBar.bottomAnchor),
              octoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -self.view.frame.width * 0.25),
              octoImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.9),
              octoImageView.widthAnchor.constraint(equalTo: self.octoImageView.heightAnchor)
            ].map { $0.isActive = true }
        octoImageView.alpha = 0.2
        let animation = UIViewPropertyAnimator(duration: 0.25, curve: .linear) {
            self.octoImageView.alpha = 1.0
        }
        animation.startAnimation()
    }
    
    func setUpMemberViews () {
        var previousView: FoaasTeamMemberView?
        var leftView: FoaasTeamMemberView?
        for (index, member) in teamMembers.enumerated() {

            let newView = FoaasTeamMemberView()
            newView.member = member
            newView.delegate = self
            newView.inputMember()
            self.view.addSubview(newView)
            switch index {
            case 0:
                _ = [
                    newView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    newView.topAnchor.constraint(equalTo: self.primaryColourStatusBar.bottomAnchor, constant: 16),
                    ].map { $0.isActive = true }
                previousView = newView
            case _ where index % 2 == 1:
                _ = [
                    newView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -self.view.frame.width * 0.25),
                    newView.topAnchor.constraint(equalTo: previousView!.bottomAnchor, constant: 24)
                    ].map { $0.isActive = true }
                previousView = newView
                leftView = newView
            default:
                _ = [
                    newView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width * 0.25),
                    newView.topAnchor.constraint(equalTo: leftView!.topAnchor)
                    ].map { $0.isActive = true }
            }
        }
    }
    
    func configureViewColours() {
        self.view.backgroundColor = .white
    }
    
    //MARK: - Helper Functions
    func parseTeamMembers () {
        guard let path = Bundle.main.path(forResource: "members", ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options:  NSData.ReadingOptions.mappedIfSafe),
            let membersJSON = try? JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String: String]]
            else { return }
        for memberDict in membersJSON {
            if let validMember = FoaasMember(dict: memberDict) {
                teamMembers.append(validMember)
            }
        }
        
        
    }
    
    //MARK: - Views
    
    internal lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(closeButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        button.setImage(UIImage(named: "x_symbol")!, for: .normal)
        button.backgroundColor = ColorManager.shared.currentColorScheme.accent
        button.layer.cornerRadius = 26
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 5
        button.clipsToBounds = false
        return button
    }()
    
    var primaryColourStatusBar: UIView =  {
        let view = UIView()
        view.backgroundColor = ColorManager.shared.currentColorScheme.primary
        return view
    }()
    
    var octoImageView: UIImageView = {
        let view = UIImageView()
        let image = #imageLiteral(resourceName: "octopus_grayscale")
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        view.tintColor = ColorManager.shared.currentColorScheme.primaryLight//.withAlphaComponent(0.6)
        view.image = tintedImage
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    //MARK: Actions
    
    func closeButtonClicked(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - FoaasTeamMemberView Delegate Methods --Should this be condensed into one universal action for all buttons, or is this a little bit more legible?
    func twitterButtonPressed(_ url: URL) {
        safari.open(url, options: [:], completionHandler: nil)
    }
    
    func linkedInButtonPressed(_ url: URL) {
        safari.open(url, options: [:], completionHandler: nil)
    }
    
    func gitHubButtonPressed(_ url: URL) {
        safari.open(url, options: [:], completionHandler: nil)
    }
}
