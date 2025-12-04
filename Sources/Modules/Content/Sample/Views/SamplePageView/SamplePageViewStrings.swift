//
//  SamplePageViewStrings.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem
import Translator

extension TranslatedLabelStringCollection {
    enum SamplePageViewStringKey: String, Equatable, CaseIterable, TranslatedLabelStringKey {
        // MARK: - Cases

        case titleLabelText = "Hello World"
        case subtitleLabelText = "In Redux!"

        // MARK: - Properties

        var alternate: String? { nil }
    }
}

enum SamplePageViewStrings: TranslatedLabelStrings {
    static var keyPairs: [TranslationInputMap] {
        TranslatedLabelStringCollection.SamplePageViewStringKey.allCases
            .map {
                TranslationInputMap(
                    key: .samplePageView($0),
                    input: .init(
                        $0.rawValue,
                        alternate: $0.alternate
                    )
                )
            }
    }
}
