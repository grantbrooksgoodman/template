//
//  ThemedViewObserver.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public class ThemedViewObserver: Observer {
    // MARK: - Properties

    public var type: ObserverType = .themedView
    private let viewModel: ViewModel<ThemedReducer>

    // MARK: - Init

    public init(_ viewModel: ViewModel<ThemedReducer>) {
        self.viewModel = viewModel
    }

    // MARK: - On Change

    public func onChange(of observable: Observable<Any>) {
        if observable.value as? Nil != nil {
            Logger.log(
                "Triggered .\(observable.key.rawValue)",
                domain: .observer,
                metadata: [#file, #function, #line]
            )
        } else {
            Logger.log(
                "Observed change of .\(observable.key.rawValue)",
                domain: .observer,
                metadata: [#file, #function, #line]
            )
        }

        switch observable.key {
        case .themedViewAppearanceChanged:
            send(.appearanceChanged)
        default: ()
        }
    }

    private func send(_ action: ThemedReducer.Action) {
        DispatchQueue.main.async {
            self.viewModel.send(action)
        }
    }
}
