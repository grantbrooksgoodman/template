//
//  Sequence+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public extension Sequence where Iterator.Element: Equatable {
    var unique: [Iterator.Element] {
        var uniqueValues = [Iterator.Element]()
        for value in self where !uniqueValues.contains(value) {
            uniqueValues.append(value)
        }
        return uniqueValues
    }
}

public extension Sequence where Iterator.Element: Hashable {
    var unique: [Iterator.Element] {
        var seen = Set<Iterator.Element>()
        return filter { seen.insert($0).inserted }
    }
}
