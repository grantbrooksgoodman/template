//
//  UIThemes.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* Proprietary */
import AppSubsystem

/**
 Use this extension to build new UI themes.
 */
public extension UITheme {
    struct List: AppSubsystem.Delegates.UIThemeListDelegate {
        public let uiThemes: [UITheme] = []
    }
}
