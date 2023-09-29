//
//  ThemeService.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI
import UIKit

/* 3rd-party */
import AlertKit
import Redux

public enum ThemeService {
    // MARK: - Properties

    public private(set) static var currentTheme = AppTheme.default.theme {
        didSet {
            @Dependency(\.colorProvider) var colorProvider: ColorProvider
            @Dependency(\.userDefaults) var defaults: UserDefaults
            @Dependency(\.observableRegistry) var registry: ObservableRegistry
            defaults.set(currentTheme.name, forKey: .core(.currentTheme))
            colorProvider.updateColorState()
            registry.themedViewAppearanceChanged.trigger()
        }
    }

    // MARK: - Setter

    public static func setTheme(_ theme: UITheme, checkStyle: Bool = true) {
        @Dependency(\.userDefaults) var defaults: UserDefaults

        guard checkStyle else {
            currentTheme = theme
            return
        }

        guard currentTheme.style == theme.style else {
            AKAlert(
                message: "The new appearance will take effect the next time you restart the app.",
                cancelButtonTitle: "Dismiss"
            ).present { _ in
                defaults.set(theme.name, forKey: .core(.pendingThemeName))
            }

            return
        }

        defaults.set(nil, forKey: .core(.pendingThemeName))
        currentTheme = theme
    }
}
