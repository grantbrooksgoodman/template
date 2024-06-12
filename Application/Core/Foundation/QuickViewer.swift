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

public final class QuickViewer: NSObject, QLPreviewControllerDataSource {
    // MARK: - Properties

    private var filePath = ""

    // MARK: - Preview

    public func preview(fileAtPath path: String) {
        @Dependency(\.coreKit.ui) var coreUI: CoreKit.UI

        let previewController = QLPreviewController()
        previewController.dataSource = self

        filePath = path
        coreUI.present(previewController, embedded: true)
    }

    // MARK: - QLPreviewControllerDataSource Conformance

    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        1
    }

    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let amendedPath = filePath.removingOccurrences(of: ["file:///", "file://", "file:/"])
        return URL(filePath: amendedPath) as QLPreviewItem
    }
}
