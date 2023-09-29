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

extension LanguagePair: Equatable {
    public static func == (left: LanguagePair, right: LanguagePair) -> Bool {
        guard left.from == right.from,
              left.to == right.to else { return false }
        return true
    }
}

public extension LanguagePair {
    static var system: LanguagePair {
        .init(from: "en", to: RuntimeStorage.languageCode ?? "en")
    }
}
