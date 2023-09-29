//
//  Localization.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum Localization {
    // MARK: - Properties

    private static var localizedStrings: [String: [String: String]] {
        @Dependency(\.mainBundle) var mainBundle: Bundle
        guard let filePath = mainBundle.url(forResource: "LocalizedStrings", withExtension: "plist"),
              let data = try? Data(contentsOf: filePath),
              let dictionary = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: [String: String]] else {
            return .init()
        }

        return dictionary
    }

    // MARK: - Methods

    public static func string(
        for case: LocalizedStringKey,
        language code: String
    ) -> String {
        guard !localizedStrings.isEmpty else { return "�" }

        guard let valuesForCase = localizedStrings[`case`.referent],
              let localizedString = valuesForCase[code] else {
            guard code != "en" else { return "�" }
            return string(for: `case`, language: "en")
        }

        return localizedString
    }
}
