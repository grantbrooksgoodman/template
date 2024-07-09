//
//  ReportDelegateDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import CoreArchitecture

public enum ReportDelegateDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> ReportDelegate {
        .shared
    }
}

public extension DependencyValues {
    var reportDelegate: ReportDelegate {
        get { self[ReportDelegateDependency.self] }
        set { self[ReportDelegateDependency.self] = newValue }
    }
}
