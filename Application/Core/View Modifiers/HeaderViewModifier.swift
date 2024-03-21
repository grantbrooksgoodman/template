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

    // Bool
    private let isThemed: Bool
    private let showsDivider: Bool

    // CenterItemType
    private let centerItem: HeaderView.CenterItemType?

    // PeripheralButtonType
    private let leftItem: HeaderView.PeripheralButtonType?
    private let rightItem: HeaderView.PeripheralButtonType?

    // MARK: - Init

    public init(
        leftItem: HeaderView.PeripheralButtonType?,
        centerItem: HeaderView.CenterItemType?,
        rightItem: HeaderView.PeripheralButtonType?,
        showsDivider: Bool,
        isThemed: Bool
    ) {
        self.leftItem = leftItem
        self.centerItem = centerItem
        self.rightItem = rightItem
        self.showsDivider = showsDivider
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
                        showsDivider: showsDivider,
                        isThemed: true
                    )
                    .background(Color.navigationBarBackground)
                }

                Spacer(minLength: 0)
                content
                Spacer(minLength: 0)
            }
        } else {
            VStack {
                HeaderView(
                    leftItem: leftItem,
                    centerItem: centerItem,
                    rightItem: rightItem,
                    showsDivider: showsDivider
                )

                Spacer(minLength: 0)
                content
                Spacer(minLength: 0)
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
        showsDivider: Bool = true,
        isThemed: Bool = false
    ) -> some View {
        modifier(
            HeaderViewModifier(
                leftItem: leftItem,
                centerItem: centerItem,
                rightItem: rightItem,
                showsDivider: showsDivider,
                isThemed: isThemed
            )
        )
    }
}
