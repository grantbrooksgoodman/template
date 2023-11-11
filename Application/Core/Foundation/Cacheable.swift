//
//  Cacheable.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public protocol Cacheable {
    // MARK: - Properties

    var cache: Cache { get }
    var emptyCache: Cache { get }

    // MARK: - Methods

    func clearCache()
}

public class Cache {
    // MARK: - Properties

    private var objects: [CacheDomain: Any]

    // MARK: - Init

    public init(_ objects: [CacheDomain: Any]) {
        self.objects = objects
    }

    // MARK: - Methods

    public func set(_ value: Any, forKey key: CacheDomain) {
        objects[key] = value
    }

    public func removeObject(forKey key: CacheDomain) {
        objects[key] = nil
    }

    public func value(forKey key: CacheDomain) -> Any? {
        return objects[key]
    }
}
