//
//  Observable.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public typealias Nil = NSNull

public protocol ObservableProtocol {
    // MARK: - Properties

    var key: ObservableKey { get }

    // MARK: - Methods

    func clearObservers()
    func setObservers(_ observers: [any Observer])
}

public final class Observable<T>: ObservableProtocol {
    // MARK: - Properties

    public let key: ObservableKey
    public var value: T {
        didSet {
            notify(observers)
        }
    }

    private var observers: [any Observer] = []

    // MARK: - Object Lifecycle

    public init(_ key: ObservableKey, _ value: T) {
        self.key = key
        self.value = value
    }

    deinit {
        clearObservers()
    }

    // MARK: - Notification

    public func notify(_ observers: [any Observer]) {
        observers.forEach { $0.onChange(of: .init(key, value as Any)) }
    }

    // MARK: - Setters

    public func clearObservers() {
        observers = []
    }

    public func setObservers(_ observers: [any Observer]) {
        self.observers = observers
    }
}

public extension Observable where T == Nil {
    convenience init(key: ObservableKey) {
        self.init(key, Nil())
    }

    func trigger() {
        observers.forEach { $0.onChange(of: .init(key, value)) }
    }
}
