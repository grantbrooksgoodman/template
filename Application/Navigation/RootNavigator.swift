//
//  RootNavigator.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public struct RootNavigatorState: NavigatorState {
    // MARK: - Types

    public enum ModalPaths: Paths {
        case splash
        case sampleContent
    }

    public enum SeguePaths: Paths {}

    public enum SheetPaths: Paths {}

    // MARK: - Properties

    public var sampleContent: SampleContentNavigatorState = .init()

    public var modal: ModalPaths?
    public var sheet: SheetPaths?
    public var stack: [SeguePaths] = []
}

public enum RootNavigator {
    static func navigate(to route: RootNavigationService.Route.RootRoute, on state: inout RootNavigatorState) {
        switch route {
        case let .modal(modal):
            state.modal = modal
        }
    }
}

public extension RootNavigationService.Route {
    enum RootRoute {
        case modal(RootNavigatorState.ModalPaths)
    }
}
