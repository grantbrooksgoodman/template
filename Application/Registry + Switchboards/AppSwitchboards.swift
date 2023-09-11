//
//  AppSwitchboards.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public enum SwitchboardType {
    case buildInfoOverlay
}

public protocol Switchboard {
    var type: SwitchboardType { get }
}

public final class AppSwitchboards {
    
    // MARK: - Properties
    
    private(set) static var buildInfoOverlay: BuildInfoOverlayViewSwitchboard?
    
    // MARK: - Registration
    
    public static func register(switchboard: Switchboard) {
        switch switchboard.type {
        case .buildInfoOverlay:
            buildInfoOverlay = switchboard as? BuildInfoOverlayViewSwitchboard
        }
    }
    
    public static func register(switchboards: [Switchboard]) {
        for switchboard in switchboards {
            register(switchboard: switchboard)
        }
    }
}
