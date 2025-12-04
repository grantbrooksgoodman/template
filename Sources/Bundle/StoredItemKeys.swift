//
//  StoredItemKeys.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

extension StoredItemKey {
    static let `default`: StoredItemKey = .init("default")
}

extension RuntimeStorage {
    /* Add new static properties here for quick access. */

    static var `default`: String? { retrieve(.default) as? String }
}
