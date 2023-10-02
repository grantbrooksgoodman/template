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
import Redux

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
        actions.forEach { insertAction($0, at: index) }
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
        @Dependency(\.coreKit.ui) var coreUI: CoreKit.UI
        guard !actions.isEmpty,
              !coreUI.isPresentingAlertController else { return }

        var akActions = [AKAction]()
        akActions = actions.map { .init(title: $0.title, style: $0.isDestructive ? .destructive : .default) }

        let actionSheet = AKActionSheet(
            message: "Developer Mode Options",
            actions: akActions,
            shouldTranslate: [.none]
        )

        actionSheet.present { actionID in
            guard let index = akActions.firstIndex(where: { $0.identifier == actionID }),
                  index < actions.count else { return }

            let selectedAkAction = akActions[index]
            let presumedDevModeAction = actions[index]

            let akActionTitle = selectedAkAction.title
            let akActionDestructive = selectedAkAction.style == .destructive

            guard presumedDevModeAction.metadata(isEqual: (akActionTitle, akActionDestructive)) else { return }
            presumedDevModeAction.perform()
        }
    }

    // MARK: - Toggling

    public static func promptToToggle() {
        @Dependency(\.alertKitCore) var akCore: AKCore
        @Dependency(\.build) var build: Build

        guard build.stage != .generalRelease,
              let previousLanguage = RuntimeStorage.languageCode else { return }

        if akCore.languageCodeIsLocked {
            akCore.unlockLanguageCode(andSetTo: "en")
        } else {
            akCore.lockLanguageCode(to: "en")
        }

        guard !build.developerModeEnabled else {
            AKConfirmationAlert(
                title: "Disable Developer Mode",
                message: "Are you sure you'd like to disable Developer Mode?",
                cancelConfirmTitles: (cancel: nil, confirm: "Disable"),
                confirmationStyle: .destructivePreferred,
                shouldTranslate: [.none]
            ).present { didConfirm in
                akCore.unlockLanguageCode(andSetTo: previousLanguage)
                guard didConfirm == 1 else { return }
                toggleDeveloperMode(enabled: false)
            }

            return
        }

        let passwordPrompt = AKTextFieldAlert(
            title: "Enable Developer Mode",
            message: "Enter the Developer Mode password to continue.",
            actions: [AKAction(title: "Done", style: .preferred)],
            textFieldAttributes: [.keyboardType: UIKeyboardType.numberPad,
                                  .placeholderText: "••••••",
                                  .secureTextEntry: true,
                                  .textAlignment: NSTextAlignment.center],
            shouldTranslate: [.none]
        )

        passwordPrompt.presentTextFieldAlert { returnedString, actionID in
            akCore.unlockLanguageCode(andSetTo: previousLanguage)

            guard actionID != -1 else { return }

            guard let returnedString,
                  returnedString == build.expirationOverrideCode else {
                akCore.lockLanguageCode(to: "en")
                AKAlert(
                    title: "Enable Developer Mode",
                    message: "The password entered was not correct. Please try again.",
                    actions: [AKAction(title: "Try Again", style: .preferred)],
                    shouldTranslate: [.none]
                ).present { actionID in
                    akCore.unlockLanguageCode(andSetTo: previousLanguage)
                    guard actionID != -1 else { return }
                    self.promptToToggle()
                }

                return
            }

            toggleDeveloperMode(enabled: true)
        }
    }

    // MARK: - Auxiliary

    private static func toggleDeveloperMode(enabled: Bool) {
        @Dependency(\.build) var build: Build
        @Dependency(\.coreKit.hud) var coreHUD: CoreKit.HUD
        @Dependency(\.userDefaults) var defaults: UserDefaults
        @Dependency(\.uiApplication) var uiApplication: UIApplication

        if !enabled,
           let hidesBuildInfoOverlay = defaults.value(forKey: .core(.hidesBuildInfoOverlay)) as? Bool,
           hidesBuildInfoOverlay {
            uiApplication.keyWindow?.firstSubview(for: "BUILD_INFO_OVERLAY_WINDOW")?.isHidden = false
            defaults.set(false, forKey: .core(.hidesBuildInfoOverlay))
        }

        build.setDeveloperModeEnabled(to: enabled)
        defaults.set(enabled, forKey: .core(.developerModeEnabled))
        Observables.isDeveloperModeEnabled.value = enabled
        coreHUD.showSuccess(text: "Developer Mode \(enabled ? "Enabled" : "Disabled")")
    }
}
