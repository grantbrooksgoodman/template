//
//  NavigationCoordinatorDependency.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

/// The dependency key that provides access to the app's navigation
/// coordinator.
///
/// This key resolves a ``NavigationCoordinator`` parameterized over
/// ``RootNavigationService``. On first access, it creates the
/// coordinator with an initial ``RootNavigatorState`` and stores it
/// in the ``NavigationCoordinatorResolver``. Subsequent accesses
/// return the existing coordinator.
///
/// Update the initial state passed to the coordinator to match your
/// app's launch flow.
///
/// - Important: This key is not intended for direct use. Access the
///   coordinator through the ``DependencyValues/navigation`` key
///   path instead.
enum NavigationCoordinatorDependency: DependencyKey {
    // MARK: - Properties

    private static let didResolve = LockIsolated<Bool>(false)

    // MARK: - DependencyKey Conformance

    /// Resolves the navigation coordinator, creating it on first
    /// access.
    ///
    /// The first call initializes the coordinator with the initial
    /// navigation state and stores it in the
    /// ``NavigationCoordinatorResolver``. All subsequent calls
    /// retrieve the existing coordinator through the ``Navigator``
    /// property wrapper.
    static func resolve(_: DependencyValues) -> NavigationCoordinator<RootNavigationService> {
        didResolve.projectedValue.withValue {
            guard !$0 else {
                @Navigator var navigationCoordinator: NavigationCoordinator<RootNavigationService>
                return navigationCoordinator
            }

            @MainActorIsolated var navigationCoordinator: NavigationCoordinator<RootNavigationService> = .init(
                .init(modal: .splash),
                navigating: RootNavigationService()
            )

            NavigationCoordinatorResolver.shared.store(navigationCoordinator)
            $0 = true
            return navigationCoordinator
        }
    }
}

/// Provides access to the app's navigation coordinator through the
/// dependency injection system.
extension DependencyValues {
    /// The app's navigation coordinator.
    ///
    /// Use this key path with ``Dependency`` or
    /// ``ObservedDependency`` to access or observe the navigation
    /// coordinator:
    ///
    /// ```swift
    /// // In a SwiftUI view:
    /// @ObservedDependency(\.navigation) private var navigation: Navigation
    ///
    /// // In a reducer or service:
    /// @Dependency(\.navigation) var navigation: Navigation
    /// ```
    var navigation: NavigationCoordinator<RootNavigationService> {
        get { self[NavigationCoordinatorDependency.self] }
        set { self[NavigationCoordinatorDependency.self] = newValue }
    }
}
