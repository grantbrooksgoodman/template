//
//  PersistentStorageKeys.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// Use this extension to declare which persistent storage keys
/// should survive a reset.
///
/// Register keys as permanent when they store critical app state –
/// such as authentication tokens or installation identifiers – that
/// must survive a persistent storage reset. The subsystem preserves
/// these keys, along with its own, when
/// `UserDefaults.reset(preserving:)` is called with its default
/// strategy – for example, from the Developer Mode menu.
extension PersistentStorageKey {
    /// The delegate that declares which persistent storage keys are
    /// preserved during a reset.
    struct PermanentKeyDelegate: AppSubsystem.Delegates.PermanentPersistentStorageKeyDelegate {
        /// The keys that should be preserved during a persistent
        /// storage reset.
        let permanentKeys: [PersistentStorageKey] = []
    }
}
