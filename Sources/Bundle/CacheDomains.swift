//
//  CacheDomains.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

public extension CacheDomain {
    // MARK: - Types

    struct List: AppSubsystem.Delegates.CacheDomainListDelegate {
        public var allCacheDomains: [CacheDomain] {
            [
                .encodedHash,
                .localization,
                .localTranslationArchive,
            ]
        }
    }

    // MARK: - Properties

    static let localization: CacheDomain = .init("localization")
}

public extension CoreKit.Utilities {
    func clearCaches(_ domains: [CacheDomain] = CacheDomain.allCases) {
        let appDomains = clearCaches(domains: domains)

        if appDomains.contains(.localization) { Localization.clearCache() }
    }
}
