//
//  RuntimeStorage.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import UIKit

public enum RuntimeStorage {
    // MARK: - Properties

    public enum StoredItem: String {
        /* MARK: Cases */

        /* Add cases here for each new object. */

        // AppDelegate
        case currentFile
        case languageCode
        case languageCodeDictionary
        case overriddenLanguageCode

        // SceneDelegate
        case topWindow

        /* MARK: Properties */

        public var description: String {
            return rawValue.snakeCased
        }
    }

    private static var storedItems = [String: Any]()

    // MARK: - Methods

    public static func remove(_ item: StoredItem) {
        storedItems[item.description] = nil
    }

    public static func retrieve(_ item: StoredItem) -> Any? {
        guard let object = storedItems[item.description] else { return nil }
        return object
    }

    public static func store(_ object: Any, as: StoredItem) {
        storedItems[`as`.description] = object
    }
}

public extension RuntimeStorage {
    /* Add new static properties here for quick access. */

    // MARK: - AppDelegate

    static var currentFile: String? { retrieve(.currentFile) as? String }
    // swiftlint:disable:next line_length
    static var languageCode: String? { guard let overridden = retrieve(.overriddenLanguageCode) as? String else { return retrieve(.languageCode) as? String }; return overridden }
    static var languageCodeDictionary: [String: String]? { retrieve(.languageCodeDictionary) as? [String: String] }

    // MARK: - SceneDelegate

    static var topWindow: UIWindow? { retrieve(.topWindow) as? UIWindow }
}
