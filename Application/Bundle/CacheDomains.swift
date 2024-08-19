//
//  CacheDomains.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public extension CoreKit.Utilities {
    // MARK: - Types

    enum CacheDomain: CaseIterable {
        case localization
    }

    // MARK: - Clear Caches

    func clearCaches(domains: [CacheDomain] = CacheDomain.allCases) {
        if domains.contains(.localization) { Localization.clearCache() }
    }
}
