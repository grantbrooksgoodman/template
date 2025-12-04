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

typealias Navigation = NavigationCoordinator<RootNavigationService>

struct RootNavigationService: Navigating {
    // MARK: - Type Aliases

    typealias State = RootNavigatorState

    // MARK: - Types

    enum Route {
        case root(RootRoute)
        case sampleContent(SampleContentRoute)
    }

    // MARK: - Navigate to Route

    func navigate(to route: Route, on state: inout RootNavigatorState) {
        switch route {
        case let .root(rootRoute):
            RootNavigator.navigate(to: rootRoute, on: &state)

        case let .sampleContent(sampleContentRoute):
            SampleContentNavigator.navigate(to: sampleContentRoute, on: &state.sampleContent)
        }
    }
}
