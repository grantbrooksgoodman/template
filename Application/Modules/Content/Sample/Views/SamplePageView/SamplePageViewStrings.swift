//
//  SamplePageViewStrings.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Translator

public extension TranslatedLabelStringCollection {
    enum SamplePageViewStringKey: String, Equatable, CaseIterable, TranslatedLabelStringKey {
        case titleLabelText = "Hello World"
        case subtitleLabelText = "In Redux!"

        public var alternate: String? { nil }
    }
}

public enum SamplePageViewStrings: TranslatedLabelStrings {
    public static var keyPairs: [TranslationInputMap] {
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
