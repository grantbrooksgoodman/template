//
//  RootReducer.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import CoreArchitecture

public struct RootReducer: Reducer {
    // MARK: - Dependencies

    @Dependency(\.rootWindowService) private var rootWindowService: RootWindowService

    // MARK: - Actions

    public enum Action {
        case viewAppeared

        case isPresentingSheetChanged(Bool)
        case sheetChanged(AnyView?)

        case toastActionChanged(() -> Void)
        case toastChanged(Toast?)
        case toastTapped
    }

    // MARK: - Feedback

    public typealias Feedback = Never

    // MARK: - State

    public struct State: Equatable {
        /* MARK: Properties */

        public var isPresentingSheet = false
        public var sheet: AnyView = .init(EmptyView())
        public var toast: Toast?
        public var toastAction: (() -> Void)?

        /* MARK: Init */

        public init() {}

        /* MARK: Equatable Conformance */

        public static func == (left: State, right: State) -> Bool {
            let sameIsPresentingSheet = left.isPresentingSheet == right.isPresentingSheet
            let sameToast = left.toast == right.toast
            let sameToastAction = left.toastAction.debugDescription == right.toastAction.debugDescription

            guard sameIsPresentingSheet,
                  sameToast,
                  sameToastAction else { return false }
            return true
        }
    }

    // MARK: - Init

    public init() { RuntimeStorage.store(#file, as: .presentedViewName) }

    // MARK: - Reduce

    public func reduce(into state: inout State, for event: Event) -> Effect<Feedback> {
        switch event {
        case .action(.viewAppeared):
            rootWindowService.startRaisingWindow()

        case let .action(.sheetChanged(sheet)):
            state.sheet = sheet ?? .init(EmptyView())
            state.isPresentingSheet = sheet != nil

        case let .action(.isPresentingSheetChanged(isPresentingSheet)):
            state.isPresentingSheet = isPresentingSheet

        case let .action(.toastActionChanged(action)):
            state.toastAction = action

        case let .action(.toastChanged(toast)):
            state.toast = toast
            state.toastAction = nil

        case .action(.toastTapped):
            state.toastAction?()
        }

        return .none
    }
}
