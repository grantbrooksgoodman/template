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

public struct BuildInfoOverlayViewService {
    // MARK: - Dependencies

    @Dependency(\.build) private var build: Build
    @Dependency(\.currentCalendar) private var calendar: Calendar
    @Dependency(\.reportDelegate) private var reportDelegate: ReportDelegate

    // MARK: - Properties

    private var buildInfoButtonMessage: (string: String?, attributedString: NSAttributedString?) { getBuildInfoButtonMessage() }

    // MARK: - Build Info Button Tapped

    public func buildInfoButtonTapped() {
        Task { @MainActor in
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()

            let viewBuildInformationAction: AKAction = .init("View Build Information") {
                self.viewBuildInformationButtonTapped()
            }

            let developerModeButtonTitle = "\(build.developerModeEnabled ? "Disable" : "Enable") Developer Mode"
            let developerModeAction: AKAction = .init(
                developerModeButtonTitle,
                style: developerModeButtonTitle.hasPrefix("Enable") ? .default : .destructive
            ) {
                DevModeService.promptToToggle()
            }

            let alert = AKAlert(
                title: RuntimeStorage.languageCode == "en" ? "Project \(build.codeName)" : "Project ⌘\(build.codeName)⌘",
                message: buildInfoButtonMessage.string ?? "",
                actions: [
                    viewBuildInformationAction,
                    developerModeAction,
                    .cancelAction(title: Localized(.dismiss).wrappedValue),
                ]
            )

            if let attributedMessage = buildInfoButtonMessage.attributedString {
                alert.setAttributedMessage(attributedMessage)
            }

            await alert.present(translating: [.message, .title])
        }
    }

    // MARK: - Send Feedback Button Tapped

    public func sendFeedbackButtonTapped() {
        Task { @MainActor in
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()

            await AKActionSheet(
                title: "File a Report",
                actions: [
                    .init("Send Feedback") { reportDelegate.sendFeedback() },
                    .init("Report Bug") { reportDelegate.reportBug() },
                ]
            ).present()
        }
    }

    // MARK: - Auxiliary

    private func getBuildInfoButtonMessage() -> (String?, NSAttributedString?) {
        let stageString = build.stage.rawValue
        let expiryString = build.timebombActive ? "\n\n\(build.expiryInfoString)" : ""

        var message = "This is a\(stageString == "alpha" ? "n" : "") \(stageString) version of ⌘project code name \(build.codeName)⌘.\(expiryString)"
        if build.appStoreReleaseVersion > 0 {
            message = "This is a pre-release update to ⌘\(build.finalName)⌘. \(build.expiryInfoString)"
        }

        // swiftlint:disable:next line_length
        message += "\n\nAll features presented here are subject to change, and any new or previously undisclosed information presented within this software is to remain strictly confidential.\n\nRedistribution of this software by unauthorized parties in any way, shape, or form is strictly prohibited.\n\nBy continuing your use of this software, you acknowledge your agreement to the above terms.\n\nAll content herein, unless otherwise stated, is copyright ⌘© \(calendar.dateComponents([.year], from: .now).year!) NEOTechnica Corporation⌘. All rights reserved."

        guard RuntimeStorage.languageCode == "en" else { return (message, nil) }

        var dateComponent: String?
        let preExpiryComponents = build.expiryInfoString.components(separatedBy: "expire on")
        let postExpiryComponents = build.expiryInfoString.components(separatedBy: "ended on")

        if preExpiryComponents.count > 1 {
            dateComponent = preExpiryComponents[1].components(separatedBy: ".").first
        } else if postExpiryComponents.count > 1 {
            dateComponent = postExpiryComponents[1].components(separatedBy: ".").first
        }

        guard let dateComponent else { return (message, nil) }
        return (nil, message.sanitized.attributed(
            mainAttributes: [.font: UIFont.systemFont(ofSize: 13)],
            alternateAttributes: [.foregroundColor: UIColor.red],
            alternateAttributeRange: [dateComponent.sanitized]
        ))
    }

    private func viewBuildInformationButtonTapped() {
        let buildStageString = "Build Stage\n\(build.stage.rawValue.capitalized)"
        let bundleVersionString = "Bundle Version\n\(build.bundleVersion) (\(String(build.buildNumber)))"
        let projectIDString = "Project ID\n\(build.projectID)"
        let revisionString = "Revision\n\(build.bundleRevision) (\(String(build.revisionBuildNumber)))"
        let skuString = "SKU\n\(build.buildSKU)"

        let message = [
            buildStageString,
            bundleVersionString,
            projectIDString,
            revisionString,
            skuString,
        ].joined(separator: "\n\n")

        let attributedMessage = message.attributed(
            mainAttributes: [.font: UIFont.systemFont(ofSize: 13)],
            alternateAttributes: [.font: UIFont.boldSystemFont(ofSize: 14)],
            alternateAttributeRange: [
                "Build Number",
                "Build Stage",
                "Bundle Version",
                "Project ID",
                "Revision",
                "SKU",
            ]
        )

        let alert = AKAlert(message: "")
        alert.setAttributedMessage(attributedMessage)
        Task { await alert.present(translating: []) }
    }
}
