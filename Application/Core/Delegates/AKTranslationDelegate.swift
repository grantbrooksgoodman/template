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
import Redux
import Translator

public final class TranslationDelegate: AKTranslationDelegate {
    // MARK: - Dependencies

    @Dependency(\.translatorService) private var translator: TranslatorService

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
        let platform = using ?? .google
        translator.getTranslations(
            for: inputs.map { TranslationInput($0.original, alternate: $0.alternate) },
            languagePair: .init(from: languagePair.from, to: languagePair.to),
            hud: (requiresHUD ?? true) ? (appearsAfter: .seconds(5), isModal: true) : nil,
            using: platform.asPlatformName
        ) { translations, exception in
            guard let translations,
                  !translations.isEmpty else {
                let exceptionDescriptor = exception?.descriptor ?? Exception(metadata: [self, #file, #function, #line]).descriptor
                var descriptorPairs = [String: AlertKit.TranslationInput]()
                inputs.forEach { descriptorPairs[exceptionDescriptor] = AlertKit.TranslationInput($0.original, alternate: $0.alternate) }
                completion(nil, descriptorPairs)
                return
            }

            completion(
                translations.map {
                    AlertKit.Translation(
                        input: .init($0.input.original, alternate: $0.input.alternate),
                        output: $0.output,
                        languagePair: .init(from: $0.languagePair.from, to: $0.languagePair.to)
                    )
                }, nil
            )
        }
    }
}

private extension AlertKit.PlatformName {
    var asPlatformName: Translator.PlatformName {
        switch self {
        case .deepL:
            return .deepL
        case .google:
            return .google
        case .random:
            return .random
        case .reverso:
            return .reverso
        @unknown default:
            return .random
        }
    }
}
