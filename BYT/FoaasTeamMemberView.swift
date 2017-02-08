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
    
    
    
    func configureConstraints() {
        _ = [
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            
            
            
        
        
        ]
    }
    
    func setUpViewHierarchy () {
        let views: [UIView] = [profileImageView, nameLabel, jobLabel, gitHubButton, twitterButton, linkedInButton]
        _ = views.map{ self.addSubview($0) }
        stripAutoResizingMasks([self] + views)
        
        gitHubButton.addTarget(self, action: #selector(gitHubButtonPressed), for: .touchUpInside)
        twitterButton.addTarget(self, action: #selector(twitterButtonPressed), for: .touchUpInside)
        linkedInButton.addTarget(self, action: #selector(linkedInButtonPressed), for: .touchUpInside)
    }
    
    //MARK: - Subviews
    var profileImageView: UIImageView = {
        let view = UIImageView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 4
        return view
    }()
    
    var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.Roboto.medium(size: 16)
        view.alpha = 0.87
        return view
    }()
    
    var jobLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.Roboto.light(size: 14)
        view.alpha = 0.5
        return view
    }()
    
    var gitHubButton: UIButton = {
        let view = UIButton(type: .system)
        //TODO Get a Github Button Image
        return view
    }()
    
    var twitterButton: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "icon_twitter"), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()
    
    var linkedInButton: UIButton = {
        let view = UIButton(type: .system)
        //TODO Get a linkedIn Button
        view.imageView?.contentMode = .scaleAspectFit
        return view
    }()
    
    //MARK: - Actions
    func gitHubButtonPressed () {
        self.delegate?.gitHubButtonPressed(member!.gitHubURL)
    }
    
    func twitterButtonPressed () {
        self.delegate?.twitterButtonPressed(member!.twitterURL)
    }
    
    func linkedInButtonPressed () {
        self.delegate?.linkedInButtonPressed(member!.linkedInURL)
    }
    
}
