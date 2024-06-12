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
        public static let backButtonImageSizeHeight: CGFloat = 20
        public static let backButtonImageSizeWidth: CGFloat = 20

        public static let centerItemImageMaxHeight: CGFloat = 30
        public static let horizontalPadding: CGFloat = 16
        public static let keyWindowSizeWidthDivisor: CGFloat = 3

        public static let dragGestureMinimumDistance: CGFloat = 20
        public static let dragGestureValueLeftEdgeThreshold: CGFloat = 20
        public static let dragGestureValueRightSwipeThreshold: CGFloat = 60

        public static let fullScreenCoverSizeClassFrameMinHeight: CGFloat = 44
        public static let sheetSizeClassFrameMinHeight: CGFloat = 54

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

// MARK: - String

public extension CoreConstants.Strings {
    enum HeaderView {
        public static let backButtonImageSystemName = "chevron.backward"
    }
}
