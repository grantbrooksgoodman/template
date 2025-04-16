//
//  SamplePageReducer.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* Proprietary */
import AppSubsystem
import Translator

public struct SamplePageReducer: Reducer {
    // MARK: - Dependencies

    @Dependency(\.navigation) private var navigation: Navigation
    @Dependency(\.translationService) private var translator: TranslationService

    // MARK: - Actions

    public enum Action {
        case viewAppeared

        case modalButtonTapped
        case pushButtonTapped
        case resolveReturned(Callback<[TranslationOutputMap], Exception>)
        case sheetButtonTapped
    }

    // MARK: - State

    public struct State: Equatable {
        /* MARK: Properties */

        public var strings: [TranslationOutputMap] = SamplePageViewStrings.defaultOutputMap
        public var viewState: StatefulView.ViewState = .loading

        /* MARK: Init */

        public init() {}
    }

    // MARK: - Reduce

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .viewAppeared:
            state.viewState = .loading
            return .task {
                let result = await translator.resolve(SamplePageViewStrings.self)
                return .resolveReturned(result)
            }

        case .modalButtonTapped:
            navigation.navigate(to: .sampleContent(.modal(.modalDetail)))

        case .pushButtonTapped:
            navigation.navigate(to: .sampleContent(.push(.pushDetail)))

        case let .resolveReturned(.success(strings)):
            state.strings = strings
            state.viewState = .loaded

        case let .resolveReturned(.failure(exception)):
            Logger.log(exception)
            state.viewState = .loaded

        case .sheetButtonTapped:
            navigation.navigate(to: .sampleContent(.sheet(.sheetDetail)))
        }

        return .none
    }
}
