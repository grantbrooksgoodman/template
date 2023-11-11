//
//  EmptyReducer.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public struct EmptyReducer: Reducer {
    // MARK: - Actions

    public enum Action {
        case viewAppeared
    }

    // MARK: - Feedback

    public enum Feedback {}

    // MARK: - State

    public struct State: Equatable {
        /* MARK: Init */

        public init() {}
    }

    // MARK: - Init

    public init() { RuntimeStorage.store(#file, as: .presentedViewName) }

    // MARK: - Reduce

    public func reduce(into state: inout State, for event: Event) -> Effect<Feedback> {
        switch event {
        case .action(.viewAppeared):
            break
        }

        return .none
    }
}
