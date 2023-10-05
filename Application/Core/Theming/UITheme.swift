//
//  UITheme.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import Redux

public struct UITheme: Equatable, CompressedHashable {
    // MARK: - Properties

    public let name: String
    public let items: [ColoredItem]
    public let style: UIUserInterfaceStyle

    // MARK: - CompressedHashable Conformance

    public var hashFactors: [String] {
        var factors = [String]()
        factors.append(name)
        factors.append(contentsOf: items.map { ($0.set.variant ?? $0.set.primary).accessibilityName })
        factors.append(contentsOf: items.map(\.type.rawValue))
        factors.append(.init(style.rawValue))
        return factors
    }

    // MARK: - Init

    public init(
        name: String,
        items: [ColoredItem],
        style: UIUserInterfaceStyle = .unspecified
    ) {
        self.name = name
        self.items = items
        self.style = style
        guard !containsDuplicates(items: self.items) else { fatalError("Cannot instantiate UITheme with duplicate ColoredItems") }
    }

    // MARK: - Color for Item

    /// - Warning: Returns `UIColor.clear` if item is not themed.
    public func color(for itemType: ColoredItemType) -> UIColor {
        guard let item = items.first(where: { $0.type == itemType }) else { return .clear }
        return UITraitCollection.current.userInterfaceStyle == .dark ? (item.set.variant ?? item.set.primary) : item.set.primary
    }

    // MARK: - Auxiliary

    private func containsDuplicates(items: [ColoredItem]) -> Bool {
        let types = items.map(\.type)
        return types.unique.count != types.count
    }
}
