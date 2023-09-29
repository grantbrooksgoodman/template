//
//  UserDefaultsKeys.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public enum UserDefaultsKeyDomain {
    // MARK: - Cases

    /* Add cases here for each new UserDefaultsKey domain. */

    case core(CoreDefaultsKey)

    // MARK: - Properties

    public var keyValue: String {
        switch self {
        case let .core(key):
            return key.rawValue
        }
    }
}
