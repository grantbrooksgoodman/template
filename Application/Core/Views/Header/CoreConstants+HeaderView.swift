//
//  CoreConstants+HeaderView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

// MARK: - CGFloat

public extension CoreConstants.CGFloats {
    enum HeaderView {
        public static let centerItemImageMaxHeight: CGFloat = 30
        public static let frameMinHeight: CGFloat = 54
        public static let horizontalPadding: CGFloat = 16
        public static let keyWindowSizeWidthDivisor: CGFloat = 3
        public static let separatorMaxHeight: CGFloat = 0.3
        public static let separatorTopPadding: CGFloat = -8
        public static let textAttributesDefaultSystemFontSize: CGFloat = 17
    }
}

// MARK: - Color

public extension CoreConstants.Colors {
    enum HeaderView {
        public static let separatorDarkForeground: Color = .init(uiColor: .init(hex: 0x48484A))
        public static let separatorLightForeground: Color = .init(uiColor: .init(hex: 0xA3A3A3))
    }
}
