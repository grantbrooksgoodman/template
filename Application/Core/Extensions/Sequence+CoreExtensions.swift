//
//  Sequence+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public extension Sequence where Iterator.Element: Hashable {
    var unique: [Iterator.Element] {
        var seen = Set<Iterator.Element>()
        return filter { seen.insert($0).inserted }
    }
}
