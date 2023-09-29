//
//  StoredItems.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public enum StoredItemDomain {
    // MARK: - Cases

    /* Add cases here for each new RuntimeStorage domain. */

    case core(CoreStoredItem)

    // MARK: - Properties

    public var keyValue: String {
        switch self {
        case let .core(key):
            return key.rawValue
        }
    }
}

public extension RuntimeStorage {
    /* Add new static properties here for quick access. */
}
