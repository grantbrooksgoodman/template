//
//  Breadcrumbs.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import Redux

public final class Breadcrumbs {
    // MARK: - Properties

    // Array
    private var fileHistory = [String]()

    // Bool
    public private(set) var isCapturing = false

    private var uniqueViewsOnly = true
    private var savesToPhotos = true

    // MARK: - Computed Properties

    private var filePath: URL {
        @Dependency(\.build) var build: Build
        @Dependency(\.breadcrumbsDateFormatter) var dateFormatter: DateFormatter
        @Dependency(\.fileManager) var fileManager: FileManager

        let documents = fileManager.documentsDirectoryURL
        let timeString = dateFormatter.string(from: Date())

        var fileName: String!
        if let viewName = RuntimeStorage.presentedViewName {
            fileName = "\(build.codeName)_\(viewName) @ \(timeString).png"
        } else {
            let fileNamePrefix = "\(build.codeName)_\(String(build.buildNumber))"
            let fileNameSuffix = "\(build.stage.shortString) @ \(timeString).png"
            fileName = fileNamePrefix + fileNameSuffix
        }

        return documents.appending(path: fileName)
    }

    // MARK: - Capture

    @discardableResult
    public func startCapture(
        saveToPhotos: Bool = true,
        uniqueViewsOnly doesExclude: Bool = true
    ) -> Exception? {
        guard !isCapturing else {
            return .init("Breadcrumbs capture is already running.", metadata: [self, #file, #function, #line])
        }

        savesToPhotos = saveToPhotos
        uniqueViewsOnly = doesExclude
        isCapturing = true

        func continuallyCapture() {
            @Dependency(\.coreKit.gcd) var coreGCD: CoreKit.GCD
            guard isCapturing else { return }
            capture()
            coreGCD.after(.seconds(10)) { continuallyCapture() }
        }

        continuallyCapture()
        return nil
    }

    @discardableResult
    public func stopCapture() -> Exception? {
        guard isCapturing else {
            return .init("Breadcrumbs capture is not running.", metadata: [self, #file, #function, #line])
        }

        isCapturing = false
        return nil
    }

    // MARK: - Auxiliary

    private func capture() {
        func saveImage() {
            @Dependency(\.uiApplication) var uiApplication: UIApplication

            guard let image = uiApplication.snapshot,
                  let pngData = image.pngData() else { return }

            try? pngData.write(to: filePath)

            defer { Observables.breadcrumbsDidCapture.trigger() }
            guard savesToPhotos else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }

        guard Int.random(in: 1 ... 1_000_000) % 3 == 0 else { return }

        if uniqueViewsOnly {
            guard let viewName = RuntimeStorage.presentedViewName,
                  !fileHistory.contains(viewName) else { return }
            fileHistory.append(viewName)
            saveImage()
        } else {
            saveImage()
        }
    }
}

/* MARK: DateFormatter Dependency */

private enum BreadcrumbsDateFormatterDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH.mm.ss"
        return formatter
    }
}

private extension DependencyValues {
    var breadcrumbsDateFormatter: DateFormatter {
        get { self[BreadcrumbsDateFormatterDependency.self] }
        set { self[BreadcrumbsDateFormatterDependency.self] = newValue }
    }
}
