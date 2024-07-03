//
//  Array+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public extension Array {
    /// Convenience method which eliminates the need to guard against out of bounds errors.
    func itemAt(_ index: Int) -> Element? {
        guard index > -1, count > index else { return nil }
        return self[index]
    }
}

public extension Array where Element == Any {
    var isValidMetadata: Bool {
        guard count == 4,
              !String(self[0]).isEmpty,
              self[1] is String,
              self[2] is String,
              self[3] is Int else { return false }
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
