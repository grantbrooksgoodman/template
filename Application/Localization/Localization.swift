//
//  Localization.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public enum Localization {
    // MARK: - Types

    private enum CacheKey: String, CaseIterable {
        case localizedStrings
    }

    // MARK: - Properties

    @Cached(CacheKey.localizedStrings) private static var cachedLocalizedStrings: [String: [String: String]]?

    // MARK: - Computed Properties

    public static var localizedStrings: [String: [String: String]] {
        @Dependency(\.mainBundle) var mainBundle: Bundle
        if let cachedLocalizedStrings,
           !cachedLocalizedStrings.isEmpty {
            return cachedLocalizedStrings
        }

        guard let filePath = mainBundle.url(forResource: "LocalizedStrings", withExtension: "plist"),
              let data = try? Data(contentsOf: filePath),
              let dictionary = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: [String: String]] else {
            return .init()
        }

        cachedLocalizedStrings = dictionary
        return dictionary
    }

    // MARK: - String for Key

    public static func string(
        for key: LocalizedStringKey,
        language languageCode: String
    ) -> String {
        guard !localizedStrings.isEmpty else { return "�" }
        guard let valuesForKey = localizedStrings[key.referent],
              let localizedString = valuesForKey[languageCode] else {
            guard languageCode != "en" else { return "�" }
            return string(for: key, language: "en")
        }
        return localizedString
    }

    // MARK: - Clear Cache

    public static func clearCache() {
        cachedLocalizedStrings = nil
    }
}
