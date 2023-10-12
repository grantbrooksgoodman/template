//
//  Localized.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

@propertyWrapper
public struct Localized: Equatable {
    // MARK: - Properties

    private let key: LocalizedStringKey
    private let languageCode: String

    // MARK: - Init

    public init(
        _ key: LocalizedStringKey,
        languageCode: String = RuntimeStorage.languageCode
    ) {
        self.key = key
        self.languageCode = languageCode
    }

    // MARK: - WrappedValue

    public var wrappedValue: String {
        Localization.string(for: key, language: languageCode)
    }
}
