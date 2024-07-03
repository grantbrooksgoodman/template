//
//  BuildInfoOverlayViewService.swift
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
import Translator

public final class BuildInfoOverlayViewService {
    // MARK: - Dependencies

    @Dependency(\.alertKitCore) private var akCore: AKCore
    @Dependency(\.build) private var build: Build
    @Dependency(\.currentCalendar) private var calendar: Calendar
    @Dependency(\.coreKit.ui) private var coreUI: CoreKit.UI
    @Dependency(\.uiApplication) private var uiApplication: UIApplication

    // MARK: - Properties

    private var willPresentDisclaimerAlert = false

    // MARK: - Build Information Alert

    private func presentBuildInformationAlert() {
        // swiftlint:disable:next line_length
        let message = "Build Number\n\(String(build.buildNumber))\n\nBuild Stage\n\(build.stage.rawValue.capitalized(with: nil))\n\nBundle Version\n\(build.bundleVersion)\n\nProject ID\n\(build.projectID)\n\nSKU\n\(build.buildSKU)"

        let alertController = UIAlertController(
            title: "",
            message: "",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(
            title: Localized(.dismiss).wrappedValue,
            style: .cancel,
            handler: nil
        ))

        let mainAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13)]
        let alternateAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 14)]

        let attributed = message.attributed(
            mainAttributes: mainAttributes,
            alternateAttributes: alternateAttributes,
            alternateAttributeRange: ["Build Number",
                                      "Build Stage",
                                      "Bundle Version",
                                      "Project ID",
                                      "SKU"]
        )

        alertController.setValue(attributed, forKey: "attributedMessage")
        coreUI.present(alertController)
    }

    // MARK: - Disclaimer Alert

    public func buildInfoButtonTapped() {
        guard !uiApplication.isPresentingAlertController,
              !willPresentDisclaimerAlert else { return }
        willPresentDisclaimerAlert = true

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        let typeString = build.stage.rawValue
        let expiryString = build.timebombActive ? "\n\n\(build.expiryInfoString)" : ""

        var messageToDisplay = "This is a\(typeString == "alpha" ? "n" : "") \(typeString) version of ⌘project code name \(build.codeName)⌘.\(expiryString)"

        if build.appStoreReleaseVersion > 0 {
            messageToDisplay = "This is a pre-release update to ⌘\(build.finalName)⌘. \(build.expiryInfoString)"
        }

        // swiftlint:disable:next line_length
        messageToDisplay += "\n\nAll features presented here are subject to change, and any new or previously undisclosed information presented within this software is to remain strictly confidential.\n\nRedistribution of this software by unauthorized parties in any way, shape, or form is strictly prohibited.\n\nBy continuing your use of this software, you acknowledge your agreement to the above terms.\n\nAll content herein, unless otherwise stated, is copyright ⌘© \(calendar.dateComponents([.year], from: Date()).year!) NEOTechnica Corporation⌘. All rights reserved."

        let projectTitle = "Project ⌘\(build.codeName)⌘"
        let viewBuildInformationString = "View Build Information"

        let enableOrDisable = build.developerModeEnabled ? "Disable" : "Enable"
        let developerModeString = "\(enableOrDisable) Developer Mode"

        akCore.translationDelegate().getTranslations(
            for: [
                .init(messageToDisplay),
                .init(projectTitle),
                .init(viewBuildInformationString),
            ],
            languagePair: .init(
                from: Translator.LanguagePair.system.from,
                to: Translator.LanguagePair.system.to
            ),
            requiresHUD: nil,
            using: nil,
            fetchFromArchive: true
        ) { translations, errorDescriptors in
            guard let translations else {
                let exception = errorDescriptors?.reduce(into: [Exception]()) { partialResult, keyPair in
                    partialResult.append(.init(keyPair.key, metadata: [self, #file, #function, #line]))
                }.compiledException
                self.willPresentDisclaimerAlert = false
                Logger.log(exception ?? .init(metadata: [self, #file, #function, #line]))
                return
            }

            let controllerTitle = translations.first(where: { $0.input.value() == projectTitle })?.output ?? projectTitle
            let controllerMessage = translations.first(where: { $0.input.value() == messageToDisplay })?.output ?? messageToDisplay
            let alertController = UIAlertController(
                title: controllerTitle.sanitized,
                message: controllerMessage.sanitized,
                preferredStyle: .alert
            )

            // swiftlint:disable:next line_length
            let viewBuildInformationActionTitle = translations.first(where: { $0.input.value() == viewBuildInformationString })?.output ?? viewBuildInformationString
            let viewBuildInformationAction = UIAlertAction(
                title: viewBuildInformationActionTitle,
                style: .default
            ) { _ in
                self.willPresentDisclaimerAlert = false
                self.presentBuildInformationAlert()
            }

            let developerModeAction = UIAlertAction(
                title: developerModeString,
                style: enableOrDisable == "Enable" ? .default : .destructive
            ) { _ in
                self.willPresentDisclaimerAlert = false
                DevModeService.promptToToggle()
            }

            let dismissAction = UIAlertAction(title: Localized(.dismiss).wrappedValue, style: .cancel) { _ in
                self.willPresentDisclaimerAlert = false
            }

            alertController.addAction(viewBuildInformationAction)
            alertController.addAction(developerModeAction)
            alertController.addAction(dismissAction)

            guard self.build.timebombActive else {
                alertController.message = translations.first(where: { $0.input.value() == messageToDisplay })?.output.sanitized ?? messageToDisplay.sanitized
                self.willPresentDisclaimerAlert = false
                self.coreUI.present(alertController)

                return
            }

            let mainAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13)]
            let alternateAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red]

            var dateComponent: String!
            let preExpiryComponents = self.build.expiryInfoString.components(separatedBy: "expire on")
            let postExpiryComponents = self.build.expiryInfoString.components(separatedBy: "ended on")

            if preExpiryComponents.count > 1 {
                dateComponent = preExpiryComponents[1].components(separatedBy: ".")[0]
            } else if postExpiryComponents.count > 1 {
                dateComponent = postExpiryComponents[1].components(separatedBy: ".")[0]
            }

            let message = translations.first(where: { $0.input.value() == messageToDisplay })?.output.sanitized ?? messageToDisplay.sanitized
            let attributed = message.attributed(
                mainAttributes: mainAttributes,
                alternateAttributes: alternateAttributes,
                alternateAttributeRange: [dateComponent]
            )
            alertController.setValue(attributed, forKey: "attributedMessage")

            self.willPresentDisclaimerAlert = false
            self.coreUI.present(alertController)
        }
    }

    // MARK: - Send Feedback Action Sheet

    public func sendFeedbackButtonTapped() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        let sendFeedbackAction = AKAction(title: "Send Feedback", style: .default)
        let reportBugAction = AKAction(title: "Report a Bug", style: .default)

        let actionSheet = AKActionSheet(
            message: "File a Report",
            actions: [sendFeedbackAction, reportBugAction],
            networkDependent: true
        )

        actionSheet.present { actionID in
            guard actionID != -1 else { return }

            if actionID == sendFeedbackAction.identifier {
                self.akCore.reportDelegate().fileReport(
                    forBug: false,
                    body: "Any general feedback is appreciated in the appropriate section.",
                    prompt: "General Feedback",
                    metadata: [self,
                               RuntimeStorage.presentedViewName ?? #file,
                               #function,
                               #line]
                )
            } else if actionID == reportBugAction.identifier {
                self.akCore.reportDelegate().fileReport(
                    forBug: true,
                    body: "In the appropriate section, please describe the error encountered and the steps to reproduce it.",
                    prompt: "Description/Steps to Reproduce",
                    metadata: [self,
                               RuntimeStorage.presentedViewName ?? #file,
                               #function,
                               #line]
                )
            }
        }
    }
}
