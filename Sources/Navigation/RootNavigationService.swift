//
//  RootNavigationService.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// A convenience alias for the app's navigation coordinator.
///
/// Use `Navigation` wherever you need to reference the coordinator
/// type without repeating the full generic signature:
///
/// ```swift
/// @ObservedDependency(\.navigation) private var navigation: Navigation
/// ```
typealias Navigation = NavigationCoordinator<RootNavigationService>

/// The app's top-level navigation service.
///
/// `RootNavigationService` conforms to ``Navigating`` and defines the
/// complete set of navigation routes available in the app. When a
/// route is dispatched, this service delegates to the appropriate
/// navigator to apply the corresponding state change.
///
/// You do not interact with this type directly. Instead, call
/// ``NavigationCoordinator/navigate(to:)`` on the app's coordinator:
///
/// ```swift
/// @Dependency(\.navigation) var navigation: Navigation
/// navigation.navigate(to: .root(.modal(.home)))
/// ```
///
/// To introduce a new feature flow, add a ``Route`` case and
/// delegate to the corresponding navigator inside
/// ``navigate(to:on:)``.
struct RootNavigationService: Navigating {
    // MARK: - Type Aliases

    /// The navigation state type for this service.
    typealias State = RootNavigatorState

    // MARK: - Types

    /// The set of navigation actions available in the app.
    ///
    /// Each case groups routes by the navigator responsible for
    /// handling them.
    enum Route {
        /// A route handled by ``RootNavigator``.
        case root(RootRoute)

        /// A route handled by the sample child navigator. Replace
        /// this case or add cases alongside it for each feature flow
        /// in your app.
        case sampleContent(SampleContentRoute)
    }

    // MARK: - Navigate to Route

    /// Dispatches the given route to the appropriate navigator.
    ///
    /// - Parameters:
    ///   - route: The navigation action to perform.
    ///   - state: The current navigation state, modified in place.
    func navigate(to route: Route, on state: inout RootNavigatorState) {
        switch route {
        case let .root(rootRoute):
            RootNavigator.navigate(to: rootRoute, on: &state)

        case let .sampleContent(sampleContentRoute):
            SampleContentNavigator.navigate(to: sampleContentRoute, on: &state.sampleContent)
        }
    }
}
