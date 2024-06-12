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
    // MARK: - Constants Accessors

    private typealias Floats = CoreConstants.CGFloats.HeaderView

    // MARK: - Properties

    // PeripheralButtonType
    private let leftItem: HeaderView.PeripheralButtonType?
    private let rightItem: HeaderView.PeripheralButtonType?

    // Other
    private let attributes: HeaderView.Attributes
    private let centerItem: HeaderView.CenterItemType?
    private let popGestureAction: (() -> Void)?

    // MARK: - Init

    public init(
        leftItem: HeaderView.PeripheralButtonType?,
        centerItem: HeaderView.CenterItemType?,
        rightItem: HeaderView.PeripheralButtonType?,
        attributes: HeaderView.Attributes,
        popGestureAction: (() -> Void)?
    ) {
        self.leftItem = leftItem
        self.centerItem = centerItem
        self.rightItem = rightItem
        self.attributes = attributes
        self.popGestureAction = popGestureAction
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        let body = Group {
            if attributes.appearance == .themed {
                VStack {
                    ThemedView {
                        HeaderView(
                            leftItem: leftItem,
                            centerItem: centerItem,
                            rightItem: rightItem,
                            attributes: attributes
                        )
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
                        attributes: attributes
                    )

                    Spacer(minLength: 0)
                    content
                    Spacer(minLength: 0)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)

        if let popGestureAction {
            body
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(
                        minimumDistance: Floats.dragGestureMinimumDistance,
                        coordinateSpace: .global
                    )
                    .onChanged { value in
                        guard value.startLocation.x < Floats.dragGestureValueLeftEdgeThreshold,
                              value.translation.width > Floats.dragGestureValueRightSwipeThreshold else { return }
                        popGestureAction()
                    }
                )
        } else {
            body
        }
    }
}

public extension View {
    /// - Parameter attributes: Choosing a themed `appearance` value overrides all color values to those of the system theme.
    func header(
        leftItem: HeaderView.PeripheralButtonType? = nil,
        _ centerItem: HeaderView.CenterItemType? = nil,
        rightItem: HeaderView.PeripheralButtonType? = nil,
        attributes: HeaderView.Attributes = .init(),
        popGestureAction: (() -> Void)? = nil
    ) -> some View {
        modifier(
            HeaderViewModifier(
                leftItem: leftItem,
                centerItem: centerItem,
                rightItem: rightItem,
                attributes: attributes,
                popGestureAction: popGestureAction
            )
        )
    }
}
