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
import Networking

public extension UserDefaultsKey {
    struct PermanentKeyDelegate: AppSubsystem.Delegates.PermanentUserDefaultsKeyDelegate {
        public let permanentKeys: [UserDefaultsKey] = [
            .networking(.isNetworkActivityIndicatorEnabled),
            .networking(.networkEnvironment),
        ]
    }
}
