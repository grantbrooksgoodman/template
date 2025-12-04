//
//  TranslatedLabelStringCollection.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

extension TranslatedLabelStringCollection {
    /* Add methods here to expose new strings for on-the-fly translation. */

    static func samplePageView(_ key: SamplePageViewStringKey) -> TranslatedLabelStringCollection { .init(key.rawValue) }
}
