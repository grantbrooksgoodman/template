//
//  Array+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Translator

public extension Array where Element == String {
    
    // MARK: - Properties
    
    var duplicates: [String]? {
        let duplicates = Array(Set(filter({ (s: String) in filter({ $0 == s }).count > 1})))
        return duplicates.isEmpty ? nil : duplicates
    }
    
    // MARK: - Methods
    
    func containsAnyString(in array: [String]) -> Bool {
        array.filter({ contains($0) }).count > 0
    }
    
    func containsAllStrings(in array: [String]) -> Bool {
        array.allSatisfy(contains)
    }
    
    func count(of query: String) -> Int {
        reduce(into: Int()) { partialResult, string in
            partialResult += string == query ? 1 : 0
        }
    }
}

public extension Array where Element == Translation {
    
    // MARK: - Properties
    
    var homogeneousLanguagePairs: Bool {
        !(map({ $0.languagePair.asString() }).unique().count > 1)
    }
    
    // MARK: - Methods
    
    func languagePairs() -> [LanguagePair] {
        map({ $0.languagePair.asString() }).unique().reduce(into: [LanguagePair]()) { partialResult, pairString in
            if let languagePair = pairString.asLanguagePair() {
                partialResult.append(languagePair)
            }
        }
    }
    
    func matchedTo(_ inputs: [String: TranslationInput]) -> [String: Translation]? {
        let matched = reduce(into: [String: Translation]()) { partialResult, translation in
            if let matchingInput = translation.matchingInput(inputs: inputs) {
                partialResult[matchingInput.key] = matchingInput.translation
            }
        }
        
        return matched.count != inputs.count ? nil : matched
    }
    
    func `where`(languagePair: LanguagePair) -> [Translation] {
        filter({ $0.languagePair.asString() == languagePair.asString() })
    }
}
