//
//  DevModeActions.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// Use this extension to add new actions to the Developer Mode menu.
///
/// Define ``DevModeAction`` instances and include them in
/// ``AppActions/appActions`` to make them available in the Developer
/// Mode menu:
///
/// ```swift
/// let appActions: [DevModeAction] = [
///     .init(
///         title: "Reset Onboarding",
///         iconConfiguration: .init(
///             backgroundColor: .orange,
///             overlay: .symbol(name: "arrow.counterclockwise")
///         )
///     ) {
///         @Persistent(.hasSeenOnboarding) var hasSeenOnboarding: Bool?
///         hasSeenOnboarding = nil
///     },
/// ]
/// ```
///
/// Group related actions under their own page with a destination
/// action, and present a toggleable setting as a switch by passing
/// `interaction: .switch(isOn:)` with the setting's current state.
/// The subsystem reads ``AppActions/appActions`` each time the menu
/// is presented or refreshed, so a computed list can reflect the
/// app's current state.
///
/// - Note: Developer Mode is not available on general-release
///   builds.
extension DevModeAction {
    /// The delegate that supplies app-specific actions to the
    /// Developer Mode menu.
    struct AppActions: AppSubsystem.Delegates.DevModeAppActionDelegate {
        /// The actions to display in the Developer Mode menu.
        let appActions: [DevModeAction] = []
    }
}
