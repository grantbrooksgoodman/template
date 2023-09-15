//
//  Logger.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* 3rd-party */
import AlertKit
import Redux

// swiftlint:disable:next type_body_length
public enum Logger {
    // MARK: - Dependencies

    @Dependency(\.alertKitCore) private static var akCore: AKCore
    @Dependency(\.coreKit) private static var core: CoreKit

    // MARK: - Properties

    public private(set) static var subscribedDomains: [LoggerDomain] = [.general]

    private static var currentTimeLastCalled = Date()
    private static var elapsedTime: String {
        let time = String(abs(currentTimeLastCalled.seconds(from: Date())))
        return time == "0" ? "" : " @ \(time)s FLC"
    }

    private static var streamOpen = false

    // MARK: - Enums

    public enum AlertType {
        case errorAlert
        case fatalAlert
        case toast(icon: CoreKit.HUD.HUDImage)

        case normalAlert
    }

    // MARK: - Domain Subscription

    public static func subscribe(to domain: LoggerDomain) {
        subscribedDomains.append(domain)
        subscribedDomains = subscribedDomains.unique()
    }

    public static func subscribe(to domains: [LoggerDomain]) {
        subscribedDomains.append(contentsOf: domains)
        subscribedDomains = subscribedDomains.unique()
    }

    public static func unsubscribe(from domain: LoggerDomain) {
        subscribedDomains = subscribedDomains.filter { $0 != domain }
    }

    public static func unsubscribe(from domains: [LoggerDomain]) {
        subscribedDomains.removeAll(where: { domains.contains($0) })
    }

    // MARK: - Logging

    public static func log(
        _ error: Error,
        domain: LoggerDomain = .general,
        with alert: AlertType? = .none,
        metadata: [Any]
    ) {
        log(.init(error, metadata: metadata), domain: domain, with: alert)
    }

    public static func log(
        _ error: NSError,
        domain: LoggerDomain = .general,
        with alert: AlertType? = .none,
        metadata: [Any]
    ) {
        log(.init(error, metadata: metadata), domain: domain, with: alert)
    }

    public static func log(
        _ exception: Exception,
        domain: LoggerDomain = .general,
        with alert: AlertType? = .none
    ) {
        guard Build.loggingEnabled,
              subscribedDomains.contains(domain) else {
            showAlertIfNeeded()
            return
        }

        // swiftlint:disable force_cast
        let fileName = akCore.fileName(for: exception.metadata[0] as! String)
        let functionName = (exception.metadata[1] as! String).components(separatedBy: "(")[0]
        let lineNumber = exception.metadata[2] as! Int
        // swiftlint:enable force_cast

        guard !streamOpen else {
            logToStream(exception.descriptor!, domain: domain, line: lineNumber)
            return
        }

        let header = "-------------------- \(domain.rawValue.uppercased()) --------------------"
        let footer = String(repeating: "-", count: header.count)
        print("\n\(header)\n\(fileName).\(functionName)() [\(lineNumber)]\(elapsedTime)\n\(exception.descriptor!) (\(exception.hashlet!))")

        if let params = exception.extraParams {
            printExtraParams(params)
        }

        print("\(footer)\n")

        currentTimeLastCalled = Date()
        showAlertIfNeeded()

        func showAlertIfNeeded() {
            guard let alertType = alert else { return }

            core.hud.hide()

            switch alertType {
            case .errorAlert:
                let sugarCoatedDescriptor = Exception("", metadata: [#file, #function, #line]).userFacingDescriptor
                let translateDescriptor = (exception.userFacingDescriptor != exception.descriptor) || (exception.userFacingDescriptor == sugarCoatedDescriptor)

                AKErrorAlert(
                    message: exception.userFacingDescriptor,
                    error: exception.asAkError(),
                    shouldTranslate: translateDescriptor ? [.all] : [.actions(indices: nil),
                                                                     .cancelButtonTitle]
                ).present()
            case .fatalAlert:
                akCore.present(
                    .fatalErrorAlert,
                    with: [exception.descriptor!,
                           Build.stage != .generalRelease,
                           exception.metadata!]
                )

            case let .toast(icon):
                core.gcd.after(seconds: 1) { core.hud.flash(exception.userFacingDescriptor, image: icon) }

            case .normalAlert:
                AKAlert(
                    message: exception.userFacingDescriptor,
                    cancelButtonTitle: "OK",
                    shouldTranslate: [.title, .message]
                ).present()
            }
        }
    }

    public static func log(
        _ text: String,
        domain: LoggerDomain = .general,
        with alert: AlertType? = .none,
        metadata: [Any]
    ) {
        guard validateMetadata(metadata) else {
            fallbackLog(text, domain: domain, with: alert)
            return
        }

        // swiftlint:disable force_cast
        let fileName = akCore.fileName(for: metadata[0] as! String)
        let functionName = (metadata[1] as! String).components(separatedBy: "(")[0]
        let lineNumber = metadata[2] as! Int
        // swiftlint:enable force_cast

        guard Build.loggingEnabled,
              subscribedDomains.contains(domain) else {
            showAlertIfNeeded(fileName: fileName, functionName: functionName, lineNumber: lineNumber)
            return
        }

        guard !streamOpen else {
            logToStream(text, domain: domain, line: lineNumber)
            return
        }

        let header = "-------------------- \(domain.rawValue.uppercased()) --------------------"
        let footer = String(repeating: "-", count: header.count)
        print("\n\(header)\n\(fileName).\(functionName)() [\(lineNumber)]\(elapsedTime)\n\(text)\n\(footer)\n")

        currentTimeLastCalled = Date()
        showAlertIfNeeded(fileName: fileName, functionName: functionName, lineNumber: lineNumber)

        func showAlertIfNeeded(
            fileName: String,
            functionName: String,
            lineNumber: Int
        ) {
            guard let alertType = alert else { return }

            core.hud.hide()

            switch alertType {
            case .errorAlert:
                let exception = Exception(text, metadata: [fileName, functionName, lineNumber])

                let sugarCoatedDescriptor = Exception("", metadata: [#file, #function, #line]).userFacingDescriptor
                let translateDescriptor = (exception.userFacingDescriptor != exception.descriptor) || (exception.userFacingDescriptor == sugarCoatedDescriptor)

                AKErrorAlert(
                    message: exception.userFacingDescriptor,
                    error: exception.asAkError(),
                    shouldTranslate: translateDescriptor ? [.all] : [.actions(indices: nil),
                                                                     .cancelButtonTitle]
                ).present()
            case .fatalAlert:
                akCore.present(
                    .fatalErrorAlert,
                    with: [text,
                           Build.stage != .generalRelease,
                           [fileName, functionName, lineNumber]]
                )

            case let .toast(icon):
                core.gcd.after(seconds: 1) { core.hud.flash(text, image: icon) }

            case .normalAlert:
                AKAlert(
                    message: Exception(text, metadata: [fileName, functionName, lineNumber]).userFacingDescriptor,
                    cancelButtonTitle: "OK",
                    shouldTranslate: [.title, .message]
                ).present()
            }
        }
    }

    // MARK: - Streaming

    public static func openStream(
        message: String? = nil,
        domain: LoggerDomain = .general,
        metadata: [Any]
    ) {
        guard Build.loggingEnabled,
              subscribedDomains.contains(domain) else { return }

        guard validateMetadata(metadata) else {
            Logger.log(
                "Improperly formatted metadata.",
                metadata: [#file, #function, #line]
            )
            return
        }

        // swiftlint:disable force_cast
        let fileName = akCore.fileName(for: metadata[0] as! String)
        let functionName = (metadata[1] as! String).components(separatedBy: "(")[0]
        let lineNumber = metadata[2] as! Int
        // swiftlint:enable force_cast

        streamOpen = true
        currentTimeLastCalled = Date()

        guard let firstEntry = message else {
            // swiftlint:disable:next line_length
            print("\n*------------------------STREAM OPENED------------------------*\n[\(domain.rawValue.uppercased())]\n\(fileName).\(functionName)()\(elapsedTime)")
            return
        }

        // swiftlint:disable:next line_length
        print("\n*------------------------STREAM OPENED------------------------*\n[\(domain.rawValue.uppercased())]\n\(fileName).\(functionName)()\n[\(lineNumber)]: \(firstEntry)\(elapsedTime)")
    }

    public static func logToStream(
        _ message: String,
        domain: LoggerDomain = .general,
        line: Int
    ) {
        guard Build.loggingEnabled,
              subscribedDomains.contains(domain),
              streamOpen else { return }

        print("[\(line)]: \(message)\(elapsedTime)")
    }

    public static func closeStream(
        message: String? = nil,
        domain: LoggerDomain = .general,
        onLine: Int? = nil
    ) {
        guard Build.loggingEnabled,
              subscribedDomains.contains(domain),
              streamOpen else { return }
        streamOpen = false
        currentTimeLastCalled = Date()

        guard let closingMessage = message,
              let line = onLine else {
            print("*------------------------STREAM CLOSED------------------------*\n")
            return
        }

        print("[\(line)]: \(closingMessage)\(elapsedTime)\n*------------------------STREAM CLOSED------------------------*\n")
    }

    // MARK: - Auxiliary

    private static func fallbackLog(
        _ text: String,
        domain: LoggerDomain = .general,
        with alert: AlertType? = .none
    ) {
        guard Build.loggingEnabled,
              subscribedDomains.contains(domain) else {
            showAlertIfNeeded()
            return
        }

        let header = "-------------------- \(domain.rawValue.uppercased()) --------------------"
        let footer = String(repeating: "-", count: header.count)
        print("\n\(header)\n[IMPROPERLY FORMATTED METADATA]\n\(text)\n\(footer)\n")

        currentTimeLastCalled = Date()
        showAlertIfNeeded()

        func showAlertIfNeeded() {
            guard let alertType = alert else { return }

            core.hud.hide()

            switch alertType {
            case .errorAlert:
                let exception = Exception(text, metadata: [#file, #function, #line])
                AKErrorAlert(
                    error: exception.asAkError(),
                    shouldTranslate: [.actions(indices: nil),
                                      .cancelButtonTitle]
                ).present()
            case .fatalAlert:
                akCore.present(
                    .fatalErrorAlert,
                    with: [text,
                           Build.stage != .generalRelease,
                           [#file, #function, #line]]
                )

            case let .toast(icon):
                core.gcd.after(seconds: 1) { core.hud.flash(text, image: icon) }

            case .normalAlert:
                AKAlert(
                    message: text,
                    cancelButtonTitle: "OK",
                    shouldTranslate: [.title, .message]
                ).present()
            }
        }
    }

    private static func printExtraParams(_ parameters: [String: Any]) {
        guard !parameters.isEmpty else { return }

        guard parameters.count > 1 else {
            print("[\(parameters.first!.key): \(parameters.first!.value)]")
            return
        }

        for (index, param) in parameters.enumerated() {
            switch index {
            case 0:
                print("[\(param.key): \(param.value),")
            case parameters.count - 1:
                print("\(param.key): \(param.value)]")
            default:
                print("\(param.key): \(param.value),")
            }
        }
    }

    private static func validateMetadata(_ metadata: [Any]) -> Bool {
        guard metadata.count == 3,
              metadata[0] is String,
              metadata[1] is String,
              metadata[2] is Int else { return false }

        return true
    }
}
