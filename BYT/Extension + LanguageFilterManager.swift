//
//  LanguageFilterManager.swift
//  BYT
//
//  Created by C4Q on 2/1/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import Foundation

var languageFilterToggle: Bool!

class LanguageFilterManager {
    
    static let shared = LanguageFilterManager()
    private init () {}
    
    let languageFilterKey = "filterDefaultPreference"
    
    func checkCurrentToggle () {
        if let savedToggleFromDefaults = UserDefaults.standard.value(forKey: languageFilterKey) as? Bool {
            languageFilterToggle = savedToggleFromDefaults
            print("Successfully loaded filter preference from UserDefaults")
            
        } else {
            languageFilterToggle = false
        }
    }
    
    // TODO: add save function here
    
    // TODO: move filtering functions here
    // TODO: filtering functions take a closure of (String) -> String
    
  
}

extension String {
  
    // TODO: slim down this call, maybe just as a computed property
    func filterBadLanguage (_ toggle: Bool) -> String {
        
        //implements the filter on itself.
        return toggle ? filterFoulWords(self) : unfilterFoulWords(self)
        
        let wordsToBeFiltered: Set<String> = ["fuck", "bitch", "ass", "dick", "pussy", "shit", "twat", "cock"]
        
        //I did this in a dictionary because I could store the word that needs to be filtered as well as the vowel that needs to replace the '*'
        let wordsToBeUnfiltered: [String: String] = ["f*ck" : "u", "b*tch" : "i", "*ss" : "a", "*ick": "i", "p*ssy": "u", "sh*t": "i", "tw*t" : "a", "c*ck" : "o"]
        let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
        
        //Breaks down the word into an Arr, where every word will be checked and filtered
        func filterFoulWords (_ previewText: String) -> String {
            var words = previewText.components(separatedBy: " ")
            for (index, word) in words.enumerated() {
                let filteredWord = word.replacingOccurrences(of: word, with: filter(word), options: .caseInsensitive, range: nil)
                words[index] = filteredWord
            }
            return words.joined(separator: " ")
        }
        //this is the filter, it checks to see if the word contains an instance of a foul word by iterating over the foul words. if it comes back true, then it will replace the first instance of a vowel excepting y with a * and return the updated word.
        
        func filter(_ word: String) -> String {
            for foulWord in wordsToBeFiltered where word.lowercased().contains(foulWord){
                for char in word.lowercased().characters where vowels.contains(char) {
                    return word.replacingOccurrences(of: String(char), with: "*", options: .caseInsensitive, range: nil)
                }
            }
            return word
        }
        
        
        //I chose to implelement an unfilter to be able to toggle the filter on a saved foaas on the main page, there might've been a way to go about doing this without implelementing this, but it seemed that this would be the clearest way to write it
        func unfilterFoulWords(_ previewText: String) -> String {
            var words = previewText.components(separatedBy: " ")
            for (index, word) in words.enumerated() {
                let filteredWord = word.replacingOccurrences(of: word, with: unfilter(word), options: .caseInsensitive, range: nil)
                words[index] = filteredWord
            }
            return words.joined(separator: " ")
        }
        
        func unfilter(_ word: String) -> String {
            for filteredWord in wordsToBeUnfiltered.keys where word.lowercased().contains(filteredWord) {
                return word.replacingOccurrences(of: "*", with: wordsToBeUnfiltered[filteredWord]!, options: .caseInsensitive, range: nil)
            }
            return word
        }
    }
}
