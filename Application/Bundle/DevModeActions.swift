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
        // MARK: - Properties

        public var appActions: [DevModeAction] = [
            clearCachesAction,
            resetUserDefaultsAction,
        ]

        // MARK: - Computed Properties

        private static var clearCachesAction: DevModeAction {
            func clearCaches() {
                @Dependency(\.coreKit) var core: CoreKit
                core.utils.clearCaches()
                core.hud.flash(image: .success)
            }

            return .init(title: "Clear Caches", perform: clearCaches)
        }

        private static var resetUserDefaultsAction: DevModeAction {
            func resetUserDefaults() {
                @Dependency(\.coreKit.hud) var coreHUD: CoreKit.HUD
                @Dependency(\.userDefaults) var defaults: UserDefaults

                defaults.reset(keeping: UserDefaultsKey.coreKeys)
                coreHUD.showSuccess(text: "Reset UserDefaults")
            }

            return .init(title: "Reset UserDefaults", perform: resetUserDefaults)
        }
    }
}
