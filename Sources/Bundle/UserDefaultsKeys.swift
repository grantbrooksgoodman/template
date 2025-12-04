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

extension UserDefaultsKey {
    struct PermanentKeyDelegate: AppSubsystem.Delegates.PermanentUserDefaultsKeyDelegate {
        let permanentKeys: [UserDefaultsKey] = []
    }
}
