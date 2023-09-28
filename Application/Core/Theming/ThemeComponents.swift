//
//  ThemeComponents.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

public struct ColoredItem: Equatable {
    // MARK: - Properties

    public let type: ColoredItemType
    public let set: ColorSet

    // MARK: - Init

    public init(type: ColoredItemType, set: ColorSet) {
        self.type = type
        self.set = set
    }
}

public struct ColorSet: Equatable {
    // MARK: - Properties

    public private(set) var primary: UIColor!
    public private(set) var variant: UIColor?

    // MARK: - Init

    public init(
        primary: UIColor,
        variant: UIColor? = nil
    ) {
        self.primary = primary
        self.variant = variant
    }
}
