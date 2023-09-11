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

public struct UITheme: Equatable {
    
    // MARK: - Properties
    
    private(set) var name: String
    private(set) var items: [ColoredItem]
    private(set) var style: UIUserInterfaceStyle
    
    // MARK: - Init
    
    public init(name: String,
                items: [ColoredItem],
                style: UIUserInterfaceStyle = .unspecified) {
        self.name = name
        self.items = items
        self.style = style
        guard !containsDuplicates(items: self.items) else { fatalError("Cannot instantiate UITheme with duplicate ColoredItems") }
    }
    
    // MARK: - Color for Item
    
    /// - Warning: Returns `UIColor.clear` if item is not themed.
    public func color(for itemType: ColoredItemType) -> UIColor {
        @Dependency(\.uiTraitCollection) var traitCollection: UITraitCollection
        
        guard let item = items.first(where: { $0.type == itemType }) else { return .clear }
        return traitCollection.userInterfaceStyle == .dark ? (item.set.variant ?? item.set.primary) : item.set.primary
    }
    
    // MARK: - Auxiliary
    
    private func containsDuplicates(items: [ColoredItem]) -> Bool {
        var seen = [ColoredItemType]()
        for item in items {
            guard !seen.contains(item.type) else { return true }
            seen.append(item.type)
        }
        
        return false
    }
}
