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
/// Mode action sheet:
///
/// ```swift
/// let appActions: [DevModeAction] = [
///     .init(title: "Reset Onboarding") {
///         UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
///     },
/// ]
/// ```
///
/// - Note: Developer Mode actions are available only in pre-release builds. The subsystem
/// hides them entirely in general-release builds.
extension DevModeAction {
    /// The delegate that supplies app-specific actions to the
    /// Developer Mode menu.
    struct AppActions: AppSubsystem.Delegates.DevModeAppActionDelegate {
        /// The actions to display in the Developer Mode action sheet.
        let appActions: [DevModeAction] = []
    }
}
