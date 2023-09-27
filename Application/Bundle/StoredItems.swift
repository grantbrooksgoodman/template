//
//  StoredItems.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import UIKit

public enum StoredItem: String {
    // MARK: - Cases

    /* Add cases here for each new object to store at runtime. */

    // AppDelegate
    case currentFile
    case languageCode
    case languageCodeDictionary
    case overriddenLanguageCode

    // SceneDelegate
    case topWindow

    // MARK: - Properties

    public var description: String {
        return rawValue.snakeCased
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
