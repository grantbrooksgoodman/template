//
//  LocalizedStringKeys.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// The app's localization key type.
///
/// Each case corresponds to a top-level key in the app's
/// localized strings property list. The ``referent`` property
/// converts the camel case name to snake case, so a case named
/// `helloWorld` maps to the property list key `hello_world`.
///
/// To add a new localized string, add a case to this enum and a
/// matching entry to the property list with translations for
/// each supported language. Access the resolved value using the
/// ``Localized`` property wrapper:
///
///     @Localized(.helloWorld) var greeting: String
///
/// - SeeAlso: ``Localized``, ``LocalizationSource``
enum LocalizedStringKey: String, LocalizedStringKeyRepresentable {
    // MARK: - Cases

    /// A sample key provided as a usage reference. Replace with
    /// keys for the strings your app localizes.
    case helloWorld

    // MARK: - Properties

    /// The snake case string used to look up the localized value
    /// in the property list.
    var referent: String { rawValue.snakeCased }
}

/// Use this extension to provide a default ``LocalizationSource``
/// for the app's localization keys.
///
/// This constrained initializer lets call sites omit the source
/// parameter. The default source is `.app()`, which reads from a
/// property list in the main bundle named `LocalizedStrings` by
/// default:
///
///     @Localized(.helloWorld) var greeting: String
///
/// To use a different property list name, pass it through
/// ``LocalizationSource/app(plistName:)``. Pass `.subsystem` to
/// resolve a key from AppSubsystem's built-in strings.
///
/// - SeeAlso: ``LocalizationSource``
extension Localized where T == LocalizedStringKey {
    /// Creates a localized string wrapper for the given key.
    ///
    /// - Parameters:
    ///   - key: The localization key to look up.
    ///   - languageCode: The language to resolve the string for.
    ///     Defaults to ``RuntimeStorage/languageCode``.
    ///   - source: The property list and bundle to read from.
    ///     Defaults to `.app()`.
    init(
        _ key: LocalizedStringKey,
        languageCode: String = RuntimeStorage.languageCode,
        source: LocalizationSource = .app()
    ) {
        self.init(
            key: key,
            languageCode: languageCode,
            source: source
        )
    }
}
