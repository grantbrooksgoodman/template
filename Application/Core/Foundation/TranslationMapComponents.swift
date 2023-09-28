//
//  TranslationMapComponents.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Translator

public protocol TranslatedLabelStrings {
    static var keyPairs: [TranslationInputMap] { get }
}

public protocol TranslatedLabelStringKey {
    var alternate: String? { get }
}

public struct TranslationInputMap: Equatable {
    // MARK: - Properties

    public let key: TranslatedLabelStringCollection
    public let input: TranslationInput

    // MARK: - Computed Properties

    public var defaultOutputMap: TranslationOutputMap {
        .init(key: key, value: input.value().sanitized)
    }

    // MARK: - Init

    public init(
        key: TranslatedLabelStringCollection,
        input: TranslationInput
    ) {
        self.key = key
        self.input = input
    }
}

public struct TranslationOutputMap: Equatable {
    // MARK: - Properties

    public let key: TranslatedLabelStringCollection
    public let value: String

    // MARK: - Init

    public init(
        key: TranslatedLabelStringCollection,
        value: String
    ) {
        self.key = key
        self.value = value
    }
}

public extension Array where Element == TranslationInputMap {
    var defaultOutputMap: [TranslationOutputMap] {
        map { $0.defaultOutputMap }
    }
}

public extension TranslatorService {
    func resolve(_ strings: TranslatedLabelStrings.Type) async -> Callback<[TranslationOutputMap], Exception> {
        let getTranslationsResult = await getTranslations(for: strings.keyPairs.map { $0.input }, languagePair: .system)

        switch getTranslationsResult {
        case let .success(translations):
            var outputs = [TranslationOutputMap]()
            for keyPair in strings.keyPairs {
                guard let translation = translations.first(where: { $0.input.value() == keyPair.input.value() }) else {
                    outputs.append(keyPair.defaultOutputMap)
                    continue
                }

                outputs.append(.init(key: keyPair.key, value: translation.output.sanitized))
            }
            return .success(outputs)

        case let .failure(error):
            return .failure(error)
        }
    }
}
