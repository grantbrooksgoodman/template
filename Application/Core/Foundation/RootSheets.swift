//
//  RootSheets.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public enum RootSheets {
    // MARK: - Present

    public static func present(_ sheet: RootSheet) {
        Task { @MainActor in
            Observables.rootViewSheet.value = sheet.view
        }
    }

    // MARK: - Dismiss

    public static func dismiss() {
        Task { @MainActor in
            Observables.rootViewSheet.value = nil
        }
    }
}
