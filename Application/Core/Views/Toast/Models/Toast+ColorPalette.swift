//
//  Toast+ColorPalette.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

public extension Toast {
    struct ColorPalette: Equatable {
        // MARK: - Properties

        public let accent: Color?
        public let background: Color?
        public let dismissButton: Color?
        public let text: Color?

        // MARK: - Init

        public init(
            accent: Color? = nil,
            background: Color? = nil,
            dismissButton: Color? = nil,
            text: Color? = nil
        ) {
            self.accent = accent
            self.background = background
            self.dismissButton = dismissButton
            self.text = text
        }
    }
}
