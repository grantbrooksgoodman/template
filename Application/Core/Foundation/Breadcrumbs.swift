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

public class Breadcrumbs {
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
        if let viewName {
            fileName = "\(build.codeName)_\(viewName) @ \(timeString).png"
        } else {
            let fileNamePrefix = "\(build.codeName)_\(String(build.buildNumber))"
            let fileNameSuffix = "\(build.stage.shortString) @ \(timeString).png"
            fileName = fileNamePrefix + fileNameSuffix
        }

        return documents.appending(path: fileName)
    }

    private var viewName: String? {
        guard let path = RuntimeStorage.currentFile else { return nil }

        let slashComponents = path.components(separatedBy: "/")
        guard !slashComponents.isEmpty,
              var fileName = slashComponents.last,
              fileName.hasSuffix(".swift") else { return nil }
        fileName = fileName.components(separatedBy: ".swift")[0]

        if fileName.hasSuffix("Reducer") {
            fileName = fileName.replacingOccurrences(of: "Reducer", with: "View")
        }

        return fileName
    }

    // MARK: - Capture

    @discardableResult
    func startCapture(
        saveToPhotos: Bool = true,
        uniqueViewsOnly doesExclude: Bool = true
    ) -> Exception? {
        guard !isCapturing else {
            return .init("Breadcrumbs capture is already running.", metadata: [#file, #function, #line])
        }

        savesToPhotos = saveToPhotos
        uniqueViewsOnly = doesExclude
        isCapturing = true

        func continuallyCapture() {
            @Dependency(\.coreKit) var core: CoreKit
            guard isCapturing else { return }
            capture()
            core.gcd.after(seconds: 10) { continuallyCapture() }
        }

        continuallyCapture()
        return nil
    }

    @discardableResult
    func stopCapture() -> Exception? {
        guard isCapturing else {
            return .init("Breadcrumbs capture is not running.", metadata: [#file, #function, #line])
        }

        isCapturing = false
        return nil
    }

    // MARK: - Auxiliary

    private func capture() {
        func saveImage() {
            @Dependency(\.observableRegistry) var registry: ObservableRegistry
            @Dependency(\.uiApplication) var uiApplication: UIApplication

            guard let image = uiApplication.snapshot,
                  let pngData = image.pngData() else { return }

            try? pngData.write(to: filePath)

            if savesToPhotos {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }

            registry.breadcrumbsDidCapture.trigger()
        }

        guard Int.random(in: 1 ... 1_000_000) % 3 == 0 else { return }

        if uniqueViewsOnly {
            guard let viewName,
                  !fileHistory.contains(viewName) else { return }
            fileHistory.append(viewName)
            saveImage()
        } else {
            saveImage()
        }
    }
}

/* MARK: Date Formatter Dependency */

private enum BreadcrumbsDateFormatterDependency: DependencyKey {
    public static func resolve(_ dependencies: DependencyValues) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH.mm.ss"
        return formatter
    }
}

private extension DependencyValues {
    var breadcrumbsDateFormatter: DateFormatter {
        get {
            self[BreadcrumbsDateFormatterDependency.self]
        }
        set {
            self[BreadcrumbsDateFormatterDependency.self] = newValue
        }
    }
}
