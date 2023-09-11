//
//  URLSessionDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum URLSessionDependency: DependencyKey {
    public static func resolve(_ dependencies: DependencyValues) -> URLSession {
        URLSession.shared
    }
}

public extension DependencyValues {
    var urlSession: URLSession {
        get {
            self[URLSessionDependency.self]
        }
        set {
            self[URLSessionDependency.self] = newValue
        }
    }
}
