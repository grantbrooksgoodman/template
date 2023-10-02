//
//  AppConstants+FailureView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

// MARK: - CGFloat

public extension AppConstants.CGFloats {
    enum FailureView {
        public static let buttonLabelFontSize: CGFloat = 14

        public static let exceptionLabelFontSize: CGFloat = 17
        public static let exceptionLabelHorizontalPadding: CGFloat = 2
        public static let exceptionLabelVerticalPadding: CGFloat = 5

        public static let imageBottomPadding: CGFloat = 5
        public static let imageSystemSize: CGFloat = 60

        public static let reportBugButtonTopPadding: CGFloat = 5
    }
}

// MARK: - Color

public extension AppConstants.Colors {
    enum FailureView {
        public static let imageForegroundColor: Color = .red
        public static let reportBugButtonDisabledColor: Color = .init(uiColor: .systemGray)
    }
}

// MARK: - String

public extension AppConstants.Strings {
    enum FailureView {
        public static let exceptionLabelFontName = "SFUIText-Semibold"
        public static let imageSystemName = "exclamationmark.octagon.fill"
    }
}
