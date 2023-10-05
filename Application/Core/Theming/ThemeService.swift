//
//  ThemeService.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import AlertKit
import Redux

public enum ThemeService {
    // MARK: - Properties

    public private(set) static var currentTheme = AppTheme.default.theme {
        didSet {
            @Persistent(.core(.currentThemeID)) var currentThemeID: String?
            currentThemeID = currentTheme.hash
            Observables.themedViewAppearanceChanged.trigger()
        }
    }

    // MARK: - Setter

    public static func setTheme(_ theme: UITheme, checkStyle: Bool = true) {
        @Persistent(.core(.pendingThemeID)) var pendingThemeID: String?

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
}
