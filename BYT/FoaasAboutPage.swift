//
//  FoaasAboutPage.swift
//  BYT
//
//  Created by C4Q on 2/6/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasAboutPage: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Constraints and View Hierarchy
    func setupViewHierarchy () {
        
    }
    
    func configureConstraints () {
    }
    
    //Subviews
    var profileImageView: UIImageView = {
       let view = UIImageView()
        return view
    }()
    
    var nameLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    var jobLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    var gitHubButton: UIButton = {
        let view = UIButton(type: .system)
        return view
    }()
    
    var faceBookButton: UIButton = {
        let view = UIButton(type: .system)
        return view
    }()
    
    var linkedInButton: UIButton = {
        let view = UIButton(type: .system)
        return view
    }()
    
    
}
