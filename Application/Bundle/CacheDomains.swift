//
//  CacheDomains.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/**
 Use this enum to define domains for new objects conforming to `Cacheable`.
 */
public enum CacheDomain: Equatable, Hashable {
    // MARK: - Cases

    case `default`(DefaultCacheDomainKey)

    // MARK: - Properties

    public var rawValue: String {
        switch self {
        case let .default(key):
            return key.rawValue
        }
    }
}

public enum DefaultCacheDomainKey: String {
    case cacheableValueKey
}
