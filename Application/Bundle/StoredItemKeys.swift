//
//  StoredItemKeys.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public extension StoredItemKeyDomain {
    enum AppStoredItemKey: String {
        /* Add cases here for each new stored item reference key. */

        case `default`
    }
}

public extension RuntimeStorage {
    /* Add new static properties here for quick access. */

    static var `default`: String? { retrieve(.default) as? String }
}
