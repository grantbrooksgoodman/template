//
//  UserDefaultsDependency.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

public enum UserDefaultsDependency: DependencyKey {
    public static func resolve(_ dependencies: DependencyValues) -> UserDefaults {
        UserDefaults.standard
    }
}

public extension DependencyValues {
    var userDefaults: UserDefaults {
        get {
            self[UserDefaultsDependency.self]
        }
        set {
            self[UserDefaultsDependency.self] = newValue
        }
    }
}
