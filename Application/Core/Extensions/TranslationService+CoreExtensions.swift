//
//  TranslationService+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import CoreArchitecture
import Translator

public extension TranslationService {
    func getTranslations(
        _ inputs: [TranslationInput],
        languagePair: LanguagePair,
        hud hudConfig: (appearsAfter: Duration, isModal: Bool)? = nil,
        timeout timeoutConfig: (duration: Duration, returnsInputs: Bool) = (.seconds(10), true)
    ) async -> Callback<[Translation], Exception> {
        return await withCheckedContinuation { continuation in
            getTranslations(
                inputs,
                languagePair: languagePair,
                hud: hudConfig,
                timeout: timeoutConfig
            ) { result in
                continuation.resume(returning: result)
            }
        }
    }

    func translate(
        _ input: TranslationInput,
        languagePair: LanguagePair,
        hud hudConfig: (appearsAfter: Duration, isModal: Bool)? = nil,
        timeout timeoutConfig: (duration: Duration, returnsInputs: Bool) = (.seconds(10), true)
    ) async -> Callback<Translation, Exception> {
        let getTranslationsResult = await getTranslations(
            [input],
            languagePair: languagePair,
            hud: hudConfig,
            timeout: timeoutConfig
        )

        switch getTranslationsResult {
        case let .success(translations):
            return .success(translations[0])

        case let .failure(exception):
            return .failure(exception)
        }
    }

    private func getTranslations(
        _ inputs: [TranslationInput],
        languagePair: LanguagePair,
        hud hudConfig: (appearsAfter: Duration, isModal: Bool)? = nil,
        timeout timeoutConfig: (duration: Duration, returnsInputs: Bool) = (.seconds(10), true),
        completion: @escaping (Callback<[Translation], Exception>) -> Void
    ) {
        @Dependency(\.coreKit) var core: CoreKit
        @Dependency(\.translationService) var translator: TranslationService
        @Dependency(\.uiApplication) var uiApplication: UIApplication
        var didComplete = false

        if let hudConfig {
            core.gcd.after(hudConfig.appearsAfter) {
                guard !didComplete else { return }
                core.hud.showProgress()
                guard hudConfig.isModal else { return }
                Task { @MainActor in
                    uiApplication.keyWindow?.isUserInteractionEnabled = false
                }
            }
        }

        var canComplete: Bool {
            guard !didComplete else { return false }
            didComplete = true
            core.hud.hide()
            guard let hudConfig, hudConfig.isModal else { return true }
            Task { @MainActor in
                uiApplication.keyWindow?.isUserInteractionEnabled = true
            }
            return true
        }

        let timeout = Timeout(after: timeoutConfig.duration) {
            guard canComplete else { return }
            guard timeoutConfig.returnsInputs else {
                completion(.failure(.timedOut([self, #file, #function, #line])))
                return
            }

            Logger.log(.timedOut([self, #file, #function, #line]))

            let translations = inputs.map { Translation(
                input: $0,
                output: $0.original.sanitized,
                languagePair: languagePair
            ) }
            completion(.success(translations))
        }

        Task {
            let getTranslationsResult = await translator.getTranslations(
                inputs,
                languagePair: languagePair
            )

            timeout.cancel()
            guard canComplete else { return }

            switch getTranslationsResult {
            case let .success(translations):
                completion(.success(translations))

            case let .failure(error):
                completion(.failure(.init(error, metadata: [self, #file, #function, #line])))
            }
        }
    }
}
