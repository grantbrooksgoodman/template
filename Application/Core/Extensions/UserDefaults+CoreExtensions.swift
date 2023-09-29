//
//  UserDefaults+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public extension UserDefaults {
    /// Removes the value of the specified default key.
    func removeObject(forKey defaultName: UserDefaultsKeyDomain) {
        removeObject(forKey: defaultName.keyValue)
    }

    func reset(keeping defaultsKeys: [UserDefaultsKeyDomain]? = nil) {
        let dictionary = dictionaryRepresentation()

        var mappedValues = [String: Any]()
        if let defaultsKeys {
            for key in defaultsKeys {
                guard let value = value(forKey: key.keyValue) else { continue }
                mappedValues[key.keyValue] = value
            }
        }

        dictionary.keys.forEach { removeObject(forKey: $0) }
        mappedValues.forEach { key, value in
            set(value, forKey: key)
        }
    }

    /// Sets the value of the specified default key.
    func set(_ value: Any?, forKey defaultName: UserDefaultsKeyDomain) {
        set(value, forKey: defaultName.keyValue)
    }

    /// Returns the value for the property identified by a given key.
    func value(forKey key: UserDefaultsKeyDomain) -> Any? {
        value(forKey: key.keyValue)
    }
}
