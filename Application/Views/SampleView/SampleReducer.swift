//
//  SampleReducer.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux
import Translator

public struct SampleReducer: Reducer {
    // MARK: - Dependencies

    @Dependency(\.translatorService) private var translator: TranslatorService

    // MARK: - Actions

    public enum Action {
        case viewAppeared
    }

    // MARK: - Feedback

    public enum Feedback {
        case resolveReturned(Callback<[TranslationOutputMap], Exception>)
    }

    // MARK: - State

    public struct State: Equatable {
        /* MARK: Properties */

        var inputs: [TranslationInputMap] = SampleViewStrings.keyPairs
        var strings: [TranslationOutputMap] = SampleViewStrings.keyPairs.defaultOutputMap
        var viewState: ViewState = .loading

        /* MARK: Init */

        public init() {}
    }

    // MARK: - View State

    public enum ViewState: Equatable {
        case loading
        case error(Exception)
        case loaded
    }

    // MARK: - Reduce

    public func reduce(into state: inout State, for event: Event) -> Effect<Feedback> {
        switch event {
        case .action(.viewAppeared):
            RuntimeStorage.store(#file, as: .currentFile)
            state.viewState = .loading

            let inputs = state.inputs
            return .task {
                let result = await translator.resolve(inputs)
                return .resolveReturned(result)
            }

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
