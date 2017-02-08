//
//  FoaasMember.swift
//  BYT
//
//  Created by C4Q on 2/7/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import Foundation

class FoaasMember {
    var name: String
    var job: String
    var twitterURL: URL
    var linkedInURL: URL
    var gitHubURL: URL
    
    init(name: String, job: String, twitterURL: URL, linkedInURL: URL, gitHubURL: URL) {
        self.name = name
        self.job = job
        self.twitterURL = twitterURL
        self.linkedInURL = linkedInURL
        self.gitHubURL = gitHubURL
    }
    
    convenience init? (dict: [String: String]) {
        guard let name = dict["name"],
            let job = dict["job"],
            let twitterString = dict["twitterURL"],
            let linkedInString = dict["linkedInURL"],
            let gitHubString = dict["gitHubURL"],
            let twitterURL = URL(string: twitterString),
            let linkedInURL = URL(string: linkedInString),
            let gitHubURL = URL(string: gitHubString) else { return nil }
        
        self.init(name: name, job: job, twitterURL: twitterURL, linkedInURL: linkedInURL, gitHubURL: gitHubURL)
    }
}
