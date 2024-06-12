//
//  HeaderView+DataModels.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

public extension HeaderView {
    // MARK: - Attributes

    struct Attributes {
        /* MARK: Properties */

        public let appearance: Appearance
        public let showsDivider: Bool
        public let sizeClass: SizeClass

        /* MARK: Init */

        public init(
            appearance: Appearance = .custom(backgroundColor: .navigationBarBackground),
            showsDivider: Bool = true,
            sizeClass: SizeClass = .fullScreenCover
        ) {
            self.appearance = appearance
            self.showsDivider = showsDivider
            self.sizeClass = sizeClass
        }
    }

    // MARK: - Image Attributes

    struct ImageAttributes {
        /* MARK: Properties */

        public let foregroundColor: Color
        public let image: Image
        public let size: CGSize?
        public let weight: Font.Weight

        /* MARK: Init */

        public init(
            foregroundColor: Color = .accent,
            image: Image,
            size: CGSize? = nil,
            weight: Font.Weight = .regular
        ) {
            self.foregroundColor = foregroundColor
            self.image = image
            self.size = size
            self.weight = weight
        }
    }

    // MARK: - Image Button Attributes

    struct ImageButtonAttributes {
        /* MARK: Properties */

        public let action: () -> Void
        public let image: ImageAttributes

        /* MARK: Init */

        public init(
            image attributes: ImageAttributes,
            _ action: @escaping () -> Void
        ) {
            image = attributes
            self.action = action
        }
    }

    // MARK: - Text Attributes

    struct TextAttributes {
        /* MARK: Constants Accessors */

        public typealias Floats = CoreConstants.CGFloats.HeaderView

        /* MARK: Properties */

        public let font: Font
        public let foregroundColor: Color
        public let string: String

        /* MARK: Init */

        public init(
            _ string: String,
            font: Font = .system(size: Floats.textAttributesDefaultSystemFontSize, weight: .semibold),
            foregroundColor: Color = .titleText
        ) {
            self.string = string
            self.font = font
            self.foregroundColor = foregroundColor
        }
    }

    // MARK: - Text Button Attributes

    struct TextButtonAttributes {
        /* MARK: Properties */

        public let action: () -> Void
        public let text: TextAttributes

        /* MARK: Init */

        public init(
            text attributes: TextAttributes,
            _ action: @escaping () -> Void
        ) {
            text = attributes
            self.action = action
        }
    }
}
