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
import Redux

public extension DevModeAction {
    enum Standard {
        // MARK: - Available Actions Getter

        public static var available: [DevModeAction] {
            var availableActions: [DevModeAction] = [.Standard.toggleBuildInfoOverlayAction,
                                                     .Standard.overrideLanguageCodeAction,
                                                     .Standard.resetUserDefaultsAction,
                                                     .Standard.toggleBreadcrumbsAction,
                                                     .Standard.disableDeveloperModeAction]
            guard AppTheme.allCases.count > 1 else { return availableActions }
            availableActions.insert(.Standard.changeThemeAction, at: 0)
            return availableActions
        }

        // MARK: - Standard Actions

        private static var changeThemeAction: DevModeAction {
            func changeTheme() {
                var actions = [AKAction]()
                actions = AppTheme.allCases.map { .init(
                    title: $0.theme.name,
                    style: .default,
                    isEnabled: $0.theme.name != ThemeService.currentTheme.name
                ) }

                AKActionSheet(
                    message: "Change Theme",
                    actions: actions,
                    shouldTranslate: [.none]
                ).present { actionID in
                    guard actionID != -1,
                          let themeName = actions.first(where: { $0.identifier == actionID })?.title,
                          let correspondingCase = AppTheme.allCases.first(where: { $0.theme.name == themeName }) else { return }

                    ThemeService.setTheme(correspondingCase.theme, checkStyle: false)
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
            @Dependency(\.alertKitCore) var akCore: AKCore

            func setLanguageCode(_ code: String) {
                guard akCore.languageCodeIsLocked else {
                    akCore.lockLanguageCode(to: code)
                    return
                }

                akCore.unlockLanguageCode(andSetTo: code)
            }

            func overrideLanguageCode() {
                @Dependency(\.coreKit.hud) var coreHUD: CoreKit.HUD

                setLanguageCode("en")
                let languageCodePrompt = AKTextFieldAlert(
                    title: "Override Language Code",
                    message: "Enter the two-letter code of the language to apply:",
                    actions: [AKAction(title: "Done", style: .preferred)],
                    textFieldAttributes: [.placeholderText: "en",
                                          .capitalizationType: UITextAutocapitalizationType.none,
                                          .correctionType: UITextAutocorrectionType.no,
                                          .textAlignment: NSTextAlignment.center],
                    shouldTranslate: [.none],
                    networkDependent: true
                )

                languageCodePrompt.presentTextFieldAlert { inputString, actionID in
                    akCore.unlockLanguageCode()
                    guard actionID != -1 else { return }
                    guard let inputString,
                          inputString.lowercasedTrimmingWhitespace != "" else {
                        setLanguageCode("en")
                        AKConfirmationAlert(
                            title: "Override Language Code",
                            message: "No input was entered.\n\nWould you like to try again?",
                            cancelConfirmTitles: (cancel: nil, confirm: "Try Again"),
                            confirmationStyle: .preferred,
                            shouldTranslate: [.none]
                        ).present { didConfirm in
                            akCore.unlockLanguageCode()
                            guard didConfirm == 1 else { return }
                            overrideLanguageCode()
                        }

                        return
                    }

                    guard let languageCodes = RuntimeStorage.languageCodeDictionary,
                          languageCodes.keys.contains(inputString.lowercasedTrimmingWhitespace) else {
                        setLanguageCode("en")
                        AKConfirmationAlert(
                            title: "Override Language Code",
                            message: "The language code entered was invalid. Please try again.",
                            cancelConfirmTitles: (cancel: nil, confirm: "Try Again"),
                            confirmationStyle: .preferred,
                            shouldTranslate: [.none]
                        ).present { didConfirm in
                            akCore.unlockLanguageCode()
                            guard didConfirm == 1 else { return }
                            overrideLanguageCode()
                        }

                        return
                    }

                    RuntimeStorage.store(inputString, as: .core(.languageCode))
                    RuntimeStorage.store(inputString, as: .core(.overriddenLanguageCode))

                    setLanguageCode(inputString)
                    coreHUD.showSuccess()
                }
            }

            return .init(title: "Override Language Code", perform: overrideLanguageCode)
        }

        private static var resetUserDefaultsAction: DevModeAction {
            func resetUserDefaults() {
                @Dependency(\.coreKit.hud) var coreHUD: CoreKit.HUD
                @Dependency(\.userDefaults) var defaults: UserDefaults

                defaults.reset(keeping: [.core(.breadcrumbsCaptureEnabled),
                                         .core(.breadcrumbsCapturesAllViews),
                                         .core(.currentTheme),
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
                @Dependency(\.coreKit.hud) var coreHUD: CoreKit.HUD
                @Dependency(\.userDefaults) var defaults: UserDefaults

                guard !breadcrumbs.isCapturing else {
                    AKConfirmationAlert(
                        message: "Stop breadcrumbs capture?",
                        confirmationStyle: .destructivePreferred,
                        shouldTranslate: [.none]
                    ).present { didConfirm in
                        guard didConfirm == 1 else { return }
                        defaults.set(false, forKey: .core(.breadcrumbsCaptureEnabled))

                        if let exception = breadcrumbs.stopCapture() {
                            Logger.log(exception, with: .errorAlert)
                        } else {
                            coreHUD.showSuccess()
                            DevModeService.removeAction(withTitle: "Stop Breadcrumbs Capture")
                            DevModeService.insertAction(.Standard.toggleBreadcrumbsAction, at: DevModeService.actions.count - 1)
                        }
                    }

                    return
                }

                // swiftlint:disable line_length
                let alert = AKAlert(
                    title: "Start Breadcrumbs Capture",
                    message: "Starting breadcrumbs capture will periodically take snapshots of the current view and save them to the device's photo library.\n\nSelect the capture granularity to begin.",
                    actions: [.init(title: "All Views", style: .default),
                              .init(title: "Unique Views Only", style: .preferred)],
                    shouldTranslate: [.none]
                )
                // swiftlint:enable line_length

                alert.present { actionID in
                    guard actionID != -1 else { return }

                    defaults.set(true, forKey: .core(.breadcrumbsCaptureEnabled))

                    var uniqueViewsOnly = true
                    if actionID == alert.actions.first(where: { $0.title == "All Views" })?.identifier {
                        defaults.set(true, forKey: .core(.breadcrumbsCapturesAllViews))
                        uniqueViewsOnly = false
                    } else {
                        defaults.set(false, forKey: .core(.breadcrumbsCapturesAllViews))
                    }

                    if let exception = breadcrumbs.startCapture(uniqueViewsOnly: uniqueViewsOnly) {
                        Logger.log(exception, with: .errorAlert)
                    } else {
                        coreHUD.showSuccess()
                        DevModeService.removeAction(withTitle: "Start Breadcrumbs Capture")
                        DevModeService.insertAction(.Standard.toggleBreadcrumbsAction, at: DevModeService.actions.count - 1)
                    }
                }
            }

            let command = breadcrumbs.isCapturing ? "Stop" : "Start"
            return .init(title: "\(command) Breadcrumbs Capture", perform: toggleBreadcrumbs, isDestructive: command == "Stop")
        }

        private static var toggleBuildInfoOverlayAction: DevModeAction {
            func toggleBuildInfoOverlay() {
                @Dependency(\.userDefaults) var defaults: UserDefaults

                guard let overlayWindow = RuntimeStorage.topWindow?.firstSubview(for: "BUILD_INFO_OVERLAY_WINDOW") as? UIWindow else { return }
                guard let currentValue = defaults.value(forKey: .core(.hidesBuildInfoOverlay)) as? Bool else {
                    overlayWindow.isHidden.toggle()
                    defaults.set(overlayWindow.isHidden, forKey: .core(.hidesBuildInfoOverlay))
                    return
                }

                let toggledValue = !currentValue
                overlayWindow.isHidden = toggledValue
                defaults.set(toggledValue, forKey: .core(.hidesBuildInfoOverlay))
            }

            return .init(title: "Show/Hide Build Info Overlay", perform: toggleBuildInfoOverlay)
        }
    }
}
