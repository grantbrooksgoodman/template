//
//  Localization.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

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

    // MARK: - Initialize

    public static func initialize() {
        @Dependency(\.coreKit.utils) var coreUtilities: CoreKit.Utilities

        let unsupportedLanguageCodes = ["ba", "ceb", "jv", "la", "mr", "ms", "udm"]
        let supportedLanguages = localizedStrings["language_codes"]?.filter { !unsupportedLanguageCodes.contains($0.key) } ?? [:]
        RuntimeStorage.store(supportedLanguages, as: .languageCodeDictionary)

        if RuntimeStorage.languageCodeDictionary?[RuntimeStorage.languageCode] == nil || supportedLanguages.isEmpty {
            Logger.log(.init(
                "Unsupported language code; reverting to English.",
                metadata: [self, #file, #function, #line]
            ))

            coreUtilities.setLanguageCode("en")
        }
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

public extension Localization {
    struct LocalizedStringsDelegate: AppSubsystem.Delegates.LocalizedStringsDelegate {
        public var cancel: String { Localized(.cancel).wrappedValue }
        public var done: String { Localized(.done).wrappedValue }
        public var dismiss: String { Localized(.dismiss).wrappedValue }
        public var internetConnectionOffline: String { Localized(.internetConnectionOffline).wrappedValue }
        public var noEmail: String { Localized(.noEmail).wrappedValue }
        public var noInternetMessage: String { Localized(.noInternetMessage).wrappedValue }
        public var reportBug: String { Localized(.reportBug).wrappedValue }
        public var reportSent: String { Localized(.reportSent).wrappedValue }
        public var sendFeedback: String { Localized(.sendFeedback).wrappedValue }
        public var settings: String { Localized(.settings).wrappedValue }
        public var somethingWentWrong: String { Localized(.somethingWentWrong).wrappedValue }
        public var tapToReport: String { Localized(.tapToReport).wrappedValue }
        public var timedOut: String { Localized(.timedOut).wrappedValue }
        public var tryAgain: String { Localized(.tryAgain).wrappedValue }
        public var yesterday: String { Localized(.yesterday).wrappedValue }
    }
}
