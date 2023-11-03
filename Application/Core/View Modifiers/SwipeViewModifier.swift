//
//  SwipeViewModifier.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

public enum SwipeModifierConfig {
    public static let sensitivityFactor: CGFloat = 400
    public static let minimumDragGestureDistance: CGFloat = 30
}

public struct Swipe: OptionSet, Equatable {
    // MARK: - Properties

    public let rawValue: Int
    fileprivate var swiped: ((DragGesture.Value, CGFloat) -> Bool) = { _, _ in false }

    // MARK: - Computed Properties

    // Array

    public static var all: Swipe { [.down, .left, .right, .up] }
    fileprivate var array: [Swipe] { [.left, .right, .up, .down].filter { self.contains($0) } }

    // Horizontal Directions

    public static var left: Swipe {
        var swipe = Swipe(rawValue: 1 << 0)
        swipe.swiped = { value, sensitivity in
            value.translation.width < 0 && value.predictedEndTranslation.width < sensitivity * SwipeModifierConfig.sensitivityFactor
        }
        return swipe
    }

    public static var right: Swipe {
        var swipe = Swipe(rawValue: 1 << 1)
        swipe.swiped = { value, sensitivity in
            value.translation.width > 0 && value.predictedEndTranslation.width > sensitivity * SwipeModifierConfig.sensitivityFactor
        }
        return swipe
    }

    // Vertical Directions

    public static var down: Swipe {
        var swipe = Swipe(rawValue: 1 << 3)
        swipe.swiped = { value, sensitivity in
            value.translation.height > 0 && value.predictedEndTranslation.height > sensitivity * SwipeModifierConfig.sensitivityFactor
        }
        return swipe
    }

    public static var up: Swipe {
        var swipe = Swipe(rawValue: 1 << 2)
        swipe.swiped = { value, sensitivity in
            value.translation.height < 0 && value.predictedEndTranslation.height < sensitivity * SwipeModifierConfig.sensitivityFactor
        }
        return swipe
    }

    // MARK: - Init

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension View {
    func onSwipe(
        _ swipe: Swipe,
        sensitivity: CGFloat = 1,
        action: @escaping () -> Void
    ) -> some View {
        gesture(
            DragGesture(
                minimumDistance: SwipeModifierConfig.minimumDragGestureDistance,
                coordinateSpace: .local
            )
            .onEnded { value in
                for swipe in swipe.array where swipe.swiped(value, sensitivity) {
                    action()
                }
            }
        )
    }
}
