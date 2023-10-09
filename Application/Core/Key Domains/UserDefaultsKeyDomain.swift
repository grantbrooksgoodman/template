//
//  UserDefaultsKeyDomain.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public enum UserDefaultsKeyDomain {
    // MARK: - Cases

    case app(AppDefaultsKey)
    case core(CoreDefaultsKey)

    // MARK: - Properties

    public var keyValue: String {
        switch self {
        case let .app(key):
            return key.rawValue
        case let .core(key):
            return key.rawValue
        }
    }
}
