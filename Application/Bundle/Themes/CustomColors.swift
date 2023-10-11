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
 Use this enum to define new color types for specific theme items.
 */
public enum ColoredItemType: String, Equatable {
    case accent
    case background
    
    case navigationBarBackground
    case navigationBarTitle
    
    case subtitleText
    case titleText
}

/**
 Use this extension to create custom `UIColors` based on the current theme.
 */
public extension UIColor {
    static var accent: UIColor { theme.color(for: .accent) }
    static var background: UIColor { theme.color(for: .background) }
    
    static var navigationBarBackground: UIColor { theme.color(for: .navigationBarBackground) }
    static var navigationBarTitle: UIColor { theme.color(for: .navigationBarTitle) }
    
    static var subtitleText: UIColor { theme.color(for: .subtitleText) }
    static var titleText: UIColor { theme.color(for: .titleText) }
    
    private static var theme: UITheme { ThemeService.currentTheme }
}

/**
 Provided to create convenience initializers for custom `Colors`.
 */
public extension Color {
    static var accent: Color { .init(uiColor: .accent) }
    static var background: Color { .init(uiColor: .background) }
    
    static var navigationBarTitle: Color { .init(uiColor: .navigationBarTitle) }
    static var navigationBarBackground: Color { .init(uiColor: .navigationBarBackground) }
    
    static var subtitleText: Color { .init(uiColor: .subtitleText) }
    static var titleText: Color { .init(uiColor: .titleText) }
}
