//
//  BreadcrumbsDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public enum BreadcrumbsDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> Breadcrumbs {
        .init()
    }
}

public extension DependencyValues {
    var breadcrumbs: Breadcrumbs {
        get { self[BreadcrumbsDependency.self] }
        set { self[BreadcrumbsDependency.self] = newValue }
    }
}
