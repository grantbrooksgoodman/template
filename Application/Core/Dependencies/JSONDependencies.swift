//
//  JSONDependencies.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum JSONDecoderDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> JSONDecoder {
        .init()
    }
}

public enum JSONEncoderDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> JSONEncoder {
        .init()
    }
}

public extension DependencyValues {
    var jsonDecoder: JSONDecoder {
        get {
            self[JSONDecoderDependency.self]
        }
        set {
            self[JSONDecoderDependency.self] = newValue
        }
    }

    var jsonEncoder: JSONEncoder {
        get {
            self[JSONEncoderDependency.self]
        }
        set {
            self[JSONEncoderDependency.self] = newValue
        }
    }
}
