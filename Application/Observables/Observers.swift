//
//  Observers.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public enum ObserverType {
    case buildInfoOverlay
}

public final class Observers {
    
    // MARK: - Properties
    
    private(set) static var buildInfoOverlay: BuildInfoOverlayViewObserver?
    
    // MARK: - Registration
    
    public static func register(observer: Observer) {
        switch observer.type {
        case .buildInfoOverlay:
            buildInfoOverlay = observer as? BuildInfoOverlayViewObserver
        }
    }
    
    public static func register(observers: [Observer]) {
        for observer in observers {
            register(observer: observer)
        }
    }
}
