//
//  SampleViewStrings.swift
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
    enum SampleViewStringKey: String, Equatable, CaseIterable, TranslatedLabelStringKey {
        case titleLabelText = "Hello World"
        case subtitleLabelText = "In Redux!"

        public var alternate: String? { nil }
    }
}

public enum SampleViewStrings: TranslatedLabelStrings {
    public static var keyPairs: [TranslationInputMap] {
        TranslatedLabelStringCollection.SampleViewStringKey.allCases
            .map {
                TranslationInputMap(
                    key: .sampleView($0),
                    input: .init(
                        $0.rawValue,
                        alternate: $0.alternate
                    )
                )
            }
    }
}

public extension Array where Element == TranslationOutputMap {
    func value(for key: TranslatedLabelStringCollection.SampleViewStringKey) -> String {
        (first(where: { $0.key == .sampleView(key) })?.value ?? key.rawValue).sanitized
    }
}
