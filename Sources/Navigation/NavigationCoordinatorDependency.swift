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

enum NavigationCoordinatorDependency: DependencyKey {
    // MARK: - Properties

    private static let didResolve = LockIsolated<Bool>(wrappedValue: false)

    // MARK: - DependencyKey Conformance

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

extension DependencyValues {
    var navigation: NavigationCoordinator<RootNavigationService> {
        get { self[NavigationCoordinatorDependency.self] }
        set { self[NavigationCoordinatorDependency.self] = newValue }
    }
}
