//
//  CoreConstants.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

public enum CoreConstants {
    // MARK: - CGFloat

    public enum CGFloats {}

    // MARK: - Color

    public enum Colors {}

    // MARK: - String

    public enum Strings {}
}

public extension Observables {
    static let breadcrumbsDidCapture: Observable<Nil> = .init(key: .breadcrumbsDidCapture)
    static let isDeveloperModeEnabled: Observable<Bool> = .init(.isDeveloperModeEnabled, false)
    static let rootViewToast: Observable<Toast?> = .init(.rootViewToast, nil)
    static let rootViewToastAction: Observable<() -> Void> = .init(.rootViewToastAction) {}
    static let themedViewAppearanceChanged: Observable<Nil> = .init(key: .themedViewAppearanceChanged)
}

public extension RuntimeStorage {
    // MARK: - Properties

    static var languageCode: String { getLanguageCode() }
    static var languageCodeDictionary: [String: String]? { getLanguageCodeDictionary() }
    static var presentedViewName: String? { getPresentedViewName() }

    // MARK: - Functions

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

        guard !(fileName.hasSuffix("Controller") || fileName.hasSuffix("Reducer")) else {
            return fileName.replacingOccurrences(of: "Reducer", with: "View").removingOccurrences(of: ["Controller"])
        }

        return fileName
    }
}

public extension StoredItemKeyDomain {
    enum CoreStoredItemKey: String {
        case languageCode
        case languageCodeDictionary
        case overriddenLanguageCode
        case presentedViewName
    }
}

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
