//
//  Persistent.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux

/// Property wrapper for persisting values in `UserDefaults`.
@propertyWrapper
public final class Persistent<T: Codable> {
    // MARK: - Dependencies

    @Dependency(\.userDefaults) private var defaults: UserDefaults
    @Dependency(\.jsonDecoder) private var jsonDecoder: JSONDecoder
    @Dependency(\.jsonEncoder) private var jsonEncoder: JSONEncoder

    // MARK: - Properties

    private let key: UserDefaultsKeyDomain

    // MARK: - Init

    public init(_ key: UserDefaultsKeyDomain) {
        self.key = key
    }

    public convenience init(_ appKey: UserDefaultsKeyDomain.AppDefaultsKey) {
        self.init(.app(appKey))
    }

    public convenience init(_ coreKey: UserDefaultsKeyDomain.CoreDefaultsKey) {
        self.init(.core(coreKey))
    }

    // MARK: - WrappedValue

    public var wrappedValue: T? {
        get {
            guard let data = defaults.value(forKey: key) as? Data,
                  let decoded: T = try? jsonDecoder.decode(T.self, from: data) else {
                return defaults.value(forKey: key) as? T
            }

            return decoded
        }
        set {
            guard let encoded = try? jsonEncoder.encode(newValue) else {
                defaults.set(newValue, forKey: key)
                return
            }

            defaults.set(encoded, forKey: key)
        }
    }
}
