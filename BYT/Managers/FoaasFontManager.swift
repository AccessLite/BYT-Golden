//
//  FoaasFontManager.swift
//  BYT
//
//  Created by Harichandan Singh on 1/29/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

extension UIFont {
    /// Roboto can be referenced via extension in the following manner: 
    ///let font = UIFont.Roboto.light(size: 18.0)
    
    struct Roboto {
        //MARK: - Methods
        static func light(size: CGFloat) -> UIFont? {
            return UIFont(name: "Roboto-Light", size: size)
        }
        
        static func regular(size: CGFloat) -> UIFont? {
            return UIFont(name: "Roboto-Regular", size: size)
        }
        
        static func medium(size: CGFloat) -> UIFont? {
            return UIFont(name: "Roboto-Medium", size: size)
        }
        
    }
}

