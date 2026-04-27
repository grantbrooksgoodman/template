//
//  RootNavigator.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// The top-level navigation state for the app.
///
/// `RootNavigatorState` tracks the three presentation channels at the
/// root of the view hierarchy – a navigation stack, a sheet, and a
/// full-screen modal – along with nested state for each child
/// navigation flow.
///
/// The ``modal`` property determines which top-level screen the app
/// displays. By default, it is set to ``ModalPaths/splash`` on launch.
/// Add nested ``NavigatorState`` properties for each feature flow
/// the app introduces.
///
/// - SeeAlso: ``RootNavigator``, ``RootNavigationService``
struct RootNavigatorState: NavigatorState {
    // MARK: - Types

    /// The destinations available for full-screen modal presentation
    /// at the root level.
    ///
    /// Add a case for each top-level screen in the app. The
    /// coordinator switches between them by setting
    /// ``RootNavigatorState/modal``.
    enum ModalPaths: Paths {
        /// The splash screen, presented during app startup.
        case splash

        /// The app's primary content flow, provided as a starting
        /// point. Replace this case with your own feature entry
        /// point.
        case sampleContent
    }

    /// The destinations available for push navigation on the root
    /// stack.
    enum SeguePaths: Paths {}

    /// The destinations available for sheet presentation at the root
    /// level.
    enum SheetPaths: Paths {}

    // MARK: - Properties

    /// The nested state for a child navigation flow. Replace with
    /// the navigator state for your app's primary feature.
    var sampleContent: SampleContentNavigatorState = .init()

    /// The currently presented full-screen modal, or `nil` if none
    /// is presented.
    var modal: ModalPaths?

    /// The currently presented sheet, or `nil` if none is presented.
    var sheet: SheetPaths?

    /// The ordered list of views in the root navigation stack.
    var stack: [SeguePaths] = []
}

/// Applies navigation routes to the root-level navigation state.
///
/// `RootNavigator` handles ``RootNavigationService/Route/RootRoute``
/// cases, which control top-level modal presentation at the root of
/// the view hierarchy.
///
/// Routes are dispatched through ``RootNavigationService``, which
/// delegates to this navigator to apply the corresponding state
/// change. Add cases to ``RootRoute`` as the app introduces new
/// root-level destinations.
enum RootNavigator {
    /// Applies the given route to the root navigation state.
    ///
    /// - Parameters:
    ///   - route: The navigation action to perform.
    ///   - state: The current root navigation state, modified in
    ///     place.
    static func navigate(
        to route: RootNavigationService.Route.RootRoute,
        on state: inout RootNavigatorState
    ) {
        switch route {
        case let .modal(modal):
            state.modal = modal
        }
    }
}

/// The set of navigation actions available at the root level.
extension RootNavigationService.Route {
    enum RootRoute {
        /// Presents a full-screen modal at the root of the app.
        case modal(RootNavigatorState.ModalPaths)
    }
}
