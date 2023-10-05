//
//  AppThemes.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/**
 Use this enum to build new `UIThemes`.
 */
public enum AppTheme: CaseIterable {
    // MARK: - Cases

    case `default`

    // MARK: - Properties

    public var theme: UITheme {
        switch self {
        case .default:
            return .init(name: "Default", items: defaultColoredItems)
        }
    }

    // MARK: - Colored Item Accessors

    private var defaultColoredItems: [ColoredItem] {
        let accent = ColoredItem(type: .accent, set: .init(primary: .systemBlue))
        let background = ColoredItem(type: .background, set: .init(primary: .white, variant: .black))

        let navigationBarBackground = ColoredItem(type: .navigationBarBackground, set: .init(primary: .init(hex: 0xF8F8F8), variant: .init(hex: 0x2A2A2C)))
        let navigationBarTitle = ColoredItem(type: .navigationBarTitle, set: .init(primary: .black, variant: .white))

        let titleText = ColoredItem(type: .titleText, set: .init(primary: .black, variant: .white))
        let subtitleText = ColoredItem(type: .subtitleText, set: .init(primary: .black, variant: .white))

        return [
            accent,
            background,
            navigationBarBackground,
            navigationBarTitle,
            titleText,
            subtitleText,
        ]
    }
}

/**
 Use this enum to define new color types for specific theme items.
 */
public enum ColoredItemType: String, Equatable {
    case accent
    case background

    case navigationBarBackground
    case navigationBarTitle

    case titleText
    case subtitleText
}
