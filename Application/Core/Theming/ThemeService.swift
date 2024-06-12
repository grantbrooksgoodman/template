//
//  ThemeService.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import AlertKit
import CoreArchitecture

public enum ThemeService {
    // MARK: - Properties

    public private(set) static var currentTheme = AppTheme.default.theme {
        didSet {
            @Dependency(\.coreKit.gcd) var coreGCD: CoreKit.GCD
            @Persistent(.currentThemeID) var currentThemeID: String?
            currentThemeID = currentTheme.encodedHash
            Observables.themedViewAppearanceChanged.trigger()
            setStyle()
            coreGCD.after(.seconds(1)) { didReachSetStyleTimeoutThreshold = true }
        }
    }

    private static var didReachSetStyleTimeoutThreshold = false

    // MARK: - Setter

    public static func setTheme(_ theme: UITheme, checkStyle: Bool = true) {
        @Persistent(.pendingThemeID) var pendingThemeID: String?

        guard checkStyle else {
            currentTheme = theme
            return
        }

        guard currentTheme.style == theme.style else {
            AKAlert(
                message: "The new appearance will take effect the next time you restart the app.",
                cancelButtonTitle: "Dismiss"
            ).present { _ in
                pendingThemeID = theme.encodedHash
            }

            return
        }

        pendingThemeID = nil
        currentTheme = theme
    }

    private static func setStyle() {
        @Dependency(\.coreKit) var core: CoreKit
        @Dependency(\.uiApplication) var uiApplication: UIApplication

        guard !didReachSetStyleTimeoutThreshold else { return }
        guard uiApplication.applicationState == .active else {
            core.gcd.after(.milliseconds(10)) { self.setStyle() }
            return
        }

        let currentThemeStyle = currentTheme.style
        guard uiApplication.interfaceStyle != currentThemeStyle else { return }
        core.ui.overrideUserInterfaceStyle(currentThemeStyle)

        core.gcd.after(.milliseconds(10)) {
            guard uiApplication.interfaceStyle != currentThemeStyle else { return }
            self.setStyle()
        }
    }
}
