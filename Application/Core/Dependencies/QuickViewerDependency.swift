//
//  QuickViewerDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum QuickViewerDependency: DependencyKey {
    public static func resolve(_ dependencies: DependencyValues) -> QuickViewer {
        QuickViewer()
    }
}

public extension DependencyValues {
    var quickViewer: QuickViewer {
        get {
            self[QuickViewerDependency.self]
        }
        set {
            self[QuickViewerDependency.self] = newValue
        }
    }
}