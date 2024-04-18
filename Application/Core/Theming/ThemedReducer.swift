//
//  ThemedReducer.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

public struct ThemedReducer: Reducer {
    // MARK: - Dependencies

    @Dependency(\.coreKit.ui) private var coreUI: CoreKit.UI

    // MARK: - Actions

    public enum Action {
        case viewAppeared
        case appearanceChanged
    }

    // MARK: - Feedback

    public typealias Feedback = Never

    // MARK: - State

    public struct State: Equatable {
        /* MARK: Properties */

        // UUID
        public var objectID = UUID()
        public var viewID = UUID()

        // Other
        public var body: () -> any View
        public var navigationBarAppearance: NavigationBarAppearance?
        public var redrawsOnAppearanceChange: Bool

        /* MARK: Init */

        public init(
            _ body: @escaping (() -> any View),
            navigationBarAppearance: NavigationBarAppearance?,
            redrawsOnAppearanceChange: Bool
        ) {
            self.body = body
            self.navigationBarAppearance = navigationBarAppearance
            self.redrawsOnAppearanceChange = redrawsOnAppearanceChange
        }

        /* MARK: Equatable Conformance */

        public static func == (left: ThemedReducer.State, right: ThemedReducer.State) -> Bool {
            let sameNavigationBarAppearance = left.navigationBarAppearance == right.navigationBarAppearance
            let sameObjectID = left.objectID == right.objectID
            let sameRedrawsOnAppearanceChange = left.redrawsOnAppearanceChange == right.redrawsOnAppearanceChange
            let sameViewID = left.viewID == right.viewID

            guard sameNavigationBarAppearance,
                  sameObjectID,
                  sameRedrawsOnAppearanceChange,
                  sameViewID else {
                return false
            }

            return true
        }
    }

    // MARK: - Reduce

    public func reduce(into state: inout State, for event: Event) -> Effect<Feedback> {
        switch event {
        case .action(.viewAppeared):
            guard let navigationBarAppearance = state.navigationBarAppearance else { return .none }
            NavigationBar.setAppearance(navigationBarAppearance)

        case .action(.appearanceChanged):
            if let navigationBarAppearance = state.navigationBarAppearance {
                NavigationBar.setAppearance(navigationBarAppearance)
            }

            state.objectID = UUID()
            guard state.redrawsOnAppearanceChange else { return .none }
            state.viewID = UUID()
        }

        return .none
    }
}
