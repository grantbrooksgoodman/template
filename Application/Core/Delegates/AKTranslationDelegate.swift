//
//  AKTranslationDelegate.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import AlertKit
import CoreArchitecture
import Translator

public final class TranslationDelegate: AKTranslationDelegate {
    // MARK: - Dependencies

    @Dependency(\.translationService) private var translator: TranslationService

    // MARK: - AKTranslationDelegate Conformance

    // swiftlint:disable:next function_parameter_count
    public func getTranslations(
        for inputs: [AlertKit.TranslationInput],
        languagePair: AlertKit.LanguagePair,
        requiresHUD: Bool?,
        using: AlertKit.PlatformName?,
        fetchFromArchive: Bool,
        completion: @escaping (
            _ translations: [AlertKit.Translation]?,
            _ errorDescriptors: [String: AlertKit.TranslationInput]?
        ) -> Void
    ) {
        Task {
            let getTranslationsResult = await translator.getTranslations(
                inputs.map { TranslationInput($0.original, alternate: $0.alternate) },
                languagePair: .init(from: languagePair.from, to: languagePair.to),
                hud: (requiresHUD ?? true) ? (appearsAfter: .seconds(5), isModal: true) : nil
            )

            switch getTranslationsResult {
            case let .success(translations):
                completion(
                    translations.map {
                        AlertKit.Translation(
                            input: .init($0.input.original, alternate: $0.input.alternate),
                            output: $0.output,
                            languagePair: .init(from: $0.languagePair.from, to: $0.languagePair.to)
                        )
                    }, nil
                )

            case let .failure(exception):
                var descriptorPairs = [String: AlertKit.TranslationInput]()
                inputs.forEach { descriptorPairs[exception.descriptor] = AlertKit.TranslationInput($0.original, alternate: $0.alternate) }
                completion(nil, descriptorPairs)
            }
        }
    }
}
