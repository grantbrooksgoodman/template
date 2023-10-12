//
//  CoreConstants.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

// MARK: - RuntimeStorage

public extension RuntimeStorage {
    /* MARK: Properties */

    static var languageCode: String { getLanguageCode() }
    static var languageCodeDictionary: [String: String]? { getLanguageCodeDictionary() }
    static var presentedViewName: String? { getPresentedViewName() }

    /* MARK: Methods */

    private static func getLanguageCode() -> String {
        guard let overridden = retrieve(.overriddenLanguageCode) as? String else { return retrieve(.languageCode) as? String ?? Locale.systemLanguageCode }
        return overridden
    }

    private static func getLanguageCodeDictionary() -> [String: String]? {
        retrieve(.languageCodeDictionary) as? [String: String]
    }

    private static func getPresentedViewName() -> String? {
        guard let path = retrieve(.presentedViewName) as? String else { return nil }

        let slashComponents = path.components(separatedBy: "/")
        guard !slashComponents.isEmpty,
              var fileName = slashComponents.last,
              fileName.hasSuffix(".swift") else { return path }
        fileName = fileName.components(separatedBy: ".swift")[0]

        guard !fileName.hasSuffix("Reducer") else {
            return fileName.replacingOccurrences(of: "Reducer", with: "View")
        }

        return fileName
    }
}

// MARK: - StoredItemKeyDomain

public extension StoredItemKeyDomain {
    enum CoreStoredItemKey: String {
        case languageCode
        case languageCodeDictionary
        case overriddenLanguageCode
        case presentedViewName
    }
}

// MARK: - UserDefaultsKeyDomain

public extension UserDefaultsKeyDomain {
    enum CoreDefaultsKey: String {
        case breadcrumbsCaptureEnabled
        case breadcrumbsCapturesAllViews
        case currentThemeID
        case developerModeEnabled
        case hidesBuildInfoOverlay
        case pendingThemeID
    }
}
