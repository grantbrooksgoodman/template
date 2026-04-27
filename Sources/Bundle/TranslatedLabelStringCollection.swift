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

/// Use this extension to expose new strings for on-the-fly
/// translation.
///
/// Add a static method for each view that requires translated labels.
/// The method accepts a view-specific
/// ``TranslatedLabelStringKey``-conforming enum case and returns a
/// ``TranslatedLabelStringCollection`` that the translation pipeline
/// uses to pair inputs with their translated outputs:
///
/// ```swift
/// static func settingsView(
///     _ key: SettingsViewStringKey
/// ) -> TranslatedLabelStringCollection {
///     .init(key.rawValue)
/// }
/// ```
///
/// - SeeAlso: ``TranslatedLabelStrings``
extension TranslatedLabelStringCollection {
    /// A reference method that demonstrates the collection-key
    /// pattern. Replace with methods for each view in your app that
    /// requires translated labels.
    ///
    /// - Parameter key: The string key to resolve.
    ///
    /// - Returns: A ``TranslatedLabelStringCollection`` for the given
    ///   key.
    static func samplePageView(
        _ key: SamplePageViewStringKey
    ) -> TranslatedLabelStringCollection {
        .init(key.rawValue)
    }
}
