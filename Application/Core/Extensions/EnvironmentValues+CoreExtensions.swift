//
//  EnvironmentValues+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

public extension EnvironmentValues {
    // MARK: - Types

    private struct KeyWindowSizeKey: EnvironmentKey {
        public static let defaultValue: CGSize = .zero
    }

    // MARK: - Properties

    var keyWindowSize: CGSize {
        get { self[KeyWindowSizeKey.self] }
        set { self[KeyWindowSizeKey.self] = newValue }
    }
}
