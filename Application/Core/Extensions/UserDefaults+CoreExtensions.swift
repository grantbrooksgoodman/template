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
    func removeObject(forKey defaultName: UserDefaultsKey) {
        removeObject(forKey: defaultName.rawValue)
    }
    
    func reset(keeping defaultsKeys: [UserDefaultsKey]? = nil) {
        let dictionary = dictionaryRepresentation()
        
        var mappedValues = [String: Any]()
        if let defaultsKeys {
            for key in defaultsKeys {
                guard let value = value(forKey: key.rawValue) else { continue }
                mappedValues[key.rawValue] = value
            }
        }
        
        dictionary.keys.forEach { key in
            removeObject(forKey: key)
        }
        
        for key in mappedValues.keys {
            guard let value = mappedValues[key] else { continue }
            set(value, forKey: key)
        }
    }
    
    /// Sets the value of the specified default key.
    func set(_ value: Any?, forKey defaultName: UserDefaultsKey) {
        set(value, forKey: defaultName.rawValue)
    }
    
    /// Returns the value for the property identified by a given key.
    func value(forKey key: UserDefaultsKey) -> Any? {
        value(forKey: key.rawValue)
    }
}
