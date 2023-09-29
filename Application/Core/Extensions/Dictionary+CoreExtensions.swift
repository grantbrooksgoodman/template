//
//  Dictionary+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public extension Dictionary {
    mutating func replace(key: Key, with newKey: Key) {
        guard let value = removeValue(forKey: key) else { return }
        self[newKey] = value
    }
}

public extension Dictionary where Key == String, Value == Any {
    var withCapitalizedKeys: [String: Any] {
        var capitalized = [String: Any]()
        keys.forEach { capitalized[$0.firstUppercase] = self[$0]! }
        return capitalized
    }
}

public extension Dictionary where Value: Equatable {
    func keys(for value: Value) -> [Key] {
        filter { $1 == value }.map { $0.0 }
    }
}
