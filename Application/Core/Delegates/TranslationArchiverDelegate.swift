//
//  TranslationArchiverDelegate.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture
import Translator

public final class LocalTranslationArchiverDelegate: TranslationArchiverDelegate {
    // MARK: - Types

    private enum CacheKey: String, CaseIterable {
        case archive
        case translationsForInputValueEncodedHashes
    }

    // MARK: - Properties

    // Array
    @Cached(CacheKey.archive) private var cachedArchive: [Translation]?
    @Persistent(.translationArchive) private var persistedArchive: [Translation]?

    // Dictionary
    // swiftlint:disable:next identifier_name
    @Cached(CacheKey.translationsForInputValueEncodedHashes) private var cachedTranslationsForInputValueEncodedHashes: [String: Translation]?

    // MARK: - Computed Properties

    private var archive: [Translation] {
        get { cachedArchive ?? persistedArchive ?? [] }

        set {
            cachedArchive = newValue
            persistedArchive = newValue
        }
    }

    // MARK: - Init

    fileprivate init() {}

    // MARK: - Register with Dependencies

    public static func registerWithDependencies() {
        @Dependency(\.translatorConfig) var translatorConfig: Translator.Config
        translatorConfig.registerArchiverDelegate(LocalTranslationArchiverDelegate())
    }

    // MARK: - Add Value

    public func addValue(_ translation: Translation) {
        archive.removeAll(where: { $0 == translation })
        archive.append(translation)

        cachedTranslationsForInputValueEncodedHashes = cachedTranslationsForInputValueEncodedHashes?.filter { $0.value != translation }
    }

    // MARK: - Get Value

    public func getValue(inputValueEncodedHash hash: String, languagePair: LanguagePair) -> Translation? {
        // swiftlint:disable:next identifier_name
        if let cachedTranslationsForInputValueEncodedHashes,
           let cachedValue = cachedTranslationsForInputValueEncodedHashes[hash],
           cachedValue.languagePair == languagePair {
            return cachedValue
        }

        guard let translation = archive.first(where: {
            $0.input.value.encodedHash == hash && $0.languagePair == languagePair
        }) else { return nil }

        var newCacheValue = cachedTranslationsForInputValueEncodedHashes ?? [:]
        newCacheValue[hash] = translation
        cachedTranslationsForInputValueEncodedHashes = newCacheValue

        return translation
    }

    // MARK: - Remove Value

    public func removeValue(inputValueEncodedHash hash: String, languagePair: LanguagePair) {
        func satisfiesConstraints(_ translation: Translation) -> Bool {
            translation.input.value.encodedHash == hash && translation.languagePair == languagePair
        }

        archive.removeAll(where: { satisfiesConstraints($0) })
        cachedTranslationsForInputValueEncodedHashes = cachedTranslationsForInputValueEncodedHashes?.filter { !satisfiesConstraints($0.value) }
    }

    // MARK: - Clear Archive

    public func clearArchive() {
        archive = []
        cachedTranslationsForInputValueEncodedHashes = nil
    }
}

/* MARK: Dependency */

public enum LocalTranslationArchiverDependency: DependencyKey {
    public static func resolve(_ dependencies: DependencyValues) -> LocalTranslationArchiverDelegate {
        (dependencies.translatorConfig.archiverDelegate as? LocalTranslationArchiverDelegate) ?? .init()
    }
}

public extension DependencyValues {
    var localTranslationArchiver: LocalTranslationArchiverDelegate {
        get { self[LocalTranslationArchiverDependency.self] }
        set { self[LocalTranslationArchiverDependency.self] = newValue }
    }
}
