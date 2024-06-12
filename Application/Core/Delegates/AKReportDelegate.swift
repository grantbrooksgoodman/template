//
//  AKReportDelegate.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import CryptoKit
import MessageUI

/* 3rd-party */
import AlertKit
import CoreArchitecture
import Translator

public struct LogFile {
    // MARK: - Properties

    public let fileName: String
    public let data: Data

    // MARK: - Init

    public init(fileName: String, data: Data) {
        self.fileName = fileName
        self.data = data
    }
}

public final class ReportDelegate: UIViewController, AKReportDelegate, MFMailComposeViewControllerDelegate {
    // MARK: - Dependencies

    @Dependency(\.alertKitCore) private var akCore: AKCore
    @Dependency(\.build) private var build: Build
    @Dependency(\.coreKit) private var core: CoreKit
    @Dependency(\.reportDelegateDateFormatter) private var dateFormatter: DateFormatter
    @Dependency(\.fileManager) private var fileManager: FileManager

    // MARK: - Properties

    private var commonParams: [String: String] {
        var parameters = ["LanguageCode": RuntimeStorage.languageCode]

        if let presentedView = RuntimeStorage.presentedViewName {
            parameters["PresentedView"] = presentedView.firstLowercase.snakeCased
        }

        return parameters
    }

    private var dateHashlet: String {
        var dateHash = dateFormatter.string(from: Date())
        dateHash = SHA256.hash(data: Data(dateHash.utf8)).compactMap { String(format: "%02x", $0) }.joined()
        return dateHash.components[0 ... dateHash.count / 4].joined()
    }

    // MARK: - AKReportDelegate Conformance

    public func fileReport(error: AKError) {
        let error = error.injecting(commonParams)
        guard let data = getLogFileData(type: .error, error: error) else {
            Logger.log(
                .init(
                    "Couldn't get log file data!",
                    extraParams: ["OriginalMetadata": error.metadata],
                    metadata: [self, #file, #function, #line]
                ),
                with: .errorAlert
            )
            return
        }

        let logFile: LogFile = .init(fileName: "\(build.codeName.lowercased())_\(dateHashlet)", data: data)
        let subject = "\(build.stage == .generalRelease ? build.finalName : build.codeName) (\(build.bundleVersion)) Error Report"

        composeMessage(
            recipients: ["me@grantbrooks.io"],
            subject: subject,
            logFile: logFile
        )
    }

    public func fileReport(
        forBug: Bool,
        body: String,
        prompt: String,
        metadata: [Any]
    ) {
        guard metadata.isValidMetadata else {
            Logger.log(.init("Improperly formatted metadata.", metadata: [self, #file, #function, #line]))
            return
        }

        guard let logFileData = getLogFileData(
            type: forBug ? .bug : .feedback,
            metadata: metadata
        ) else {
            Logger.log(
                .init(
                    "Couldn't get log file data!",
                    extraParams: ["OriginalMetadata": metadata],
                    metadata: [self, #file, #function, #line]
                ),
                with: .errorAlert
            )
            return
        }

        let logFile: LogFile = .init(fileName: "\(build.codeName.lowercased())_\(dateHashlet)", data: logFileData)
        let subject = "\(build.stage == .generalRelease ? build.finalName : build.codeName) (\(build.bundleVersion)) \(forBug ? "Bug" : "Feedback") Report"

        var translatedBody = body
        var translatedPrompt = prompt

        akCore.translationDelegate().getTranslations(
            for: [
                .init(body),
                .init(prompt),
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
                Logger.log(exception ?? .init(metadata: [self, #file, #function, #line]))
                return
            }

            translatedBody = translations.first(where: { $0.input.value() == translatedBody })?.output ?? translatedBody
            translatedPrompt = translations.first(where: { $0.input.value() == translatedPrompt })?.output ?? translatedPrompt

            var bodySection = "<i>\(translatedBody.split(separator: ".")[0]).</i><p></p><b>\(translatedPrompt):</b><p></p>"
            if translatedBody.split(separator: ".").count > 1 {
                bodySection = "<i>\(translatedBody.split(separator: ".")[0]).<p></p>\(translatedBody.split(separator: ".")[1]).</i><p></p>"
            }

            self.composeMessage(
                (message: bodySection, isHTML: true),
                recipients: ["me@grantbrooks.io"],
                subject: subject,
                logFile: logFile
            )
        }
    }

    // MARK: - File Management

    private func getLogFileData(
        type: ContextCodeType,
        error: AKError? = nil,
        metadata: [Any]? = nil
    ) -> Data? {
        func getJSON(from dictionary: [String: String]) -> Data? {
            do {
                let encoder = JSONEncoder()
                return try encoder.encode(dictionary)
            } catch {
                Logger.log(.init(error, metadata: [self, #file, #function, #line]))
                return nil
            }
        }

        guard error != nil || metadata != nil else { return nil }

        guard let contextCode = akCore.contextCode(for: type, metadata: error?.metadata ?? metadata!) else {
            Logger.log(.init("Unable to generate context code.", metadata: [self, #file, #function, #line]))
            return nil
        }

        let connectionStatus = build.isOnline ? "online" : "offline"

        var sections = ["build_sku": build.buildSKU,
                        "context_code": contextCode,
                        "internet_connection_status": connectionStatus,
                        "occurrence_date": dateFormatter.string(from: Date()),
                        "project_id": build.projectID]

        guard let error = error else {
            sections["extra_parameters"] = (commonParams as [String: Any]).withCapitalizedKeys.description.replacingOccurrences(of: "\"", with: "'")
            if let json = getJSON(from: sections) {
                return json
            }

            return nil
        }

        var finalDescriptor = error.description ?? ""

        if let extraParams = error.extraParams,
           let descriptor = extraParams["Descriptor"] as? String {
            if let hashlet = extraParams["Hashlet"] as? String {
                finalDescriptor = "\(descriptor) (\(hashlet.uppercased()))"
            } else {
                finalDescriptor = descriptor
            }
        }

        if finalDescriptor != "" {
            sections["error_descriptor"] = finalDescriptor
        }

        if let extraParams = error.extraParams?.filter({ $0.key != "Descriptor" }).filter({ $0.key != "Hashlet" }),
           !extraParams.isEmpty {
            sections["extra_parameters"] = extraParams.withCapitalizedKeys.description.replacingOccurrences(of: "\"", with: "'")
        }

        if let json = getJSON(from: sections) {
            return json
        }

        return nil
    }

    // MARK: - MFMailComposeViewControllerDelegate Conformance

    public func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true) {
            self.core.gcd.after(.seconds(1)) {
                switch result {
                case .sent:
                    AKAlert(
                        title: "Message Sent",
                        message: "The message was sent successfully.",
                        cancelButtonTitle: "OK"
                    ).present()

                case .failed:
                    var exception: Exception = .init(metadata: [self, #file, #function, #line])
                    if let error {
                        exception = .init(error, metadata: [self, #file, #function, #line])
                    }

                    AKErrorAlert(error: .init(exception)).present()

                default: ()
                }
            }
        }
    }

    // MARK: - Auxiliary

    private func composeMessage(
        _ messageBody: (message: String, isHTML: Bool)? = nil,
        recipients: [String],
        subject: String,
        logFile: LogFile?
    ) {
        guard MFMailComposeViewController.canSendMail() else {
            @Localized(.noEmail) var userFacingDescriptor: String
            let exception = Exception(
                "Device can't send e-mail.",
                isReportable: false,
                extraParams: [Exception.CommonParamKeys.userFacingDescriptor.rawValue: userFacingDescriptor],
                metadata: [self, #file, #function, #line]
            )

            AKErrorAlert(
                error: .init(exception),
                shouldTranslate: [.none],
                networkDependent: true
            ).present()

            return
        }

        let composeController = MFMailComposeViewController()
        composeController.mailComposeDelegate = self

        composeController.setSubject(subject)
        composeController.setToRecipients(recipients)

        if let messageBody {
            composeController.setMessageBody(messageBody.message, isHTML: messageBody.isHTML)
        }

        if let logFile {
            composeController.addAttachmentData(
                logFile.data,
                mimeType: "application/json",
                fileName: "\(logFile.fileName).log"
            )
        }

        let loggerSessionRecordFilePathString = Logger.sessionRecordFilePath.path()

        if let loggerSessionRecordData = fileManager.contents(atPath: loggerSessionRecordFilePathString),
           let loggerSessionRecordFileName = loggerSessionRecordFilePathString
           .components(separatedBy: "/")
           .last?
           .components(separatedBy: ".")
           .first {
            composeController.addAttachmentData(
                loggerSessionRecordData,
                mimeType: "text/plain",
                fileName: "logger_session_\(loggerSessionRecordFileName).txt"
            )
        }

        core.ui.present(composeController)
    }
}

/* MARK: DateFormatter Dependency */

private enum ReportDelegateDateFormatterDependency: DependencyKey {
    public static func resolve(_: DependencyValues) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        formatter.locale = .init(identifier: "en_GB")
        return formatter
    }
}

private extension DependencyValues {
    var reportDelegateDateFormatter: DateFormatter {
        get { self[ReportDelegateDateFormatterDependency.self] }
        set { self[ReportDelegateDateFormatterDependency.self] = newValue }
    }
}
