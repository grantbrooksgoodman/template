//
//  SamplePageReducer.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture
import Translator

public struct SamplePageReducer: Reducer {
    // MARK: - Dependencies

    @Dependency(\.translationService) private var translator: TranslationService

    // MARK: - Properties

    @Navigator private var navigationCoordinator: NavigationCoordinator<RootNavigationService>

    // MARK: - Actions

    public enum Action {
        case viewAppeared

        case modalButtonTapped
        case pushButtonTapped
        case sheetButtonTapped
    }

    // MARK: - Feedback

    public enum Feedback {
        case resolveReturned(Callback<[TranslationOutputMap], Exception>)
    }

    // MARK: - State

    public struct State: Equatable {
        /* MARK: Types */

        public enum ViewState: Equatable {
            case loading
            case error(Exception)
            case loaded
        }

        /* MARK: Properties */

        public var strings: [TranslationOutputMap] = SamplePageViewStrings.defaultOutputMap
        public var viewState: ViewState = .loading

        /* MARK: Init */

        public init() {}
    }

    // MARK: - Reduce

    public func reduce(into state: inout State, for event: Event) -> Effect<Feedback> {
        switch event {
        case .action(.viewAppeared):
            state.viewState = .loading
            return .task {
                let result = await translator.resolve(SamplePageViewStrings.self)
                return .resolveReturned(result)
            }

        case .action(.modalButtonTapped):
            navigationCoordinator.navigate(to: .sampleContent(.modal(.modalDetail)))

        case .action(.pushButtonTapped):
            navigationCoordinator.navigate(to: .sampleContent(.push(.pushDetail)))

        case .action(.sheetButtonTapped):
            navigationCoordinator.navigate(to: .sampleContent(.sheet(.sheetDetail)))

        case let .feedback(.resolveReturned(.success(strings))):
            state.strings = strings
            state.viewState = .loaded

        case let .feedback(.resolveReturned(.failure(exception))):
            Logger.log(exception)
            state.viewState = .loaded
        }

        return .none
    }
}
