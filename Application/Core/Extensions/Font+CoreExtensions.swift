//
//  Font+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

public extension Font {
    // MARK: - Types

    enum SFUITextStyle: String {
        /* MARK: Cases */

        case bold
        case boldItalic

        case heavy
        case heavyItalic

        case light
        case lightItalic

        case medium
        case mediumItalic

        case regular

        case semibold
        case semiboldItalic

        /* MARK: Properties */

        public var fontNameValue: String { rawValue.firstUppercase }
    }

    // MARK: - Functions

    static func sanFrancisco(_ style: SFUITextStyle = .regular, size: CGFloat) -> Font {
        .custom("SFUIText-\(style.fontNameValue)", size: size)
    }
}
