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
    static var accent: UIColor { ThemeService.currentTheme.color(for: .accent) }
    static var background: UIColor { ThemeService.currentTheme.color(for: .background) }

    static var navigationBarBackground: UIColor { ThemeService.currentTheme.color(for: .navigationBarBackground) }
    static var navigationBarTitle: UIColor { ThemeService.currentTheme.color(for: .navigationBarTitle) }

    static var subtitleText: UIColor { ThemeService.currentTheme.color(for: .subtitleText) }
    static var titleText: UIColor { ThemeService.currentTheme.color(for: .titleText) }
}

/**
 Provided to create convenience initializers for custom `Colors`.
 */
public extension Color {
    static var accent: Color { colorProvider.accentColor }
    static var background: Color { colorProvider.backgroundColor }

    static var navigationBarTitle: Color { colorProvider.navigationBarTitleColor }
    static var navigationBarBackground: Color { colorProvider.navigationBarBackgroundColor }

    static var subtitleText: Color { colorProvider.subtitleTextColor }
    static var titleText: Color { colorProvider.titleTextColor }

    private static var colorProvider: ColorProvider { @Dependency(\.colorProvider) var colorProvider; return colorProvider }
}

/**
 This class can be used to access your custom `UIColors` in SwiftUI and keep them in sync.
 */
public final class ColorProvider: ObservableObject {
    // MARK: - Properties

    @Published public var accentColor = binding(with: .accent)
    @Published public var backgroundColor = binding(with: .background)

    @Published public var navigationBarBackgroundColor = binding(with: .navigationBarBackground)
    @Published public var navigationBarTitleColor = binding(with: .navigationBarTitle)

    @Published public var subtitleTextColor = binding(with: .subtitleText)
    @Published public var titleTextColor = binding(with: .titleText)

    // MARK: - Init

    public init() {
        setStyle()
    }

    // MARK: - Synchronization

    public func updateColorState() {
        accentColor = ColorProvider.binding(with: .accent)
        backgroundColor = ColorProvider.binding(with: .background)

        navigationBarBackgroundColor = ColorProvider.binding(with: .navigationBarBackground)
        navigationBarTitleColor = ColorProvider.binding(with: .navigationBarTitle)

        subtitleTextColor = ColorProvider.binding(with: .subtitleText)
        titleTextColor = ColorProvider.binding(with: .titleText)

        setStyle()
    }

    private func setStyle() {
        @Dependency(\.coreKit.gcd) var coreGCD: CoreKit.GCD
        @Dependency(\.uiApplication) var uiApplication: UIApplication

        guard uiApplication.applicationState == .active else {
            coreGCD.after(.milliseconds(10)) { self.setStyle() }
            return
        }

        let currentThemeStyle = ThemeService.currentTheme.style
        guard uiApplication.interfaceStyle != currentThemeStyle else { return }
        uiApplication.overrideUserInterfaceStyle(currentThemeStyle)

        coreGCD.after(.milliseconds(10)) {
            guard uiApplication.interfaceStyle != currentThemeStyle else { return }
            self.setStyle()
        }
    }

    // MARK: - Binding Constructor

    private static func binding(with color: UIColor) -> Color {
        return Binding(get: { Color(uiColor: color) }, set: { _ = $0 }).wrappedValue
    }
}
