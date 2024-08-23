//
//  CacheDomains.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public extension CoreKit.Utilities {
    // MARK: - Types

    enum CacheDomain: CaseIterable {
        case encodedHash
        case localization
        case localTranslationArchive
    }

    // MARK: - Clear Caches

    func clearCaches(domains: [CacheDomain] = CacheDomain.allCases) {
        @Dependency(\.localTranslationArchiver) var localTranslationArchiver: LocalTranslationArchiverDelegate

        if domains.contains(.encodedHash) { EncodedHashCache.clearCache() }
        if domains.contains(.localization) { Localization.clearCache() }
        if domains.contains(.localTranslationArchive) { localTranslationArchiver.clearArchive() }
    }
}
