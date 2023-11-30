//
//  RootViewObserver.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public struct RootViewObserver: Observer {
    // MARK: - Type Aliases

    public typealias R = RootReducer

    // MARK: - Properties

    public let id = UUID()
    public let observedValues: [any ObservableProtocol] = [Observables.rootViewToast, Observables.rootViewToastAction]
    public let viewModel: ViewModel<R>

    // MARK: - Init

    public init(_ viewModel: ViewModel<R>) {
        self.viewModel = viewModel
    }

    // MARK: - Observer Conformance

    public func linkObservables() {
        Observers.link(RootViewObserver.self, with: observedValues)
    }

    public func onChange(of observable: Observable<Any>) {
        Logger.log(
            "\(observable.value as? Nil != nil ? "Triggered" : "Observed change of") .\(observable.key.rawValue).",
            domain: .observer,
            metadata: [self, #file, #function, #line]
        )

        switch observable.key {
        case .rootViewToast:
            guard let value = observable.value as? Toast else { return }
            send(.toastChanged(value))

        case .rootViewToastAction:
            guard let value = observable.value as? (() -> Void) else { return }
            send(.toastActionChanged(value))

        default: ()
        }
    }

    public func send(_ action: R.Action) {
        Task { @MainActor in
            viewModel.send(action)
        }
    }
}
