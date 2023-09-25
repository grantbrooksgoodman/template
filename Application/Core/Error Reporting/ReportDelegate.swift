//
//  ReportDelegate.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import CryptoKit
import MessageUI

/* 3rd-party */
import AlertKit
import Redux
import Translator

public class ReportDelegate: UIViewController, AKReportDelegate, MFMailComposeViewControllerDelegate {
    // MARK: - Dependencies

    @Dependency(\.alertKitCore) private var akCore: AKCore
    @Dependency(\.coreKit) private var core: CoreKit
    @Dependency(\.britishDateAndTimeFormatter) private var dateFormatter: DateFormatter

    // MARK: - Computed Properties

    private var commonParams: [String: String] {
        var parameters = [String: String]()

        if let currentFile = RuntimeStorage.currentFile,
           !currentFile.components(separatedBy: "/").isEmpty {
            guard let fileName = currentFile.components(separatedBy: "/").last else { return parameters }
            guard let trimmedFileName = fileName.components(separatedBy: ".").first else { return parameters }

            let snakeCaseFileName = trimmedFileName.firstLowercase.snakeCased
            parameters["CurrentFile"] = snakeCaseFileName
        }

        if let languageCode = RuntimeStorage.languageCode {
            parameters["LanguageCode"] = languageCode
        }

        return parameters
    }

    private var dateHashlet: String {
        var dateHash = dateFormatter.string(from: Date())

        let compressedData = try? (Data(dateHash.utf8) as NSData).compressed(using: .lzfse)
        if let data = compressedData {
            dateHash = SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
        } else {
            dateHash = SHA256.hash(data: Data(dateHash.utf8)).compactMap { String(format: "%02x", $0) }.joined()
        }

        return dateHash.components[0 ... dateHash.count / 4].joined()
    }

    // MARK: - AKReportDelegate Conformance

    public func fileReport(error: AKError) {
        var injectedError = error
        injectedError = inject(params: commonParams, into: error)

        guard let data = getLogFileData(type: .error, error: injectedError) else {
            Logger.log(.init("Couldn't get log file data!", metadata: [#file, #function, #line]))
            return
        }

        let logFile = LogFile(
            fileName: "\(Build.codeName.lowercased())_\(dateHashlet)",
            directoryName: "",
            data: data
        )
        let subject = "\(Build.stage == .generalRelease ? Build.finalName : Build.codeName) (\(Build.bundleVersion)) Error Report"

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
        @Dependency(\.translatorService) var translator: TranslatorService

        guard akCore.validateMetadata(metadata) else {
            Logger.log(.init("Improperly formatted metadata.", metadata: [#file, #function, #line]))
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
                    metadata: [#file, #function, #line]
                ),
                with: .errorAlert
            )
            return
        }

        let logFile: LogFile = .init(
            fileName: "\(Build.codeName.lowercased())_\(dateHashlet)",
            directoryName: "",
            data: logFileData
        )

        let subject = "\(Build.stage == .generalRelease ? Build.finalName : Build.codeName) (\(Build.bundleVersion)) \(forBug ? "Bug" : "Feedback") Report"

        var translatedBody = body
        var translatedPrompt = prompt

        translator.getTranslations(
            for: [.init(body),
                  .init(prompt)],
            languagePair: .system,
            hud: (.seconds(2), true)
        ) { translations, exception in
            guard let translations else {
                Logger.log(exception ?? .init(metadata: [#file, #function, #line]))
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
                let encodedMetadata = try encoder.encode(dictionary)

                return encodedMetadata
            } catch {
                Logger.log(.init(error, metadata: [#file, #function, #line]))
                return nil
            }
        }

        guard let contextCode = akCore.contextCode(for: type, metadata: error?.metadata ?? metadata!) else {
            Logger.log(
                .init("Unable to generate context code.", metadata: [#file, #function, #line]),
                with: .fatalAlert
            )
            return nil
        }

        let connectionStatus = Build.isOnline ? "online" : "offline"

        var sections = ["build_sku": Build.buildSKU,
                        "context_code": contextCode,
                        "internet_connection_status": connectionStatus,
                        "occurrence_date": dateFormatter.string(from: Date()),
                        "project_id": Build.projectID]

        guard let error = error else {
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

    private func putFile(_ logFile: LogFile) -> String {
        @Dependency(\.fileManager) var fileManager: FileManager

        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/\(logFile.fileName!).log")

        guard !fileManager.fileExists(atPath: path) else {
            Logger.log(
                .init(
                    "File already exists.",
                    extraParams: ["FilePath": path],
                    metadata: [#file, #function, #line]
                ))
            return path
        }

        guard NSData(data: logFile.data).write(toFile: path, atomically: true) else {
            Logger.log(
                .init(
                    "Couldn't write to path!",
                    extraParams: ["FilePath": path],
                    metadata: [#file, #function, #line]
                ))
            return path
        }

        return path
    }

    // MARK: - E-mail Composition

    private func composeMessage(
        _ messageBody: (message: String, isHTML: Bool)? = nil,
        recipients: [String],
        subject: String,
        logFile: LogFile?
    ) {
        guard MFMailComposeViewController.canSendMail() else {
            let exception = Exception(
                "It appears that your device is not able to send e-mail.\n\nPlease verify that your e-mail client is set up and try again.",
                isReportable: false,
                metadata: [#file, #function, #line]
            )

            AKErrorAlert(
                error: .init(exception),
                networkDependent: true
            ).present()

            return
        }

        let composeController = MFMailComposeViewController()
        composeController.mailComposeDelegate = self

        composeController.setSubject(subject)
        composeController.setToRecipients(recipients)

        if let body = messageBody {
            composeController.setMessageBody(body.message, isHTML: body.isHTML)
        }

        if let file = logFile {
            composeController.addAttachmentData(file.data, mimeType: "application/json", fileName: "\(file.fileName!).log")
        }

        core.ui.present(composeController)
    }

    public func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true) {
            self.core.gcd.after(seconds: 1) {
                if result == .failed {
                    AKErrorAlert(error: .init(.init(error!, metadata: [#file, #function, #line]))).present()
                } else if result == .sent {
                    AKAlert(
                        title: "Message Sent",
                        message: "The message was sent successfully.",
                        cancelButtonTitle: "OK"
                    ).present()
                }
            }
        }
    }

    // MARK: - Auxiliary

    private func inject(params: [String: Any], into akError: AKError) -> AKError {
        var mutable = akError

        guard var existingParams = mutable.extraParams else {
            mutable.extraParams = params
            return mutable
        }

        params.forEach { parameter in
            existingParams[parameter.key] = parameter.value
        }

        mutable.extraParams = existingParams
        return mutable
    }
}
