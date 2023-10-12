//
//  RuntimeStorage.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public actor RuntimeStorage {
    // MARK: - Properties

    private static var storedItems = [String: Any]()

    // MARK: - Removal

    public static func remove(_ item: StoredItemKeyDomain) {
        storedItems[item.keyValue] = nil
    }

    public static func remove(_ item: StoredItemKeyDomain.AppStoredItemKey) {
        storedItems[item.rawValue] = nil
    }

    public static func remove(_ item: StoredItemKeyDomain.CoreStoredItemKey) {
        storedItems[item.rawValue] = nil
    }

    // MARK: - Retrieval

    public static func retrieve(_ item: StoredItemKeyDomain) -> Any? {
        guard let object = storedItems[item.keyValue] else { return nil }
        return object
    }

    public static func retrieve(_ item: StoredItemKeyDomain.AppStoredItemKey) -> Any? {
        guard let object = storedItems[item.rawValue] else { return nil }
        return object
    }

    public static func retrieve(_ item: StoredItemKeyDomain.CoreStoredItemKey) -> Any? {
        guard let object = storedItems[item.rawValue] else { return nil }
        return object
    }

    // MARK: - Storage

    public static func store(_ object: Any, as item: StoredItemKeyDomain) {
        storedItems[item.keyValue] = object
    }

    public static func store(_ object: Any, as item: StoredItemKeyDomain.AppStoredItemKey) {
        storedItems[item.rawValue] = object
    }

    public static func store(_ object: Any, as item: StoredItemKeyDomain.CoreStoredItemKey) {
        storedItems[item.rawValue] = object
    }
}
