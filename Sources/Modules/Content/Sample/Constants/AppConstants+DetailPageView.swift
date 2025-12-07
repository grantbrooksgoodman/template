//
//  AppConstants+DetailPageView.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* Proprietary */
import AppSubsystem

// MARK: - CGFloat

extension AppConstants.CGFloats {
    enum DetailPageView {
        static let modalFadeInDurationMilliseconds: CGFloat = 250
    }
}

// MARK: - Color

extension AppConstants.Colors {
    enum DetailPageView {
        static var doneButtonForeground: Color {
            UIApplication.isGlassTintingEnabled ? .white : .accent
        }
    }
}

// MARK: - String

extension AppConstants.Strings {
    enum DetailPageView {
        static let navigateBackButtonText = "Navigate Back"
        static let popToSplashButtonText = "Pop to Splash"
    }
}
