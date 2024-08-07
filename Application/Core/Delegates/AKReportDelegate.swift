//
//  AKReportDelegate.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import MessageUI

/* 3rd-party */
import AlertKit
import CoreArchitecture

public struct ReportDelegate: AlertKit.ReportDelegate {
    // MARK: - Dependencies

    @Dependency(\.alertKitConfig) private var alertKitConfig: AlertKit.Config
    @Dependency(\.build) private var build: Build
    @Dependency(\.coreKit) private var core: CoreKit
    @Dependency(\.reportDelegateDateFormatter) private var dateFormatter: DateFormatter
    @Dependency(\.fileManager) private var fileManager: FileManager
    @Dependency(\.jsonEncoder) private var jsonEncoder: JSONEncoder
    @Dependency(\.mailComposer) private var mailComposer: MailComposer

    // MARK: - Properties

    public static let shared = ReportDelegate()

    // MARK: - Computed Properties

    private var bundleVersionString: String {
        "\(build.stage == .generalRelease ? build.finalName : build.codeName) (\(build.bundleVersion))"
    }

    private var loggerSessionRecordAttachment: MailComposer.AttachmentData? {
        let loggerSessionRecordFilePathString = Logger.sessionRecordFilePath.path()

        guard let loggerSessionRecordData = fileManager.contents(atPath: loggerSessionRecordFilePathString),
              let loggerSessionRecordFileName = loggerSessionRecordFilePathString
              .components(separatedBy: "/")
              .last?
              .components(separatedBy: ".")
              .first else { return nil }

        return .init(
            loggerSessionRecordData,
            fileName: "logger_session_\(loggerSessionRecordFileName).txt",
            mimeType: "text/plain"
        )
    }

    // MARK: - Init

    private init() {}

    // MARK: - AlertKit.ReportDelegate Conformance

    public func fileReport(_ error: any AlertKit.Errorable) {
        Task {
            await composeMessage(
                subject: "\(bundleVersionString) Error Report",
                body: nil,
                prompt: nil,
                error: error
            )
        }
    }

    // MARK: - Report Bug

    public func reportBug() {
        Task {
            await composeMessage(
                subject: "\(bundleVersionString) Bug Report",
                body: "In the appropriate section, please describe the error encountered and the steps to reproduce it.",
                prompt: "Description/Steps to Reproduce",
                error: nil
            )
        }
    }

    // MARK: - Send Feedback

    public func sendFeedback() {
        Task {
            await composeMessage(
                subject: "\(bundleVersionString) Feedback Report",
                body: "Any general feedback is appreciated in the appropriate section.",
                prompt: "General Feedback",
                error: nil
            )
        }
    }

    // MARK: - Auxiliary

    @MainActor
    private func composeMessage(
        subject: String,
        body: String?,
        prompt: String?,
        error: (any AlertKit.Errorable)?
    ) async {
        func compose(body: String?, prompt: String?) {
            var bodyTuple: (String, Bool)?

            if let body,
               let prompt {
                var bodyHTML = "<i>\(body.split(separator: ".")[0]).</i><p></p><b>\(prompt):</b><p></p>"
                if body.split(separator: ".").count > 1 {
                    bodyHTML = "<i>\(body.split(separator: ".")[0]).<p></p>\(body.split(separator: ".")[1]).</i><p></p>"
                }
                bodyTuple = (bodyHTML, true)
            }

            var attachments: [MailComposer.AttachmentData] = []
            if let loggerSessionRecordAttachment {
                attachments.append(loggerSessionRecordAttachment)
            }

            if let reportMetadataAttachment = reportMetadataAttachment(error) {
                attachments.append(reportMetadataAttachment)
            }

            mailComposer.compose(
                subject: subject,
                body: bodyTuple,
                recipients: ["me@grantbrooks.io"],
                attachments: attachments
            )

            mailComposer.onComposeFinished { onComposeFinished($0) }
        }

        guard mailComposer.canSendMail else {
            let exception: Exception = .init(
                "Device is not configured for e-mail.",
                isReportable: false,
                extraParams: [Exception.CommonParamKeys.userFacingDescriptor.rawValue: Localized(.noEmail).wrappedValue],
                metadata: [self, #file, #function, #line]
            )

            Logger.log(exception)
            await AKErrorAlert(
                exception,
                dismissButtonTitle: Localized(.dismiss).wrappedValue
            ).present(translating: [])
            return
        }

        guard let body,
              let prompt else { return compose(body: nil, prompt: nil) }

        guard let translationDelegate = alertKitConfig.translationDelegate else { return }
        let getTranslationsResult = await translationDelegate.getTranslations(
            [
                .init(body),
                .init(prompt),
            ],
            languagePair: .system,
            hud: alertKitConfig.translationHUDConfig,
            timeout: alertKitConfig.translationTimeoutConfig
        )

        switch getTranslationsResult {
        case let .success(translations):
            compose(
                body: translations.first(where: { $0.input.value == body })?.output ?? body,
                prompt: translations.first(where: { $0.input.value == prompt })?.output ?? prompt
            )

        case let .failure(error):
            Logger.log(.init(error, metadata: [self, #file, #function, #line]))
            compose(body: body, prompt: prompt)
        }
    }

    private func onComposeFinished(_ result: Result<MFMailComposeResult, Error>) {
        switch result {
        case let .failure(error):
            Logger.log(
                .init(error, metadata: [self, #file, #function, #line]),
                with: .toast()
            )

        case let .success(result):
            switch result {
            case .failed:
                Logger.log(
                    .init(metadata: [self, #file, #function, #line]),
                    with: .toast()
                )

            case .sent:
                Observables.rootViewToast.value = .init(
                    .capsule(style: .success),
                    message: Localized(.reportSent).wrappedValue,
                    perpetuation: .ephemeral(.seconds(3))
                )

            default: ()
            }
        }
    }

    private func reportMetadataAttachment(_ error: (any AlertKit.Errorable)? = nil) -> MailComposer.AttachmentData? {
        func attachmentData(_ dictionary: [String: String]) -> MailComposer.AttachmentData? {
            do {
                return try .init(
                    jsonEncoder.encode(dictionary),
                    fileName: "metadata.log",
                    mimeType: "application/json"
                )
            } catch {
                Logger.log(.init(error, metadata: [self, #file, #function, #line]))
                return nil
            }
        }

        var sections = [
            "build_number": "\(build.buildNumber)\(build.stage.shortString)",
            "build_sku": build.buildSKU,
            "connection_status": build.isOnline ? "online" : "offline",
            "device_model": "\(SystemInformation.modelName) (\(SystemInformation.modelCode.lowercased()))",
            "internal_bundle_version": build.bundleVersion,
            "language_code": RuntimeStorage.languageCode,
            "occurrence_date": dateFormatter.string(from: .now),
            "operating_system_id": SystemInformation.osVersion.lowercased(),
            "project_id": build.projectID,
            "release_bundle_version": build.bundleReleaseVersion,
        ]

        guard let error else { return attachmentData(sections) }

        var errorDescription = error.description
        if let descriptor = error.extraParams?["Descriptor"] as? String,
           let hashlet = error.extraParams?["Hashlet"] as? String {
            errorDescription = "\(descriptor) (\(hashlet.uppercased()))"
        }

        sections["error_description"] = errorDescription
        sections["error_id"] = error.id

        if let additionalParameters = error.extraParams?
            .filter({ $0.key != "Descriptor" })
            .filter({ $0.key != "Hashlet" }),
            !additionalParameters.isEmpty {
            sections["error_parameters"] = additionalParameters
                .withCapitalizedKeys
                .description
                .replacingOccurrences(of: "\"", with: "'")
        }

        return attachmentData(sections)
    }
}

/* MARK: DateFormatter Dependency */

private enum ReportDelegateDateFormatterDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        formatter.locale = .init(identifier: "en_US")
        return formatter
    }
}

private extension DependencyValues {
    var reportDelegateDateFormatter: DateFormatter {
        get { self[ReportDelegateDateFormatterDependency.self] }
        set { self[ReportDelegateDateFormatterDependency.self] = newValue }
    }
}
