//
//  RuntimeStorage.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public enum RuntimeStorage {
    // MARK: - Properties

    private static var storedItems = [String: Any]()

    // MARK: - Methods

    public static func remove(_ item: StoredItem) {
        storedItems[item.rawValue] = nil
    }

    public static func retrieve(_ item: StoredItem) -> Any? {
        guard let object = storedItems[item.rawValue] else { return nil }
        return object
    }

    public static func store(_ object: Any, as item: StoredItem) {
        storedItems[item.rawValue] = object
    }
}
