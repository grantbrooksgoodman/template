//
//  LanguagePair+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Translator

public extension LanguagePair {
    static var system: LanguagePair {
        .init(from: "en", to: RuntimeStorage.languageCode ?? "en")
    }
}
