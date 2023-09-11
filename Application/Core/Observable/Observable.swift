//
//  Observable.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public typealias Nil = NSNull

public class Observable<T> {
    
    // MARK: - Properties
    
    public let key: ObservableKey
    public var value: T {
        didSet {
            notify(observers)
        }
    }
    
    private var observers: Array<Observer> = []
    
    // MARK: - Object Lifecycle
    
    public init(_ key: ObservableKey, _ value: T) {
        self.key = key
        self.value = value
    }
    
    deinit {
        removeAllObservers()
    }
    
    // MARK: - Addition/Removal
    
    public func addObserver(_ observer: Observer) {
        guard !observers.contains(where: { $0.id == observer.id }) else { return }
        observers.append(observer)
    }
    
    public func removeObserver(_ observer: Observer) {
        guard let index = observers.firstIndex(where: { $0.id == observer.id }) else { return }
        observers.remove(at: index)
    }
    
    public func removeAllObservers() {
        observers = []
    }
    
    // MARK: - Notification
    
    private func notify(_ observers: [Observer]) {
        observers.forEach({ $0.onChange(of: .init(key, value as Any)) })
    }
}

public extension Observable where T == Nil {
    convenience init(key: ObservableKey) {
        self.init(key, Nil())
    }
    
    func trigger() {
        observers.forEach({ $0.onChange(of: .init(key, value)) })
    }
}
