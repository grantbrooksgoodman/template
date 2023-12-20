//
//  HeaderViewModifier.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

private struct HeaderViewModifier: ViewModifier {
    // MARK: - Properties

    // PeripheralButtonType
    private let leftItem: HeaderView.PeripheralButtonType?
    private let rightItem: HeaderView.PeripheralButtonType?

    // Other
    private let centerItem: HeaderView.CenterItemType?
    private let isThemed: Bool

    // MARK: - Init

    public init(
        leftItem: HeaderView.PeripheralButtonType?,
        centerItem: HeaderView.CenterItemType?,
        rightItem: HeaderView.PeripheralButtonType?,
        isThemed: Bool
    ) {
        self.leftItem = leftItem
        self.centerItem = centerItem
        self.rightItem = rightItem
        self.isThemed = isThemed
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        if isThemed {
            VStack {
                ThemedView {
                    HeaderView(
                        leftItem: leftItem,
                        centerItem: centerItem,
                        rightItem: rightItem,
                        isThemed: true
                    )
                    .background(Color.navigationBarBackground)
                }

                Spacer()
                content
                Spacer()
            }
        } else {
            VStack {
                HeaderView(
                    leftItem: leftItem,
                    centerItem: centerItem,
                    rightItem: rightItem
                )

                Spacer()
                content
                Spacer()
            }
        }
    }
}

public extension View {
    /// - Parameter isThemed: Pass `true` to override all color values to those of the system theme.
    func header(
        leftItem: HeaderView.PeripheralButtonType? = nil,
        _ centerItem: HeaderView.CenterItemType? = nil,
        rightItem: HeaderView.PeripheralButtonType? = nil,
        isThemed: Bool = false
    ) -> some View {
        modifier(
            HeaderViewModifier(
                leftItem: leftItem,
                centerItem: centerItem,
                rightItem: rightItem,
                isThemed: isThemed
            )
        )
    }
}
