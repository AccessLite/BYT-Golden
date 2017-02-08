//
//  LanguageFilterManager.swift
//  BYT
//
//  Created by C4Q on 2/1/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//
import Foundation

//TODO List:

//About View Controller
//Fixing the bug on constraint breaking after transition to view
//madison enter on both fields bug

typealias LanguageFilterClosure = (String) -> String
class LanguageFilter {
    
    private static let languageFilterKey = "filterDefaultPreference"
    private static let wordsToBeFiltered: Set<String> = ["fuck", "bitch", "ass", "dick", "pussy", "shit", "twat", "cock"]
    private static let wordsToBeUnfiltered: [String: String] = ["f*ck" : "u", "b*tch" : "i", "*ss" : "a", "d*ck": "i", "p*ssy": "u", "sh*t": "i", "tw*t" : "a", "c*ck" : "o"]
    private static let vowels: Set<Character> = ["a", "e", "i", "o", "u"]

        
    // MARK: - Checking/Saving State
    static var profanityAllowed: Bool {
        get { return UserDefaults.standard.bool(forKey: languageFilterKey) }
        set { UserDefaults.standard.set(newValue, forKey: languageFilterKey) }
    }
    
    
    // MARK: - Sanitize/Filter Text
    static func sanitize(text: String, using filter: LanguageFilterClosure) -> String {
        var words = text.components(separatedBy: " ")
        for (index, word) in words.enumerated() {
            let filtered = word.replacingOccurrences(of: word, with: filter(word), options: .caseInsensitive, range: nil)
            words[index] = filtered
        }
        return words.joined(separator: " ")
    }
    
    
    // MARK: - LanguageFilterClosure Options
    static let clean: LanguageFilterClosure = { word in
        for foulWord in wordsToBeFiltered where word.lowercased().contains(foulWord){
            for char in word.lowercased().characters where vowels.contains(char) {
                return word.replacingOccurrences(of: String(char), with: "*", options: .caseInsensitive, range: nil)
            }
        }
        return word
    }
    
    static let dirty: LanguageFilterClosure = { word in
        for filteredWord in wordsToBeUnfiltered.keys where word.lowercased().contains(filteredWord) {
            return word.replacingOccurrences(of: "*", with: wordsToBeUnfiltered[filteredWord]!, options: .caseInsensitive, range: nil)
        }
        return word
    }

}

extension String {
    func filterBadLanguage() -> String {
        let filter: LanguageFilterClosure = LanguageFilter.profanityAllowed ? LanguageFilter.clean : LanguageFilter.dirty
        return LanguageFilter.sanitize(text: self, using: filter)
    }
}
