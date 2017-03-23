//
//  Profanity.swift
//  BYT
//
//  Created by Louis Tur on 2/3/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//
import Foundation

// TODO: explore profanity filtering using a struct
// TODO: this will need testing if wanting to implement
struct Profanity {
  var clean: String = ""
  var dirty: String = ""
  private var removedLetter: String? = nil
  
  private let vowels: CharacterSet = CharacterSet(charactersIn: "aeiou")
  private let censor: String = "*"
  
  init(_ word: String) {
    clean = self.clean(word)
    dirty = self.dirty(word)
  }
  
  private mutating func clean(_ word: String) -> String {
    guard let firstVowel = word.rangeOfCharacter(from: vowels) else {
      return word
    }
    removedLetter = String(word.characters[firstVowel])
    return word.replacingCharacters(in: firstVowel, with: censor)
  }
  
  private mutating func dirty(_ word: String) -> String {
    guard let censoredLetter = word.range(of: censor), removedLetter != nil else {
      return word
    }
    return word.replacingCharacters(in: censoredLetter, with: removedLetter!)
  }
}
