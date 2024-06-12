//
//  BuildInfoOverlayViewObserver.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public struct BuildInfoOverlayViewObserver: Observer {
    // MARK: - Type Aliases

    public typealias R = BuildInfoOverlayReducer

    // MARK: - Properties

    public let id = UUID()
    public let observedValues: [any ObservableProtocol] = [Observables.breadcrumbsDidCapture, Observables.isDeveloperModeEnabled]
    public let viewModel: ViewModel<R>

    // MARK: - Init

    public init(_ viewModel: ViewModel<R>) {
        self.viewModel = viewModel
    }

    // MARK: - Observer Conformance

    public func linkObservables() {
        Observers.link(BuildInfoOverlayViewObserver.self, with: observedValues)
    }

    public func onChange(of observable: Observable<Any>) {
        Logger.log(
            "\(observable.value as? Nil != nil ? "Triggered" : "Observed change of") .\(observable.key.rawValue).",
            domain: .observer,
            metadata: [self, #file, #function, #line]
        )

        switch observable.key {
        case .breadcrumbsDidCapture:
            send(.breadcrumbsDidCapture)

        case .isDeveloperModeEnabled:
            guard let value = observable.value as? Bool else { return }
            send(.isDeveloperModeEnabledChanged(value))

        default: ()
        }
    }

    public func send(_ action: R.Action) {
        Task { @MainActor in
            viewModel.send(action)
        }
    }
}
