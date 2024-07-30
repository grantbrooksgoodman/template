//
//  DevModeService.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import AlertKit
import CoreArchitecture

public enum DevModeService {
    // MARK: - Properties

    public private(set) static var actions: [DevModeAction] = []

    // MARK: - Action Addition

    public static func addAction(_ action: DevModeAction) {
        actions.removeAll(where: { $0.metadata(isEqual: action) })
        actions.append(action)
    }

    public static func addActions(_ actions: [DevModeAction]) {
        actions.forEach { addAction($0) }
    }

    public static func addStandardActions() {
        addActions(DevModeAction.Standard.available)
    }

    // MARK: - Action Insertion

    public static func insertAction(
        _ action: DevModeAction,
        after precedingAction: DevModeAction
    ) {
        guard let index = actions.firstIndex(where: { $0.metadata(isEqual: precedingAction) }) else { return }
        insertAction(action, at: index + 1)
    }

    public static func insertAction(
        _ action: DevModeAction,
        at index: Int
    ) {
        guard index < actions.count else {
            guard index == actions.count else { return }
            addAction(action)
            return
        }

        guard index > -1 else { return }
        actions.removeAll(where: { $0.metadata(isEqual: action) })
        actions.insert(action, at: index)
    }

    public static func insertActions(
        _ actions: [DevModeAction],
        at index: Int
    ) {
        actions.reversed().forEach { insertAction($0, at: index) }
    }

    public static func insertAction(
        _ action: DevModeAction,
        before succeedingAction: DevModeAction
    ) {
        guard let index = actions.firstIndex(where: { $0.metadata(isEqual: succeedingAction) }) else { return }
        insertAction(action, at: index)
    }

    // MARK: - Action Removal

    public static func removeAction(at index: Int) {
        guard index < actions.count,
              index > -1 else { return }

        actions.remove(at: index)
    }

    public static func removeAction(withTitle: String) {
        guard actions.contains(where: { $0.title == withTitle }) else { return }
        actions.removeAll(where: { $0.title == withTitle })
    }

    // MARK: - Menu Presentation

    public static func presentActionSheet() {
        Task {
            @Dependency(\.uiApplication) var uiApplication: UIApplication
            guard !actions.isEmpty,
                  !(await uiApplication.isPresentingAlertController) else { return }

            var akActions = [AKAction]()
            akActions = actions.map { devModeAction in
                .init(
                    devModeAction.title,
                    style: devModeAction.isDestructive ? .destructive : .default
                ) {
                    devModeAction.perform()
                }
            }

            await AKActionSheet(
                title: "Developer Mode Options",
                actions: akActions
            ).present(translating: [])
        }
    }

    // MARK: - Toggling

    public static func promptToToggle() {
        Task {
            @Dependency(\.build) var build: Build

            guard build.stage != .generalRelease else { return }
            guard !build.developerModeEnabled else {
                let confirmed = await AKConfirmationAlert(
                    title: "Disable Developer Mode",
                    message: "Are you sure you'd like to disable Developer Mode?",
                    confirmButtonTitle: "Disable",
                    confirmButtonStyle: .destructivePreferred
                ).present(translating: [])

                guard confirmed else { return }
                return toggleDeveloperMode(enabled: false)
            }

            let input = await AKTextInputAlert(
                title: "Enable Developer Mode",
                message: "Enter the Developer Mode password to continue.",
                attributes: .init(
                    isSecureTextEntry: true,
                    keyboardType: .numberPad,
                    placeholderText: "••••••"
                ),
                confirmButtonTitle: "Done"
            ).present(translating: [])

            guard let input else { return }
            guard input == build.expirationOverrideCode else {
                return await AKAlert(
                    title: "Enable Developer Mode",
                    message: "The password entered was not correct. Please try again.",
                    actions: [
                        .init("Try Again", style: .preferred) { promptToToggle() },
                        .cancelAction(title: "Cancel"),
                    ]
                ).present(translating: [])
            }

            toggleDeveloperMode(enabled: true)
        }
    }

    // MARK: - Auxiliary

    private static func toggleDeveloperMode(enabled: Bool) {
        @Dependency(\.build) var build: Build
        @Dependency(\.coreKit.hud) var coreHUD: CoreKit.HUD
        @Dependency(\.uiApplication) var uiApplication: UIApplication

        @Persistent(.hidesBuildInfoOverlay) var hidesBuildInfoOverlay: Bool?
        if !enabled,
           let hidesOverlay = hidesBuildInfoOverlay,
           hidesOverlay {
            uiApplication.keyWindow?.firstSubview(for: "BUILD_INFO_OVERLAY_WINDOW")?.isHidden = false
            hidesBuildInfoOverlay = false
        }

        @Persistent(.developerModeEnabled) var developerModeEnabled: Bool?
        developerModeEnabled = enabled

        build.setDeveloperModeEnabled(to: enabled)
        Observables.isDeveloperModeEnabled.value = enabled
        coreHUD.showSuccess(text: "Developer Mode \(enabled ? "Enabled" : "Disabled")")
    }
}
