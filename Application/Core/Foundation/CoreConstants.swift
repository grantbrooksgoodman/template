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

    static var languageCode: String? { getLanguageCode() }
    static var languageCodeDictionary: [String: String]? { getLanguageCodeDictionary() }
    static var presentedViewName: String? { getPresentedViewName() }
    static var topWindow: UIWindow? { getTopWindow() }

    /* MARK: Methods */

    private static func getLanguageCode() -> String? {
        guard let overridden = retrieve(.core(.overriddenLanguageCode)) as? String else { return retrieve(.core(.languageCode)) as? String }
        return overridden
    }

    private static func getLanguageCodeDictionary() -> [String: String]? {
        retrieve(.core(.languageCodeDictionary)) as? [String: String]
    }

    private static func getPresentedViewName() -> String? {
        guard let path = retrieve(.core(.presentedViewName)) as? String else { return nil }

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

    private static func getTopWindow() -> UIWindow? {
        retrieve(.core(.topWindow)) as? UIWindow
    }
}

// MARK: - StoredItemDomain

public extension StoredItemDomain {
    enum CoreStoredItem: String {
        case languageCode
        case languageCodeDictionary
        case overriddenLanguageCode
        case presentedViewName
        case topWindow
    }
}

// MARK: - UserDefaultsKeyDomain

public extension UserDefaultsKeyDomain {
    enum CoreDefaultsKey: String {
        case breadcrumbsCaptureEnabled
        case breadcrumbsCapturesAllViews
        case currentTheme
        case developerModeEnabled
        case hidesBuildInfoOverlay
        case pendingThemeName
    }
}
