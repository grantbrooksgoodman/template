//
//  BuildInfoOverlayViewServiceDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum BuildInfoOverlayViewServiceDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> BuildInfoOverlayViewService {
        .init()
    }
}

public extension DependencyValues {
    var buildInfoOverlayViewService: BuildInfoOverlayViewService {
        get { self[BuildInfoOverlayViewServiceDependency.self] }
        set { self[BuildInfoOverlayViewServiceDependency.self] = newValue }
    }
}
