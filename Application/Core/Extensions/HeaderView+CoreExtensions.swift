//
//  HeaderView+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

public extension HeaderView.PeripheralButtonType {
    static func backButton(
        foregroundColor: Color = .accent,
        _ action: @escaping () -> Void
    ) -> HeaderView.PeripheralButtonType {
        .image(
            .init(image: .init(
                foregroundColor: foregroundColor,
                image: .init(systemName: CoreConstants.Strings.HeaderView.backButtonImageSystemName),
                size: .init(
                    width: CoreConstants.CGFloats.HeaderView.backButtonImageSizeWidth,
                    height: CoreConstants.CGFloats.HeaderView.backButtonImageSizeHeight
                ),
                weight: .medium
            )) { action() }
        )
    }

    static func cancelButton(
        font: Font = .system(
            size: CoreConstants.CGFloats.HeaderView.textAttributesDefaultSystemFontSize
        ),
        foregroundColor: Color = .accent,
        _ action: @escaping () -> Void
    ) -> HeaderView.PeripheralButtonType {
        .text(
            .init(text: .init(
                Localized(.cancel).wrappedValue,
                font: font,
                foregroundColor: foregroundColor
            )) { action() }
        )
    }

    static func doneButton(
        font: Font = .system(
            size: CoreConstants.CGFloats.HeaderView.textAttributesDefaultSystemFontSize,
            weight: .semibold
        ),
        foregroundColor: Color = .accent,
        _ action: @escaping () -> Void
    ) -> HeaderView.PeripheralButtonType {
        .text(
            .init(text: .init(
                Localized(.done).wrappedValue,
                font: font,
                foregroundColor: foregroundColor
            )) { action() }
        )
    }
}
