//
//  ViewObserver.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public final class ViewObserver<O: Observer>: ObservableObject {
    // MARK: - Properties

    private let observer: O

    // MARK: - Object Lifecycle

    public init(_ observer: O) {
        self.observer = observer
        Observers.register(observer: self.observer)
    }

    deinit {
        Observers.retract(observer: observer)
    }
}
