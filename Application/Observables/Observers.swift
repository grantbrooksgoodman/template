//
//  Observers.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum ObserverType {
    case buildInfoOverlay
    case themedView
}

public enum Observers {
    // MARK: - Properties

    public private(set) static var buildInfoOverlay: BuildInfoOverlayViewObserver?
    public private(set) static var themedView: ThemedViewObserver?

    // MARK: - Registration

    public static func register(observer: Observer) {
        @Dependency(\.observableRegistry) var registry: ObservableRegistry

        switch observer.type {
        case .buildInfoOverlay:
            buildInfoOverlay = observer as? BuildInfoOverlayViewObserver
        case .themedView:
            themedView = observer as? ThemedViewObserver
        }

        registry.setObservers()
    }

    public static func register(observers: [Observer]) {
        for observer in observers {
            register(observer: observer)
        }
    }
}
