//
//  DevModeStandardActions.swift
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

public extension DevModeAction {
    enum Standard {
        // MARK: - Available Actions Getter

        public static var available: [DevModeAction] {
            var availableActions: [DevModeAction] = [
                toggleBuildInfoOverlayAction,
                overrideLanguageCodeAction,
                resetUserDefaultsAction,
                toggleBreadcrumbsAction,
                viewLoggerSessionRecordAction,
                disableDeveloperModeAction,
            ]

            if AppTheme.allCases.count > 1 {
                availableActions.insert(changeThemeAction, at: 0)
            }

            return availableActions
        }

        // MARK: - Standard Actions

        private static var changeThemeAction: DevModeAction {
            func changeTheme() {
                Task {
                    var actions = [AKAction]()
                    actions = AppTheme.allCases.map { appTheme in
                        .init(
                            appTheme.theme.name,
                            isEnabled: appTheme.theme.name != ThemeService.currentTheme.name
                        ) {
                            ThemeService.setTheme(appTheme.theme, checkStyle: false)
                        }
                    }

                    await AKActionSheet(
                        title: "Change Theme",
                        actions: actions
                    ).present(translating: [])
                }
            }

            return .init(title: "Change Theme", perform: changeTheme)
        }

        private static var disableDeveloperModeAction: DevModeAction {
            return .init(
                title: "Disable Developer Mode",
                perform: DevModeService.promptToToggle,
                isDestructive: true
            )
        }

        private static var overrideLanguageCodeAction: DevModeAction {
            @Sendable
            func overrideLanguageCode() {
                Task {
                    @Dependency(\.coreKit) var core: CoreKit

                    guard RuntimeStorage.retrieve(.overriddenLanguageCode) == nil else {
                        let confirmed = await AKConfirmationAlert(
                            title: "Restore Language Code",
                            message: "The language code will be unlocked and restored to the device's default."
                        ).present(translating: [])

                        guard confirmed else { return }
                        RuntimeStorage.remove(.overriddenLanguageCode)
                        core.utils.restoreDeviceLanguageCode()
                        core.hud.showSuccess()
                        return
                    }

                    let input = await AKTextInputAlert(
                        title: "Override Language Code",
                        message: "Enter the two-letter code of the language to apply:",
                        attributes: .init(
                            capitalizationType: .none,
                            correctionType: .no,
                            placeholderText: "en"
                        )
                    ).present(translating: [])

                    guard let input else { return }
                    guard let languageCodes = RuntimeStorage.languageCodeDictionary,
                          languageCodes.keys.contains(input.lowercasedTrimmingWhitespaceAndNewlines) else {
                        let tryAgainAction: AKAction = .init(
                            "Try Again",
                            style: .preferred
                        ) { overrideLanguageCode() }

                        await AKAlert(
                            title: "Override Language Code",
                            message: "The language code entered was invalid. Please try again.",
                            actions: [tryAgainAction, .cancelAction(title: "Cancel")]
                        ).present(translating: [])

                        return
                    }

                    core.utils.setLanguageCode(input, override: true)
                    core.hud.showSuccess()
                }
            }

            return .init(title: "Override/Restore Language Code", perform: overrideLanguageCode)
        }

        private static var resetUserDefaultsAction: DevModeAction {
            func resetUserDefaults() {
                @Dependency(\.coreKit.hud) var coreHUD: CoreKit.HUD
                @Dependency(\.userDefaults) var defaults: UserDefaults

                defaults.reset(keeping: [.core(.breadcrumbsCaptureEnabled),
                                         .core(.breadcrumbsCapturesAllViews),
                                         .core(.currentThemeID),
                                         .core(.developerModeEnabled),
                                         .core(.hidesBuildInfoOverlay)])
                defaults.set(true, forKey: .core(.developerModeEnabled))
                coreHUD.showSuccess(text: "Reset UserDefaults")
            }

            return .init(title: "Reset UserDefaults", perform: resetUserDefaults)
        }

        private static var toggleBreadcrumbsAction: DevModeAction {
            @Dependency(\.breadcrumbs) var breadcrumbs: Breadcrumbs

            func toggleBreadcrumbs() {
                Task {
                    @Dependency(\.coreKit.hud) var coreHUD: CoreKit.HUD

                    @Persistent(.breadcrumbsCaptureEnabled) var breadcrumbsCaptureEnabled: Bool?
                    @Persistent(.breadcrumbsCapturesAllViews) var breadcrumbsCapturesAllViews: Bool?

                    guard !breadcrumbs.isCapturing else {
                        let confirmed = await AKConfirmationAlert(
                            message: "Stop breadcrumbs capture?",
                            confirmButtonStyle: .destructivePreferred
                        ).present(translating: [])

                        guard confirmed else { return }
                        breadcrumbsCaptureEnabled = false

                        if let exception = breadcrumbs.stopCapture() {
                            Logger.log(exception, with: .errorAlert)
                        } else {
                            coreHUD.showSuccess()
                            DevModeService.removeAction(withTitle: "Stop Breadcrumbs Capture")
                            DevModeService.insertAction(toggleBreadcrumbsAction, after: resetUserDefaultsAction)
                        }

                        return
                    }

                    func startCapture(_ uniqueViewsOnly: Bool) {
                        if let exception = breadcrumbs.startCapture(uniqueViewsOnly: uniqueViewsOnly) {
                            Logger.log(exception, with: .errorAlert)
                        } else {
                            coreHUD.showSuccess()
                            DevModeService.removeAction(withTitle: "Start Breadcrumbs Capture")
                            DevModeService.insertAction(toggleBreadcrumbsAction, after: resetUserDefaultsAction)
                        }
                    }

                    let allViewsAction: AKAction = .init("All Views") {
                        breadcrumbsCaptureEnabled = true
                        breadcrumbsCapturesAllViews = true
                        startCapture(false)
                    }

                    let uniqueViewsOnlyAction: AKAction = .init("Unique Views Only", style: .preferred) {
                        breadcrumbsCaptureEnabled = true
                        breadcrumbsCapturesAllViews = false
                        startCapture(true)
                    }

                    await AKAlert(
                        title: "Start Breadcrumbs Capture", // swiftlint:disable:next line_length
                        message: "Starting breadcrumbs capture will periodically take snapshots of the current view and save them to the device's photo library.\n\nSelect the capture granularity to begin.",
                        actions: [
                            allViewsAction,
                            uniqueViewsOnlyAction,
                            .cancelAction(title: "Cancel"),
                        ]
                    ).present(translating: [])
                }
            }

            let command = breadcrumbs.isCapturing ? "Stop" : "Start"
            return .init(title: "\(command) Breadcrumbs Capture", perform: toggleBreadcrumbs, isDestructive: command == "Stop")
        }

        private static var toggleBuildInfoOverlayAction: DevModeAction {
            func toggleBuildInfoOverlay() {
                @Dependency(\.uiApplication) var uiApplication: UIApplication

                guard let overlayWindow = uiApplication.keyWindow?.firstSubview(for: "BUILD_INFO_OVERLAY_WINDOW") as? UIWindow else { return }

                overlayWindow.isHidden.toggle()
                @Persistent(.hidesBuildInfoOverlay) var hidesBuildInfoOverlay: Bool?
                hidesBuildInfoOverlay = overlayWindow.isHidden
            }

            return .init(title: "Show/Hide Build Info Overlay", perform: toggleBuildInfoOverlay)
        }

        private static var viewLoggerSessionRecordAction: DevModeAction {
            func viewLoggerSessionRecord() {
                @Dependency(\.quickViewer) var quickViewer: QuickViewer
                if let exception = quickViewer.preview(
                    filesAtPaths: [Logger.sessionRecordFilePath.path()],
                    embedded: true
                ) {
                    Logger.log(exception, with: .toast())
                }
            }

            return .init(title: "View Logger Session Record", perform: viewLoggerSessionRecord)
        }
    }
}
