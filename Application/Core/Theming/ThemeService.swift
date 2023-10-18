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
import Redux

public enum ThemeService {
    // MARK: - Properties

    public private(set) static var currentTheme = AppTheme.default.theme {
        didSet {
            @Dependency(\.coreKit.ui) var coreUI: CoreKit.UI
            @Persistent(.currentThemeID) var currentThemeID: String?
            currentThemeID = currentTheme.hash
            Observables.themedViewAppearanceChanged.trigger()
            setStyle()
        }
    }

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
                pendingThemeID = theme.hash
            }

            return
        }

        pendingThemeID = nil
        currentTheme = theme
    }

    public static func setStyle() {
        @Dependency(\.coreKit.gcd) var coreGCD: CoreKit.GCD
        @Dependency(\.uiApplication) var uiApplication: UIApplication

        guard uiApplication.applicationState == .active else {
            coreGCD.after(.milliseconds(10)) { self.setStyle() }
            return
        }

        let currentThemeStyle = currentTheme.style
        guard uiApplication.interfaceStyle != currentThemeStyle else { return }
        uiApplication.overrideUserInterfaceStyle(currentThemeStyle)

        coreGCD.after(.milliseconds(10)) {
            guard uiApplication.interfaceStyle != currentThemeStyle else { return }
            self.setStyle()
        }
    }
}
