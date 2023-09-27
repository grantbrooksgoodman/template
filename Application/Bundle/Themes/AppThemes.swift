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
        let background = ColoredItem(type: .background, set: ColorSet(primary: .white, variant: .black))

        let navigationBarBackground = ColoredItem(
            type: .navigationBarBackground,
            set: ColorSet(
                primary: UIColor(hex: 0xF8F8F8),
                variant: UIColor(hex: 0x2A2A2C)
            )
        )
        let navigationBarTitle = ColoredItem(type: .navigationBarTitle, set: ColorSet(primary: .black, variant: .white))

        let titleText = ColoredItem(type: .titleText, set: ColorSet(primary: .black, variant: .white))
        let subtitleText = ColoredItem(type: .subtitleText, set: ColorSet(primary: .black, variant: .white))

        return [
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
public enum ColoredItemType: Equatable {
    case background

    case navigationBarBackground
    case navigationBarTitle

    case titleText
    case subtitleText
}
