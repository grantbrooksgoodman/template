//
//  CustomColors.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* Proprietary */
import AppSubsystem

/// Use this extension to define new ``ColoredItemType`` values for
/// specific UI elements.
///
/// Define a new ``ColoredItemType`` for each semantic color slot your
/// app introduces, then provide colors for it in your theme's palette:
///
/// ```swift
/// extension ColoredItemType {
///     static let cardBackground: ColoredItemType = .init("cardBackground")
/// }
/// ```
extension ColoredItemType {}

/// Use this extension to create custom `UIColor` properties that
/// resolve against the current theme.
///
/// Add computed properties that call ``UITheme/color(for:)`` on the
/// active theme:
///
/// ```swift
/// extension UIColor {
///     static var cardBackground: UIColor {
///         ThemeService.currentTheme.color(for: .cardBackground)
///     }
/// }
/// ```
extension UIColor {}

/// Use this extension to create custom SwiftUI `Color` properties
/// that resolve against the current theme.
///
/// Wrap the corresponding `UIColor` property in a `Color` initializer:
///
/// ```swift
/// extension Color {
///     static var cardBackground: Color { .init(uiColor: .cardBackground) }
/// }
/// ```
extension Color {}
