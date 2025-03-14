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

/**
 Use this extension to add new actions to the Developer Mode menu.
 */
public extension DevModeAction {
    struct AppActions: AppSubsystem.Delegates.DevModeAppActionDelegate {
        public let appActions: [DevModeAction] = []
    }
}
