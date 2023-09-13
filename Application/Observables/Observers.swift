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

public final class Observers {
    
    // MARK: - Dependencies
    
    @Dependency(\.observableRegistry) private static var registry: ObservableRegistry
    
    // MARK: - Properties
    
    private(set) static var buildInfoOverlay: BuildInfoOverlayViewObserver?
    private(set) static var themedView: ThemedViewObserver?
    
    // MARK: - Registration
    
    public static func register(observer: Observer) {
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
