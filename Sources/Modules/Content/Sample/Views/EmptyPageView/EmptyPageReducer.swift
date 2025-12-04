//
//  EmptyPageReducer.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

struct EmptyPageReducer: Reducer {
    // MARK: - Actions

    enum Action {
        case viewAppeared
    }

    // MARK: - State

    struct State: Equatable {
        init() {}
    }

    // MARK: - Reduce

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .viewAppeared:
            break
        }

        return .none
    }
}
