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

public extension Array where Element == Any {
    var isValidMetadata: Bool {
        guard count == 3,
              self[0] is String,
              self[1] is String,
              self[2] is Int else { return false }
        return true
    }
}

public extension Array where Element == String {
    // MARK: - Properties

    var duplicates: [String]? {
        let duplicates = Array(Set(filter { (string: String) in filter { $0 == string }.count > 1 }))
        return duplicates.isEmpty ? nil : duplicates
    }

    // MARK: - Methods

    func containsAnyString(in array: [String]) -> Bool {
        !array.filter { contains($0) }.isEmpty
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

public extension Array where Element == LanguagePair {
    var unique: [LanguagePair] {
        var uniqueValues = [LanguagePair]()

        for pair in self where !uniqueValues.contains(pair) {
            uniqueValues.append(pair)
        }

        return uniqueValues
    }
}

public extension Array where Element == Translation {
    // MARK: - Properties

    var homogeneousLanguagePairs: Bool {
        !(uniqueLanguagePairs.count > 1)
    }

    var uniqueLanguagePairs: [LanguagePair] {
        map { $0.languagePair }.unique
    }

    // MARK: - Methods

    func matchedTo(_ inputs: [String: TranslationInput]) -> [String: Translation]? {
        var matched = [String: Translation]()

        for translation in self {
            guard let matchingInput = translation.matchingInput(inputs: inputs) else { continue }
            matched[matchingInput.key] = matchingInput.translation
        }

        return matched.count != inputs.count ? nil : matched
    }

    func `where`(languagePair: LanguagePair) -> [Translation] {
        filter { $0.languagePair.asString() == languagePair.asString() }
    }
}
