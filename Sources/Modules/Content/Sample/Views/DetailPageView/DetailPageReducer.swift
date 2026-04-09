//
//  DetailPageReducer.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem

struct DetailPageReducer: Reducer {
    // MARK: - Dependencies

    @Dependency(\.navigation) private var navigation: Navigation

    // MARK: - Actions

    enum Action {
        case viewAppeared

        case navigateBackButtonTapped
        case popToSplashButtonTapped
    }

    // MARK: - State

    struct State: Equatable {
        /* MARK: Types */

        enum Configuration: String {
            case modal
            case push
            case sheet
        }

        /* MARK: Properties */

        var configuration: Configuration

        /* MARK: Computed Properties */

        var navigationTitle: String { "\(configuration.rawValue.firstUppercase) Detail View" }

        var popGestureAction: (@MainActor () -> Void)? {
            guard configuration == .modal else { return nil }
            return {
                @Dependency(\.navigation) var navigation: Navigation
                navigation.navigate(to: .sampleContent(.modal(.none)))
            }
        }

        /* MARK: Init */

        init(_ configuration: Configuration) {
            self.configuration = configuration
        }
    }

    // MARK: - Reduce

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        @MainActor
        func navigateBack(_ configuration: State.Configuration) {
            switch configuration {
            case .modal: navigation.navigate(to: .sampleContent(.modal(.none)))
            case .push: navigation.navigate(to: .sampleContent(.pop))
            case .sheet: navigation.navigate(to: .sampleContent(.sheet(.none)))
            }
        }

        switch action {
        case .viewAppeared:
            break

        case .navigateBackButtonTapped:
            let configuration = state.configuration
            return .fireAndForget { @MainActor in
                navigateBack(configuration)
            }

        case .popToSplashButtonTapped:
            let configuration = state.configuration
            return .fireAndForget { @MainActor in
                navigateBack(configuration)
                navigation.navigate(to: .root(.modal(.splash)))
            }
        }

        return .none
    }
}
