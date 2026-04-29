//
//  SampleContentNavigator.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// A reference ``NavigatorState`` that demonstrates the child
/// navigator pattern.
///
/// Each feature flow in the app declares its own navigator state.
/// The state tracks three presentation channels – a navigation
/// stack, a sheet, and a full-screen modal – using
/// ``Paths``-conforming enums. To add a new feature flow:
///
/// 1. Create a struct conforming to ``NavigatorState``.
/// 2. Define ``Paths``-conforming enums for each presentation
///    channel the flow uses.
/// 3. Create a corresponding navigator enum with a static
///    `navigate(to:on:)` method.
/// 4. Add a route enum as a nested type on
///    ``RootNavigationService/Route``.
/// 5. Wire the new navigator into ``RootNavigationService``.
///
/// Modify navigation state through the navigator's
/// `navigate(to:on:)` method rather than setting properties
/// directly, so that all routing logic remains centralized.
///
/// - SeeAlso: ``SampleContentNavigator``,
///   ``RootNavigationService/Route/SampleContentRoute``
struct SampleContentNavigatorState: NavigatorState {
    // MARK: - Types

    /// The destinations available for full-screen modal presentation.
    ///
    /// Add a case for each full-screen modal your feature presents.
    enum ModalPaths: Paths {
        case modalDetail
    }

    /// The destinations available for push navigation on the stack.
    ///
    /// Add a case for each push destination your feature presents.
    enum SeguePaths: Paths {
        case pushDetail
    }

    /// The destinations available for sheet presentation.
    ///
    /// Add a case for each sheet your feature presents.
    enum SheetPaths: Paths {
        case sheetDetail
    }

    // MARK: - Properties

    /// The currently presented full-screen modal, or `nil` if none
    /// is presented.
    var modal: ModalPaths?

    /// The currently presented sheet, or `nil` if none is presented.
    var sheet: SheetPaths?

    /// The ordered list of views in the navigation stack.
    var stack: [SeguePaths] = []
}

/// A reference navigator that demonstrates child routing logic.
///
/// Each feature flow in the app has a corresponding navigator enum
/// with a static `navigate(to:on:)` method that translates route
/// values into state mutations. Replace this navigator or add
/// navigators alongside it for each feature flow in your app.
///
/// Routes are dispatched through ``RootNavigationService``, which
/// delegates to the appropriate navigator to apply the
/// corresponding state change.
enum SampleContentNavigator {
    /// Applies the given route to the navigation state.
    ///
    /// - Parameters:
    ///   - route: The navigation action to perform.
    ///   - state: The current navigation state, modified in place.
    static func navigate(
        to route: RootNavigationService.Route.SampleContentRoute,
        on state: inout SampleContentNavigatorState
    ) {
        switch route {
        case let .modal(modal):
            state.modal = modal

        case .pop:
            guard !state.stack.isEmpty else { return }
            state.stack.removeLast()

        case let .push(path):
            state.stack.append(path)

        case let .sheet(sheet):
            state.sheet = sheet

        case let .stack(paths):
            state.stack = paths
        }
    }
}

/// The set of navigation actions available for the sample child
/// navigator.
///
/// Each case represents a navigation intent that the navigator
/// translates into a state change on its
/// ``SampleContentNavigatorState``. Define a similar route enum for
/// each feature flow in your app.
extension RootNavigationService.Route {
    enum SampleContentRoute {
        /// Presents or dismisses a full-screen modal.
        ///
        /// Pass a ``SampleContentNavigatorState/ModalPaths`` value to
        /// present, or `nil` to dismiss.
        case modal(SampleContentNavigatorState.ModalPaths?)

        /// Pops the topmost view from the navigation stack.
        case pop

        /// Pushes a view onto the navigation stack.
        case push(SampleContentNavigatorState.SeguePaths)

        /// Presents or dismisses a sheet.
        ///
        /// Pass a ``SampleContentNavigatorState/SheetPaths`` value to
        /// present, or `nil` to dismiss.
        case sheet(SampleContentNavigatorState.SheetPaths?)

        /// Replaces the entire navigation stack.
        case stack([SampleContentNavigatorState.SeguePaths])
    }
}
