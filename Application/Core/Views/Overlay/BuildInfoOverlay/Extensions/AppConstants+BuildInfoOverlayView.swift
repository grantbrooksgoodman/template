//
//  AppConstants+BuildInfoOverlayView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

// MARK: - CGFloat

public extension AppConstants.CGFloats {
    struct BuildInfoOverlayView {
        public static let buildInfoButtonFrameHeight: CGFloat = 15
        public static let buildInfoButtonPadding: CGFloat = 1
        public static let buildInfoButtonXOffset: CGFloat = -10
        
        public static let buildInfoButtonLabelFontSize: CGFloat = 13
        public static let developerModeIndicatorFrameHeight: CGFloat = 8
        public static let developerModeIndicatorFrameWidth: CGFloat = 8
        public static let developerModeIndicatorTrailingPadding: CGFloat = -6
        
        public static let sendFeedbackButtonFrameHeight: CGFloat = 20
        public static let sendFeedbackButtonHorizontalPadding: CGFloat = 1
        public static let sendFeedbackButtonLabelFontSize: CGFloat = 12
        
        public static let sendFeedbackButtonXOffset: CGFloat = -10
        public static let sendFeedbackButtonYOffset: CGFloat = 8
        
        public static let xOffset: CGFloat = -10
    }
}

// MARK: - Color

public extension AppConstants.Colors {
    struct BuildInfoOverlayView {
        public static let buildInfoButtonBackground: Color = .black
        public static let buildInfoButtonLabelForeground: Color = .white
        
        public static let sendFeedbackButtonBackground: Color = .black
        public static let sendFeedbackButtonLabelForeground: Color = .white
    }
}

// MARK: - String

public extension AppConstants.Strings {
    struct BuildInfoOverlayView {
        public static let buildInfoButtonLabelFontName = "SFUIText-Bold"
        public static let sendFeedbackButtonLabelFontName = "Arial"
    }
}
