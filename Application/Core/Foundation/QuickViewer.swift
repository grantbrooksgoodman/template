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
import Redux

public final class QuickViewer: NSObject, QLPreviewControllerDataSource {
    // MARK: - Dependencies

    @Dependency(\.coreKit) private var core: CoreKit

    // MARK: - Properties

    private var filePath = ""

    // MARK: - Preview

    public func preview(fileAtPath path: String) {
        let previewController = QLPreviewController()
        previewController.dataSource = self

        filePath = path
        core.ui.present(previewController, embedded: true)
    }

    // MARK: - Protocol Conformance

    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        1
    }

    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let amendedPath = filePath.removingOccurrences(of: ["file:///", "file://", "file:/"])
        return URL(filePath: amendedPath) as QLPreviewItem
    }
}
