//
//  ComponentKit+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import ComponentKit
import CoreArchitecture

public extension ComponentKit {
    func button(
        _ text: String,
        font: ComponentKit.Font = .system,
        action: @escaping () -> Void
    ) -> some View {
        Components.button(
            text,
            font: font,
            foregroundColor: .accent,
            action: action
        )
    }

    func symbol(_ systemName: String, usesIntrinsicSize: Bool = true) -> some View {
        Components.symbol(
            systemName,
            foregroundColor: .accent,
            usesIntrinsicSize: usesIntrinsicSize
        )
    }

    func text(_ text: String, font: ComponentKit.Font = .system) -> some View {
        Components.text(
            text,
            font: font,
            foregroundColor: .titleText
        )
    }
}
