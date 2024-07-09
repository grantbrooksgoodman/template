//
//  FailurePageReducer.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import AlertKit
import CoreArchitecture

public struct FailurePageReducer: Reducer {
    // MARK: - Dependencies

    @Dependency(\.alertKitConfig) private var alertKitConfig: AlertKit.Config
    @Dependency(\.build) private var build: Build

    // MARK: - Actions

    public enum Action {
        case executeRetryHandler
        case reportBugButtonTapped
    }

    // MARK: - Feedback

    public typealias Feedback = Never

    // MARK: - State

    public struct State: Equatable {
        /* MARK: Properties */

        // String
        @Localized(.reportBug) public var reportBugButtonText: String
        @Localized(.tryAgain) public var retryButtonText: String

        // Other
        public var didReportBug = false
        public var exception: Exception
        public var retryHandler: (() -> Void)?

        /* MARK: Init */

        public init(
            _ exception: Exception,
            retryHandler: (() -> Void)? = nil
        ) {
            self.exception = exception
            self.retryHandler = retryHandler
        }

        /* MARK: Equatable Conformance */

        public static func == (left: State, right: State) -> Bool {
            let bothNilRetryHandlers = left.retryHandler == nil && right.retryHandler == nil
            let sameDidReportBug = left.didReportBug == right.didReportBug
            let sameException = left.exception == right.exception
            let sameReportBugButtonText = left.reportBugButtonText == right.reportBugButtonText
            let sameRetryButtonText = left.retryButtonText == right.retryButtonText

            guard bothNilRetryHandlers,
                  sameDidReportBug,
                  sameException,
                  sameReportBugButtonText,
                  sameRetryButtonText else { return false }

            return true
        }
    }

    // MARK: - Init

    public init() { RuntimeStorage.store(#file, as: .presentedViewName) }

    // MARK: - Reduce

    public func reduce(into state: inout State, for event: Event) -> Effect<Feedback> {
        switch event {
        case .action(.executeRetryHandler):
            guard let effect = state.retryHandler else { return .none }
            effect()

        case .action(.reportBugButtonTapped):
            guard build.isOnline else {
                Task { await ConnectionAlert.present() }
                return .none
            }

            alertKitConfig.reportDelegate?.fileReport(state.exception)
            state.didReportBug = true
        }

        return .none
    }
}
