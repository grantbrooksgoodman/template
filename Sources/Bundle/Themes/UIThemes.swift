//
//  UIThemes.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// Use this extension to define the app's custom UI themes.
///
/// Create ``UITheme`` instances that map ``ColoredItemType`` slots to
/// concrete colors, then return them from ``List/uiThemes``:
///
/// ```swift
/// extension UITheme {
///     static let ocean: UITheme = .init(
///         name: "Ocean",
///         items: [
///             .init(.accent, set: .init(.systemTeal)),
///             .init(.background, set: .init(.white, variant: .init(hex: 0x0A1628))),
///         ]
///     )
/// }
/// ```
///
/// Custom themes are merged with the subsystem's built-in themes and
/// made available through ``UITheme/allCases``. Duplicate entries
/// are removed automatically.
///
/// - Note: Applying a theme whose interface style differs from the
///   current theme's is deferred until the next launch; the
///   subsystem presents an alert explaining that a restart is
///   required.
extension UITheme {
    /// The delegate that supplies the app's custom themes to the
    /// subsystem.
    ///
    /// - Important: The subsystem reads this delegate during
    ///   initialization. ``Application/initialize()`` registers it
    ///   before initializing the subsystem; preserve that order.
    struct List: AppSubsystem.Delegates.UIThemeListDelegate {
        /// The custom themes defined by this app.
        let uiThemes: [UITheme] = []
    }
}
