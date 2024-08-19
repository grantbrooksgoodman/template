//
//  DetailPageReducer.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public struct DetailPageReducer: Reducer {
    // MARK: - Properties

    @Navigator private var navigationCoordinator: NavigationCoordinator<RootNavigationService>

    // MARK: - Actions

    public enum Action {
        case viewAppeared

        case navigateBackButtonTapped
        case popToSplashButtonTapped
    }

    // MARK: - Feedback

    public typealias Feedback = Never

    // MARK: - State

    public struct State: Equatable {
        /* MARK: Types */

        public enum Configuration: String {
            case modal
            case push
            case sheet
        }

        /* MARK: Properties */

        public var configuration: Configuration

        /* MARK: Computed Properties */

        public var navigationTitle: String { "\(configuration.rawValue.firstUppercase) Detail View" }

        public var popGestureAction: (() -> Void)? {
            guard configuration == .modal else { return nil }
            return {
                @Navigator var navigationCoordinator: NavigationCoordinator<RootNavigationService>
                navigationCoordinator.navigate(to: .sampleContent(.modal(.none)))
            }
        }

        /* MARK: Init */

        public init(_ configuration: Configuration) {
            self.configuration = configuration
        }
    }

    // MARK: - Reduce

    public func reduce(into state: inout State, for event: Event) -> Effect<Feedback> {
        func navigateBack() {
            switch state.configuration {
            case .modal:
                navigationCoordinator.navigate(to: .sampleContent(.modal(.none)))

            case .push:
                navigationCoordinator.navigate(to: .sampleContent(.pop))

            case .sheet:
                navigationCoordinator.navigate(to: .sampleContent(.sheet(.none)))
            }
        }

        switch event {
        case .action(.viewAppeared):
            break

        case .action(.navigateBackButtonTapped):
            navigateBack()

        case .action(.popToSplashButtonTapped):
            navigateBack()
            navigationCoordinator.navigate(to: .root(.modal(.splash)))
        }

        return .none
    }
}
