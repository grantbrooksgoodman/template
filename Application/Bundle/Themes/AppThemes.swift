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
 Use this enum to build new `UITheme`s.
 */
public enum AppTheme: CaseIterable {
    // MARK: - Type Aliases

    private typealias Item = UITheme.ColoredItem

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

    private var defaultColoredItems: [Item] {
        let accent = Item(type: .accent, set: .init(primary: .systemBlue))
        let background = Item(type: .background, set: .init(primary: .white, variant: .black))

        let navigationBarBackground = Item(type: .navigationBarBackground, set: .init(primary: .init(hex: 0xF8F8F8), variant: .init(hex: 0x2A2A2C)))
        let navigationBarTitle = Item(type: .navigationBarTitle, set: .init(primary: .black, variant: .white))

        let titleText = Item(type: .titleText, set: .init(primary: .black, variant: .white))
        let subtitleText = Item(type: .subtitleText, set: .init(primary: .black, variant: .white))

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
