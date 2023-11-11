//
//  CoreConstants+ToastView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

// MARK: - CGFloat

public extension CoreConstants.CGFloats {
    enum ToastView {
        public static let bannerCornerRadius: CGFloat = 8 // swiftlint:disable:next identifier_name
        public static let bannerDismissButtonForegroundColorOpacity: CGFloat = 0.7
        public static let bannerHorizontalPadding: CGFloat = 16

        public static let bannerMessageLabelForegroundColorOpacity: CGFloat = 0.6
        public static let bannerMessageLabelFontSize: CGFloat = 12

        public static let bannerOverlayFrameWidth: CGFloat = 6

        public static let bannerShadowColorOpacity: CGFloat = 0.25
        public static let bannerShadowRadius: CGFloat = 4
        public static let bannerShadowX: CGFloat = 0
        public static let bannerShadowY: CGFloat = 1

        public static let bannerSpacerMinLength: CGFloat = 10

        public static let bannerTitleLabelFontSize: CGFloat = 14
        public static let bannerTitleLabelForegroundColorOpacity: CGFloat = 0.6

        public static let bottomAppearanceEdgeYOffset: CGFloat = -20
        public static let topAppearanceEdgeYOffset: CGFloat = 20

        public static let capsuleImageFrameMaxHeight: CGFloat = 20
        public static let capsuleImageFrameMaxWidth: CGFloat = 20

        public static let capsuleMessageLabelFontSize: CGFloat = 12
        public static let capsuleTitleLabelFontSize: CGFloat = 14

        public static let capsuleMessageLabelHorizontalPadding: CGFloat = 5
        public static let capsuleMessageLabelVerticalPadding: CGFloat = 5

        public static let capsuleOverlayStrokeColorOpacity: CGFloat = 0.2
        public static let capsuleOverlayStrokeLineWidth: CGFloat = 1

        public static let capsulePrimaryHorizontalPadding: CGFloat = 20
        public static let capsuleSecondaryHorizontalPadding: CGFloat = 16
        public static let capsuleVerticalPadding: CGFloat = 10

        public static let capsuleShadowColorOpacity: CGFloat = 0.1
        public static let capsuleShadowRadius: CGFloat = 5
        public static let capsuleShadowX: CGFloat = 0
        public static let capsuleShadowY: CGFloat = 6
    }
}

// MARK: - Color

public extension CoreConstants.Colors {
    enum ToastView {
        public static let bannerShadowColor: Color = .black
        public static let capsuleShadowColor: Color = .black

        public static let capsuleMessageLabelForeground: Color = .gray
        public static let capsuleOverlayStroke: Color = .gray

        public static let defaultErrorColor: Color = .red
        public static let defaultInfoColor: Color = .init(uiColor: .systemBlue)
        public static let defaultSuccessColor: Color = .green
        public static let defaultWarningColor: Color = .orange
    }
}

// MARK: - String

public extension CoreConstants.Strings {
    enum ToastView {
        public static let bannerDismissButtonImageSystemName = "xmark"

        public static let bannerErrorIconImageSystemName = "xmark.circle.fill"
        public static let bannerInfoIconImageSystemName = "info.circle.fill"
        public static let bannerSuccessIconImageSystemName = "checkmark.circle.fill"
        public static let bannerWarningIconImageSystemName = "exclamationmark.triangle.fill"

        public static let capsuleErrorIconImageSystemName = "xmark"
        public static let capsuleInfoIconImageSystemName = "info"
        public static let capsuleSuccessIconImageSystemName = "checkmark"
        public static let capsuleWarningIconImageSystemName = "exclamationmark.triangle.fill"
    }
}
