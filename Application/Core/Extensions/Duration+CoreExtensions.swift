//
//  Duration+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public extension Duration {
    var milliseconds: Double {
        (Double(components.seconds) * 1000) + (Double(components.attoseconds) * 1e-15)
    }
}
