//
//  ThemeService.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit
import SwiftUI

/* 3rd-party */
import AlertKit
import Redux

public struct ThemeService {
    
    // MARK: - Properties
    
    private(set) static var currentTheme = AppTheme.default.theme {
        didSet {
            @Dependency(\.colorProvider) var colorProvider: ColorProvider
            @Dependency(\.userDefaults) var defaults: UserDefaults
            @Dependency(\.observableRegistry) var registry: ObservableRegistry
            defaults.set(currentTheme.name, forKey: .currentTheme)
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
            AKAlert(message: "The new appearance will take effect the next time you restart the app.",
                    cancelButtonTitle: "Dismiss").present { _ in
                defaults.set(theme.name, forKey: .pendingThemeName)
            }
            
            return
        }
        
        defaults.set(nil, forKey: .pendingThemeName)
        currentTheme = theme
    }
}
