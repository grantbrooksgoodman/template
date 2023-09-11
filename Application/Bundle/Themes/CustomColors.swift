//
//  CustomColors.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI
import UIKit

/* 3rd-party */
import Redux

/**
 Use this extension to create custom `UIColors` based on the current theme.
 */
public extension UIColor {
    // MARK: - View Backgrounds
    static var background: UIColor { ThemeService.currentTheme.color(for: .background) }
    
    // MARK: - Navigation Bar
    static var navigationBarBackground: UIColor { ThemeService.currentTheme.color(for: .navigationBarBackground) }
    static var navigationBarTitle: UIColor { ThemeService.currentTheme.color(for: .navigationBarTitle) }
    
    // MARK: - Label Text
    static var subtitleText: UIColor { ThemeService.currentTheme.color(for: .subtitleText) }
    static var titleText: UIColor { ThemeService.currentTheme.color(for: .titleText) }
}

/**
 Provided to create convenience initializers for custom `Colors`.
 */
public extension Color {
    // MARK: - View Backgrounds
    static var background: Color { colorProvider.backgroundColor }
    
    // MARK: - Navigation Bar
    static var navigationBarTitle: Color { colorProvider.navigationBarTitleColor }
    static var navigationBarBackground: Color { colorProvider.navigationBarBackgroundColor }
    
    // MARK: - Label Text
    static var subtitleText: Color { colorProvider.subtitleTextColor }
    static var titleText: Color { colorProvider.titleTextColor }
    
    // MARK: - Color Provider
    private static var colorProvider: ColorProvider { @Dependency(\.colorProvider) var colorProvider; return colorProvider }
}

/**
 This class can be used to access your custom `UIColors` in SwiftUI and keep them in sync.
 */
public class ColorProvider: ObservableObject {
    
    // MARK: - Dependencies
    
    @Dependency(\.uiApplication) private var uiApplication: UIApplication
    
    // MARK: - Properties
    
    // Theme Information
    @Published public var currentThemeName = ThemeService.currentTheme.name
    @Published public var interfaceStyle = UITraitCollection.current.userInterfaceStyle
    
    // View Backgrounds
    @Published public var backgroundColor = binding(with: .background)
    
    // Navigation Bar
    @Published public var navigationBarBackgroundColor = binding(with: .navigationBarBackground)
    @Published public var navigationBarTitleColor = binding(with: .navigationBarTitle)
    
    // Label Text
    @Published public var subtitleTextColor = binding(with: .subtitleText)
    @Published public var titleTextColor = binding(with: .titleText)
    
    // MARK: - Synchronization
    
    public func updateColorState() {
        backgroundColor = ColorProvider.binding(with: .background)
        
        navigationBarBackgroundColor = ColorProvider.binding(with: .navigationBarBackground)
        navigationBarTitleColor = ColorProvider.binding(with: .navigationBarTitle)
        
        subtitleTextColor = ColorProvider.binding(with: .subtitleText)
        titleTextColor = ColorProvider.binding(with: .titleText)
        
        uiApplication.overrideUserInterfaceStyle(ThemeService.currentTheme.style)
    }
    
    // MARK: - Binding Constructor
    
    private static func binding(with color: UIColor) -> Color {
        return Binding(get: { Color(uiColor: color) }, set: { let _ = $0 }).wrappedValue
    }
}
