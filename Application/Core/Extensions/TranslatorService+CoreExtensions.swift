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
    func getTranslations(for inputs: [TranslationInput],
                         languagePair: LanguagePair,
                         requiresHUD: Bool? = nil,
                         using: PlatformName? = nil) async -> Callback<[Translation], Exception> {
        let getTranslationsResult = await getTranslations(for: inputs,
                                                          languagePair: languagePair,
                                                          requiresHUD: requiresHUD,
                                                          using: using,
                                                          fetchFromArchive: true)
        
        switch getTranslationsResult {
        case let .success(translations):
            return .success(translations)
            
        case let .failure(error):
            return .failure(.init(error, metadata: [#file, #function, #line]))
        }
    }
    
    func translate(_ input: TranslationInput,
                   with languagePair: LanguagePair,
                   requiresHUD: Bool? = nil,
                   using: PlatformName? = nil) async -> Callback<Translation, Exception> {
        let translateResult = await translate(input,
                                              with: languagePair,
                                              using: using ?? .google,
                                              fetchFromArchive: true)
        
        switch translateResult {
        case let .success(translation):
            return .success(translation)
            
        case let .failure(error):
            return .failure(.init(error, metadata: [#file, #function, #line]))
        }
    }
}
