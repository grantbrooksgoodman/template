//
//  QuickViewer.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import QuickLook

/* 3rd-party */
import CoreArchitecture

public final class QuickViewer: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    // MARK: - Types

    private final class PreviewItem: NSObject, QLPreviewItem {
        // MARK: - Properties

        public var previewItemTitle: String?
        public var previewItemURL: URL?

        // MARK: - Init

        public init(
            title: String? = nil,
            url: URL? = nil
        ) {
            previewItemTitle = title
            previewItemURL = url
        }
    }

    // MARK: - Properties

    private var filePaths = [String]()
    private var previewItemTitle: String?
    private var _onDismiss: (() -> Void)?

    // MARK: - Preview

    @discardableResult
    public func preview(
        filesAtPaths paths: [String],
        startingIndex: Int = 0,
        title: String? = nil,
        embedded: Bool = false
    ) -> Exception? {
        @Dependency(\.coreKit.ui) var coreUI: CoreKit.UI

        let paths = paths.filter { !$0.isEmpty }
        guard !paths.isEmpty else {
            return .init(
                "No file to preview.",
                metadata: [self, #file, #function, #line]
            )
        }

        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.delegate = self

        if paths.count > startingIndex {
            previewController.currentPreviewItemIndex = startingIndex
        }

        filePaths = paths
        previewItemTitle = title
        coreUI.present(previewController, embedded: embedded)
        return nil
    }

    // MARK: - On Dismiss

    public func onDismiss(_ perform: @escaping () -> Void) {
        _onDismiss = perform
    }

    // MARK: - QLPreviewControllerDataSource Conformance

    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        filePaths.count
    }

    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let filePath = filePaths.itemAt(index) else { return PreviewItem() }
        let amendedPath = filePath.removingOccurrences(of: ["file:///", "file://", "file:/"])
        return PreviewItem(title: previewItemTitle, url: URL(filePath: amendedPath))
    }

    // MARK: - QLPreviewControllerDelegate Conformance

    public func previewControllerDidDismiss(_ controller: QLPreviewController) {
        _onDismiss?()
        _onDismiss = nil
    }
}
