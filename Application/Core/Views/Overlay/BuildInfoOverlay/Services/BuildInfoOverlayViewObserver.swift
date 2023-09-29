//
//  BuildInfoOverlayViewObserver.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public class BuildInfoOverlayViewObserver: Observer {
    // MARK: - Properties

    public var type: ObserverType = .buildInfoOverlay
    private let viewModel: ViewModel<BuildInfoOverlayReducer>

    // MARK: - Init

    public init(_ viewModel: ViewModel<BuildInfoOverlayReducer>) {
        self.viewModel = viewModel
    }

    // MARK: - On Change

    public func onChange(of observable: Observable<Any>) {
        if observable.value as? Nil != nil {
            Logger.log(
                "Triggered .\(observable.key.rawValue).",
                domain: .observer,
                metadata: [#file, #function, #line]
            )
        } else {
            Logger.log(
                "Observed change of .\(observable.key.rawValue).",
                domain: .observer,
                metadata: [#file, #function, #line]
            )
        }

        switch observable.key {
        case .breadcrumbsDidCapture:
            send(.breadcrumbsDidCapture)

        case .isDeveloperModeEnabled:
            guard let value = observable.value as? Bool else { return }
            send(.isDeveloperModeEnabledChanged(value))

        default: ()
        }
    }

    private func send(_ action: BuildInfoOverlayReducer.Action) {
        @Dependency(\.mainQueue) var mainQueue: DispatchQueue
        mainQueue.async {
            Task { @MainActor in
                self.viewModel.send(action)
            }
        }
    }
}
