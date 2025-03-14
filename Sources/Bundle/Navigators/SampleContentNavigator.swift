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

public struct SampleContentNavigatorState: NavigatorState {
    // MARK: - Types

    public enum ModalPaths: Paths {}

    public enum SeguePaths: Paths {}

    public enum SheetPaths: Paths {}

    // MARK: - Properties

    public var modal: ModalPaths?
    public var sheet: SheetPaths?
    public var stack: [SeguePaths] = []
}

public enum SampleContentNavigator {
    static func navigate(to route: RootNavigationService.Route.SampleContentRoute, on state: inout SampleContentNavigatorState) {
//        switch route {
//        case let .modal(modal):
//            state.modal = modal

//        case .pop:
//            guard !state.stack.isEmpty else { return }
//            state.stack.removeLast()
//
//        case let .push(path):
//            state.stack.append(path)
//
//        case let .sheet(sheet):
//            state.sheet = sheet
//
//        case let .stack(paths):
//            state.stack = paths
//        }
    }
}

public extension RootNavigationService.Route {
    enum SampleContentRoute {
//        case modal(SampleContentNavigatorState.ModalPaths?)
//        case pop
//        case push(SampleContentNavigatorState.SeguePaths)
//        case sheet(SampleContentNavigatorState.SheetPaths?)
//        case stack([SampleContentNavigatorState.SeguePaths])
    }
}
