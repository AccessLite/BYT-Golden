//
//  FoaasTeamMemberView.swift
//  BYT
//
//  Created by C4Q on 2/6/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

protocol FoaasTeamMemberViewDelegate {
    func gitHubButtonPressed(_ url: URL)
    func twitterButtonPressed(_ url: URL)
    func linkedInButtonPressed(_ url: URL)
}

class FoaasTeamMemberView: UIView {
    var delegate: FoaasTeamMemberViewDelegate?
    var member: FoaasMember?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    //MARK: - Configure Constraints and View Hierarchy
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViewHierarchy()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureConstraints() {
        _ = [
            
            profileImageContainerView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageContainerView.heightAnchor.constraint(equalToConstant: 80),
            profileImageContainerView.widthAnchor.constraint(equalToConstant: 80),

            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4),
            nameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor),
            nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
            
            jobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            jobLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            jobLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor),
            jobLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
            
            twitterButton.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 2),
            twitterButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            twitterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            gitHubButton.centerYAnchor.constraint(equalTo: twitterButton.centerYAnchor),
            gitHubButton.trailingAnchor.constraint(equalTo: twitterButton.leadingAnchor, constant: -16),
            
            linkedInButton.centerYAnchor.constraint(equalTo: twitterButton.centerYAnchor),
            linkedInButton.leadingAnchor.constraint(equalTo: twitterButton.trailingAnchor, constant: 16)
            ].map { $0.isActive = true }
    }
    
    func setUpViewHierarchy () {
        profileImageContainerView.addSubview(profileImageView)
        let views: [UIView] = [profileImageContainerView, nameLabel, jobLabel, gitHubButton, twitterButton, linkedInButton]
        _ = views.map{ self.addSubview($0) }
        stripAutoResizingMasks([self, profileImageView] + views)
        
        gitHubButton.addTarget(self, action: #selector(gitHubButtonPressed), for: .touchUpInside)
        twitterButton.addTarget(self, action: #selector(self.twitterButtonPressed), for: .touchUpInside)
        linkedInButton.addTarget(self, action: #selector(linkedInButtonPressed), for: .touchUpInside)
    }
    
    func inputMember() {
        if let currentMember = self.member {
            //self.profileImageView.image = UIImage(named: currentMember.imageName)
            self.profileImageView.image = UIImage(named: "Material_Octo_No_Eyes")
            self.nameLabel.text = currentMember.name
            self.jobLabel.text = currentMember.job
        }
    }
    
    //MARK: - Subviews
    var profileImageContainerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 4
        view.layer.cornerRadius = 40
        return view
    }()
    
    var profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 40
        view.layer.borderWidth = 2.0
        view.layer.borderColor = ColorManager.shared.currentColorScheme.accent.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.Roboto.medium(size: 16)
        view.alpha = 0.87
        view.textAlignment = .center
        return view
    }()
    
    var jobLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.Roboto.light(size: 14)
        view.alpha = 0.5
        view.textAlignment = .center
        return view
    }()
    
    var gitHubButton: UIButton = {
        let view = UIButton(type: .system)
        let buttonImage = #imageLiteral(resourceName: "github_grayscale")
        view.tintColor = ColorManager.shared.currentColorScheme.accent
        view.setImage(buttonImage, for: .normal)
        return view
    }()
    
    var twitterButton: UIButton = {
        let view = UIButton(type: .system)
        let buttonImage = #imageLiteral(resourceName: "twitter_icon_inverted")
        view.tintColor = ColorManager.shared.currentColorScheme.accent
        view.setImage(buttonImage, for: .normal)
        //view.backgroundColor = ColorManager.shared.currentColorScheme.accent
        return view
    }()
    
    var linkedInButton: UIButton = {
        let view = UIButton(type: .system)
        let buttonImage = #imageLiteral(resourceName: "linkedIn_grayscale")
        let tintedImage = buttonImage.withRenderingMode(.alwaysTemplate)
        view.setImage(tintedImage, for: .normal)
        view.tintColor = ColorManager.shared.currentColorScheme.accent
        return view
    }()
    
    //MARK: - Actions
    func gitHubButtonPressed () {
        self.delegate!.gitHubButtonPressed(member!.gitHubURL)
    }
    
    func twitterButtonPressed () {
        print("pressed")
        self.delegate!.twitterButtonPressed(member!.twitterURL)
    }
    
    func linkedInButtonPressed () {
        self.delegate!.linkedInButtonPressed(member!.linkedInURL)
    }
    
}
