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

struct SamplePageReducer: Reducer {
    // MARK: - Dependencies

    @Dependency(\.navigation) private var navigation: Navigation
    @Dependency(\.translationService) private var translator: TranslationService

    // MARK: - Actions

    enum Action {
        case viewAppeared

        case modalButtonTapped
        case pushButtonTapped
        case resolveFailed(Exception)
        case resolveReturned([TranslationOutputMap])
        case sheetButtonTapped
    }

    // MARK: - State

    struct State: Equatable {
        let titleLabelText = Localized(.helloWorld).wrappedValue

        var strings: [TranslationOutputMap] = SamplePageViewStrings.defaultOutputMap
        var viewState: StatefulView.ViewState = .loading
    }

    // MARK: - Reduce

    func reduce(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        switch action {
        case .viewAppeared:
            state.viewState = .loading
            return .task {
                do throws(Exception) {
                    return try await .resolveReturned(
                        translator.resolve(SamplePageViewStrings.self)
                    )
                } catch {
                    return .resolveFailed(error)
                }
            }

        case .modalButtonTapped:
            return .fireAndForget { @MainActor in
                navigation.navigate(to: .sampleContent(.modal(.modalDetail)))
            }

        case .pushButtonTapped:
            return .fireAndForget { @MainActor in
                navigation.navigate(to: .sampleContent(.push(.pushDetail)))
            }

        case let .resolveFailed(exception):
            Logger.log(exception)
            state.viewState = .loaded

        case let .resolveReturned(strings):
            state.strings = strings
            state.viewState = .loaded

        case .sheetButtonTapped:
            return .fireAndForget { @MainActor in
                navigation.navigate(to: .sampleContent(.sheet(.sheetDetail)))
            }
        }

        return .none
    }
}
