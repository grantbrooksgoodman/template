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
    // MARK: - Properties

    static var system: LanguagePair {
        .init(from: "en", to: RuntimeStorage.languageCode)
    }

    // MARK: - Methods

    convenience init?(_ string: String) {
        let components = string.components(separatedBy: "-")
        guard !components.isEmpty else { return nil }

        let fromValue = components[0].lowercasedTrimmingWhitespaceAndNewlines
        guard components.count > 1 else {
            self.init(from: fromValue, to: fromValue)
            return
        }

        let toValue = components[1 ... components.count - 1].joined().lowercasedTrimmingWhitespaceAndNewlines
        self.init(from: fromValue, to: toValue)
    }
}
