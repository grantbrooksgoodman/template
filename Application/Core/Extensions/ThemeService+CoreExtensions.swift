//
//  ThemeService+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import Redux

public extension ThemeService {
    static var isDarkModeActive: Bool {
        @Dependency(\.uiApplication.interfaceStyle) var interfaceStyle: UIUserInterfaceStyle?
        let appliedInterfaceStyle = (interfaceStyle ?? currentTheme.style)
        return (appliedInterfaceStyle == .unspecified ? UITraitCollection.current.userInterfaceStyle : appliedInterfaceStyle) == .dark
    }

    static var isDefaultThemeApplied: Bool { currentTheme == AppTheme.default.theme }
}
