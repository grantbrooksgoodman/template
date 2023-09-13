//
//  ObservableRegistry.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public enum ObservableKey: String {
    case isDeveloperModeEnabled
    case themedViewAppearanceChanged
}

/// For sending and accessing observed values between scopes.
public struct ObservableRegistry {
    
    // MARK: - Properties
    
    public let isDeveloperModeEnabled: Observable<Bool> = .init(.isDeveloperModeEnabled, false)
    public let themedViewAppearanceChanged: Observable<Nil> = .init(key: .themedViewAppearanceChanged)
    
    // MARK: - Init
    
    public init() {
        setObservers()
    }
    
    // MARK: - Set Observers
    
    public func setObservers() {
        if let buildInfoOverlayObserver = Observers.buildInfoOverlay {
            isDeveloperModeEnabled.addObserver(buildInfoOverlayObserver)
        }
        
        if let themedViewObserver = Observers.themedView {
            themedViewAppearanceChanged.addObserver(themedViewObserver)
        }
    }
}
