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

struct RootNavigatorState: NavigatorState {
    // MARK: - Types

    enum ModalPaths: Paths {
        case splash
        case sampleContent
    }

    enum SeguePaths: Paths {}

    enum SheetPaths: Paths {}

    // MARK: - Properties

    var sampleContent: SampleContentNavigatorState = .init()

    var modal: ModalPaths?
    var sheet: SheetPaths?
    var stack: [SeguePaths] = []
}

enum RootNavigator {
    static func navigate(to route: RootNavigationService.Route.RootRoute, on state: inout RootNavigatorState) {
        switch route {
        case let .modal(modal):
            state.modal = modal
        }
    }
}

extension RootNavigationService.Route {
    enum RootRoute {
        case modal(RootNavigatorState.ModalPaths)
    }
}
