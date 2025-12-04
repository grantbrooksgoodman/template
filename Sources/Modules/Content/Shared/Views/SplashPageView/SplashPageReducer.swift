//
//  SplashPageReducer.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

struct SplashPageReducer: Reducer {
    // MARK: - Dependencies

    @Dependency(\.navigation) private var navigation: Navigation

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
            return .task(delay: .seconds(1)) {
                navigation.navigate(to: .root(.modal(.sampleContent)))
                return .none
            }
        }
    }
}
