//
//  Primitives+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux
import Translator

// MARK: - Float

public extension Float {
    var durationString: String {
        if self < 60 {
            return String(format: "0:%.02d", Int(self.rounded(.up)))
        } else if self < 3600 {
            return String(format: "%.02d:%.02d", Int(self / 60), Int(self) % 60)
        } else {
            let hours = Int(self / 3600)
            let remainingMinutesInSeconds = Int(self) - hours * 3600
            
            return String(format: "%.02d:%.02d:%.02d",
                          hours,
                          Int(remainingMinutesInSeconds / 60),
                          Int(remainingMinutesInSeconds) % 60)
        }
    }
}


// MARK: - Int

public extension Int {
    var ordinalValueString: String {
        var suffix = "th"
        
        switch self % 10 {
        case 1:
            suffix = "st"
        case 2:
            suffix = "nd"
        case 3:
            suffix = "rd"
        default: ()
        }
        
        if (self % 100) > 10 && (self % 100) < 20 {
            suffix = "th"
        }
        return String(self) + suffix
    }
}

// MARK: - String

public extension String {
    
    /* MARK: Properties */
    
    var alphabeticalPosition: Int? {
        guard count == 1 else { return nil }
        
        let alphabet = Array("abcdefghijklmnopqrstuvwxyz")
        let character = Character(lowercased())
        
        guard alphabet.contains(character),
              let index = alphabet.firstIndex(of: character) else { return nil }
        
        return index + 1
    }
    
    var components: [String] {
        return map { String($0) }
    }
    
    var firstLowercase: String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    var firstUppercase: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    var isAlphabetical: Bool {
        return "A"..."Z" ~= self || "a"..."z" ~= self
    }
    
    var isLowercase: Bool {
        return self == self.lowercased()
    }
    
    var isUppercase: Bool {
        return self == self.uppercased()
    }
    
    var languageEndonym: String? {
        guard let languageName else { return nil }
        var components = languageName.components(separatedBy: " (")
        guard components.count > 1 else { return nil }
        components = components[1].components(separatedBy: ")")
        return components[0].trimmingBorderedWhitespace
    }
    
    var languageExonym: String? {
        guard let languageName else { return nil }
        let components = languageName.components(separatedBy: " (")
        guard !components.isEmpty else { return languageName }
        return components[0].trimmingBorderedWhitespace
    }
    
    var languageName: String? {
        @Dependency(\.coreKit.utils) var utils: CoreKit.Utilities
        
        guard self != "",
              self.lowercasedTrimmingWhitespace != "",
              let languageCodes = utils.localizedLanguageCodeDictionary,
              let name = languageCodes[self] ?? languageCodes[self.lowercasedTrimmingWhitespace] else { return nil }
        
        return name.trimmingBorderedWhitespace
    }
    
    var lowercasedTrimmingWhitespace: String {
        return trimmingCharacters(in: .whitespacesAndNewlines).lowercased().trimmingWhitespace
    }
    
    var sanitized: String {
        removingOccurrences(of: ["*", "⌘"])
    }
    
    var snakeCased: String {
        var characters = components
        func satisfiesConstraints(_ character: String) -> Bool {
            character.isAlphabetical && character.isUppercase
        }
        
        for (index, character) in characters.enumerated() where satisfiesConstraints(character) {
            characters[index] = "_\(character.lowercased())"
        }
        
        return characters.joined()
    }
    
    var trimmingBorderedWhitespace: String {
        return trimmingLeadingWhitespace.trimmingTrailingWhitespace
    }
    
    var trimmingLeadingWhitespace: String {
        var mutableSelf = self
        
        while mutableSelf.hasPrefix(" ") || mutableSelf.hasPrefix("\u{00A0}") {
            mutableSelf = mutableSelf.dropPrefix(1)
        }
        
        return mutableSelf
    }
    
    var trimmingTrailingWhitespace: String {
        var mutableSelf = self
        
        while mutableSelf.hasSuffix(" ") || mutableSelf.hasSuffix("\u{00A0}") {
            mutableSelf = mutableSelf.dropSuffix(1)
        }
        
        return mutableSelf
    }
    
    var trimmingWhitespace: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\u{00A0}", with: "")
    }
    
    /* MARK: Methods */
    
    func asLanguagePair() -> LanguagePair? {
        let components = self.components(separatedBy: "-")
        guard components.count > 1 else { return nil }
        return LanguagePair(from: components[0], to: components[1...components.count - 1].joined(separator: "-"))
    }
    
    func attributed(mainAttributes: [NSAttributedString.Key: Any],
                    alternateAttributes: [NSAttributedString.Key: Any],
                    alternateAttributeRange: [String]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self, attributes: mainAttributes)
        
        for string in alternateAttributeRange {
            let currentRange = (self as NSString).range(of: (string as NSString) as String)
            attributedString.addAttributes(alternateAttributes, range: currentRange)
        }
        
        return attributedString
    }
    
    func ciphered(by modifier: Int) -> String {
        var shiftedCharacters = [Character]()
        
        for utf8Value in utf8 {
            let shiftedValue = Int(utf8Value) + modifier
            let wrapAroundBy = shiftedValue > 97 + 25 ? -26 : (shiftedValue < 97 ? 26 : 0)
            guard let scalar = UnicodeScalar(shiftedValue + wrapAroundBy) else { continue }
            shiftedCharacters.append(Character(scalar))
        }
        
        return String(shiftedCharacters)
    }
    
    func containsAnyCharacter(in string: String) -> Bool {
        components.filter({ string.components.contains($0) }).count > 0
    }
    
    func dropPrefix(_ dropping: Int = 1) -> String {
        guard count > dropping else { return "" }
        return String(suffix(from: index(startIndex, offsetBy: dropping)))
    }
    
    func dropSuffix(_ dropping: Int = 1) -> String {
        guard count > dropping else { return "" }
        return String(prefix(count - dropping))
    }
    
    func isAnyString(in array: [String]) -> Bool {
        array.filter({ self == $0 }).count > 0
    }
    
    func removingOccurrences(of excludedStrings: [String]) -> String {
        var mutable = self
        excludedStrings.forEach { string in
            mutable = mutable.replacingOccurrences(of: string, with: "")
        }
        return mutable
    }
}
