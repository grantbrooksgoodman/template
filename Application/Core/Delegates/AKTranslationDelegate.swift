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

public struct TranslationDelegate: AlertKit.TranslationDelegate {
    // MARK: - Dependencies

    @Dependency(\.translationService) private var translator: TranslationService

    // MARK: - AKTranslationDelegate Conformance

    public func getTranslations(
        _ inputs: [TranslationInput],
        languagePair: LanguagePair,
        hud hudConfig: AlertKit.HUDConfig?,
        timeout timeoutConfig: AlertKit.TranslationTimeoutConfig
    ) async -> Result<[Translation], TranslationError> {
        var hudConfigTuple: (Duration, Bool)?
        if let hudConfig {
            hudConfigTuple = (hudConfig.appearsAfter, hudConfig.isModal)
        }

        let getTranslationsResult = await translator.getTranslations(
            inputs,
            languagePair: languagePair,
            hud: hudConfigTuple,
            timeout: (timeoutConfig.duration, timeoutConfig.returnsInputsOnFailure)
        )

        switch getTranslationsResult {
        case let .success(translations):
            return .success(translations)

        case let .failure(exception):
            return .failure(.unknown(exception.descriptor))
        }
    }
}
