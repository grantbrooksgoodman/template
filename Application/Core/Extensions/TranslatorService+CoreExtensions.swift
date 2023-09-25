//
//  TranslatorService+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux
import Translator

public extension TranslatorService {
    func getTranslations(
        for inputs: [TranslationInput],
        languagePair: LanguagePair,
        hud hudConfig: (appearsAfter: Duration, isModal: Bool)? = nil,
        timeout timeoutConfig: (duration: Duration, returnsInputs: Bool) = (.seconds(10), true),
        using platform: PlatformName = .google
    ) async -> Callback<[Translation], Exception> {
        return await withCheckedContinuation { continuation in
            getTranslations(
                for: inputs,
                languagePair: languagePair,
                hud: hudConfig,
                timeout: timeoutConfig,
                using: platform
            ) { translations, exception in
                guard let translations else {
                    continuation.resume(returning: .failure(exception ?? .init(metadata: [#file, #function, #line])))
                    return
                }

                continuation.resume(returning: .success(translations))
            }
        }
    }

    func getTranslations(
        for inputs: [TranslationInput],
        languagePair: LanguagePair,
        hud hudConfig: (appearsAfter: Duration, isModal: Bool)? = nil,
        timeout timeoutConfig: (duration: Duration, returnsInputs: Bool) = (.seconds(10), true),
        using platform: PlatformName = .google,
        completion: @escaping (
            _ translations: [Translation]?,
            _ exception: Exception?
        ) -> Void
    ) {
        @Dependency(\.coreKit) var core: CoreKit
        var didComplete = false

        if let hudConfig {
            core.gcd.after(seconds: .init(hudConfig.appearsAfter.components.seconds)) {
                guard !didComplete else { return }
                core.hud.showProgress()
                guard hudConfig.isModal else { return }
                RuntimeStorage.topWindow?.isUserInteractionEnabled = false
            }
        }

        var canComplete: Bool {
            guard !didComplete else { return false }
            didComplete = true
            core.hud.hide()
            guard let hudConfig, hudConfig.isModal else { return true }
            RuntimeStorage.topWindow?.isUserInteractionEnabled = true
            return true
        }

        let timeout = Timeout(after: timeoutConfig.duration) {
            guard canComplete else { return }
            guard timeoutConfig.returnsInputs else {
                completion(nil, .timedOut([#file, #function, #line]))
                return
            }

            let translations = inputs.map { Translation(
                input: $0,
                output: $0.value().sanitized,
                languagePair: languagePair
            ) }
            completion(translations, nil)
        }

        getTranslations(
            for: inputs,
            languagePair: languagePair,
            using: platform,
            fetchFromArchive: true
        ) { translations, errorDescriptors in
            timeout.cancel()

            guard let translations,
                  !translations.isEmpty else {
                let exceptions = errorDescriptors?.reduce(into: [Exception]()) { partialResult, keyPair in
                    partialResult.append(.init(keyPair.key, metadata: [#file, #function, #line]))
                }.compiledException
                guard canComplete else { return }
                completion(nil, exceptions ?? .init(metadata: [#file, #function, #line]))
                return
            }

            guard canComplete else { return }
            completion(translations, nil)
        }
    }

    func translate(
        _ input: TranslationInput,
        with languagePair: LanguagePair,
        hud hudConfig: (appearsAfter: Duration, isModal: Bool)? = nil,
        timeout timeoutConfig: (duration: Duration, returnsInputs: Bool) = (.seconds(10), true),
        using platform: PlatformName = .google
    ) async -> Callback<Translation, Exception> {
        let getTranslationsResult = await getTranslations(
            for: [input],
            languagePair: languagePair,
            hud: hudConfig,
            timeout: timeoutConfig,
            using: platform
        )

        switch getTranslationsResult {
        case let .success(translations):
            return .success(translations[0])

        case let .failure(exception):
            return .failure(exception)
        }
    }
}
