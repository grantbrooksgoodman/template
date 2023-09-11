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
}

/// For sending and accessing observed values between scopes.
public struct ObservableRegistry {
    
    // MARK: - Properties
    
    public let isDeveloperModeEnabled: Observable<Bool> = .init(.isDeveloperModeEnabled, false)
    
    // MARK: - Init
    
    public init() {
        guard let buildInfoOverlayObserver = Observers.buildInfoOverlay else { return }
        isDeveloperModeEnabled.addObserver(buildInfoOverlayObserver)
    }
}
