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
    struct ImageAttributes {
        /* MARK: Properties */

        public let foregroundColor: Color
        public let image: Image
        public let size: CGSize?

        /* MARK: Init */

        public init(
            foregroundColor: Color = .accent,
            image: Image,
            size: CGSize? = nil
        ) {
            self.foregroundColor = foregroundColor
            self.image = image
            self.size = size
        }
    }

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

        /* MARK: Default Value */

        public static var empty: ImageButtonAttributes {
            .init(image: .init(image: .init(uiImage: .init()))) {}
        }
    }

    struct TextAttributes {
        /* MARK: Properties */

        public let font: Font
        public let foregroundColor: Color
        public let string: String

        /* MARK: Init */

        public init(
            _ string: String,
            font: Font = .system(size: 17, weight: .semibold),
            foregroundColor: Color = .titleText
        ) {
            self.string = string
            self.font = font
            self.foregroundColor = foregroundColor
        }

        /* MARK: Default Value */

        public static var empty: TextAttributes {
            .init(.init())
        }
    }

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

        /* MARK: Default Value */

        public static var empty: TextButtonAttributes {
            .init(text: .init(.init())) {}
        }
    }
}
