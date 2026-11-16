//
//  CustomColors.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

// swiftformat:disable emptyExtensions

/* Native */
import Foundation
import SwiftUI

/* Proprietary */
import AppSubsystem

/// Use this extension to define new ``ColoredItemType`` values for
/// specific UI elements.
///
/// Define a new ``ColoredItemType`` for each semantic color slot
/// your app introduces, then provide colors for it in your theme's
/// palette:
///
/// ```swift
/// extension ColoredItemType {
///     static let cardBackground: ColoredItemType = .init("cardBackground")
/// }
/// ```
///
/// - Warning: ``UITheme/color(for:)`` returns `UIColor.clear` if the
///   requested item type is not present in the theme's palette.
///   Ensure that every theme provides colors for all item types your
///   app uses.
extension ColoredItemType {}

/// Use this extension to create custom `UIColor` properties that
/// resolve against the current theme.
///
/// Add computed properties that call ``UITheme/color(for:)`` on the
/// active theme:
///
/// ```swift
/// @MainActor
/// extension UIColor {
///     static var cardBackground: UIColor {
///         ThemeService.currentTheme.color(for: .cardBackground)
///     }
/// }
/// ```
///
/// - Important: ``ThemeService/currentTheme`` and
///   ``UITheme/color(for:)`` are isolated to the main actor, so the
///   extension – or each property – must be marked `@MainActor`.
extension UIColor {}

/// Use this extension to create custom SwiftUI `Color` properties
/// that resolve against the current theme.
///
/// Wrap the corresponding `UIColor` property in a `Color`
/// initializer:
///
/// ```swift
/// @MainActor
/// extension Color {
///     static var cardBackground: Color { .init(uiColor: .cardBackground) }
/// }
/// ```
///
/// - Important: The themed `UIColor` properties are isolated to the
///   main actor, so the extension – or each property – must be
///   marked `@MainActor`.
extension Color {}

// swiftformat:enable emptyExtensions
