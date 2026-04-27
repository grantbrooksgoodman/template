//
//  UserDefaultsKeys.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// Use this extension to declare which `UserDefaults` keys should
/// survive a reset.
///
/// Register keys as permanent when they store critical app state –
/// such as authentication tokens or installation identifiers – that
/// must be preserved when the user or the subsystem resets
/// `UserDefaults`.
extension UserDefaultsKey {
    /// The delegate that declares which `UserDefaults` keys are
    /// preserved during a reset.
    struct PermanentKeyDelegate: AppSubsystem.Delegates.PermanentUserDefaultsKeyDelegate {
        /// The keys that should survive a `UserDefaults` reset.
        let permanentKeys: [UserDefaultsKey] = []
    }
}
