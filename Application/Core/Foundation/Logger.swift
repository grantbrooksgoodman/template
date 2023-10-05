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
    // MARK: - Types

    public enum AlertType {
        case errorAlert
        case fatalAlert
        case normalAlert
        case toast(icon: CoreKit.HUD.HUDImage)
    }

    // MARK: - Properties

    public private(set) static var subscribedDomains: [LoggerDomain] = [.general]

    private static var currentTimeLastCalled = Date()
    private static var streamOpen = false

    // MARK: - Computed Properties

    private static var elapsedTime: String {
        let time = String(abs(currentTimeLastCalled.seconds(from: Date())))
        return time == "0" ? "" : " @ \(time)s FLC"
    }

    // MARK: - Domain Subscription

    public static func subscribe(to domain: LoggerDomain) {
        subscribedDomains.append(domain)
        subscribedDomains = subscribedDomains.unique
    }

    public static func subscribe(to domains: [LoggerDomain]) {
        domains.forEach { subscribe(to: $0) }
    }

    public static func unsubscribe(from domain: LoggerDomain) {
        subscribedDomains = subscribedDomains.filter { $0 != domain }
    }

    public static func unsubscribe(from domains: [LoggerDomain]) {
        domains.forEach { unsubscribe(from: $0) }
    }

    // MARK: - Logging

    public static func log(
        _ error: Error,
        domain: LoggerDomain = .general,
        with alertType: AlertType? = .none,
        metadata: [Any]
    ) {
        log(.init(error, metadata: metadata), domain: domain, with: alertType)
    }

    public static func log(
        _ error: NSError,
        domain: LoggerDomain = .general,
        with alertType: AlertType? = .none,
        metadata: [Any]
    ) {
        log(.init(error, metadata: metadata), domain: domain, with: alertType)
    }

    public static func log(
        _ exception: Exception,
        domain: LoggerDomain = .general,
        with alertType: AlertType? = .none
    ) {
        @Dependency(\.alertKitCore) var akCore: AKCore

        guard canLog(to: domain) else {
            showAlertIfNeeded()
            return
        }

        let typeName = String(exception.metadata[0]) // swiftlint:disable force_cast
        let fileName = akCore.fileName(for: exception.metadata[1] as! String)
        let functionName = (exception.metadata[2] as! String).components(separatedBy: "(")[0]
        let lineNumber = exception.metadata[3] as! Int // swiftlint:enable force_cast

        guard !streamOpen else {
            logToStream(exception.descriptor, domain: domain, line: lineNumber)
            return
        }

        let header = "-------------------- \(fileName) | \(domain.rawValue.uppercased()) --------------------"
        let footer = String(repeating: "-", count: header.count)
        print("\n\(header)\n\(typeName).\(functionName)() [\(lineNumber)]\(elapsedTime)\n\(exception.descriptor) (\(exception.hashlet!))")

        if let params = exception.extraParams {
            printExtraParams(params)
        }

        print("\(footer)\n")

        currentTimeLastCalled = Date()
        showAlertIfNeeded()

        func showAlertIfNeeded() {
            guard let alertType else { return }
            showAlert(alertType, exception: exception)
        }
    }

    public static func log(
        _ text: String,
        domain: LoggerDomain = .general,
        with alertType: AlertType? = .none,
        metadata: [Any]
    ) {
        @Dependency(\.alertKitCore) var akCore: AKCore

        guard metadata.isValidMetadata else {
            fallbackLog(text, domain: domain, with: alertType)
            return
        }

        guard canLog(to: domain) else {
            showAlertIfNeeded()
            return
        }

        let typeName = String(metadata[0]) // swiftlint:disable force_cast
        let fileName = akCore.fileName(for: metadata[1] as! String)
        let functionName = (metadata[2] as! String).components(separatedBy: "(")[0]
        let lineNumber = metadata[3] as! Int // swiftlint:enable force_cast

        guard !streamOpen else {
            logToStream(text, domain: domain, line: lineNumber)
            return
        }

        let header = "-------------------- \(fileName) | \(domain.rawValue.uppercased()) --------------------"
        let footer = String(repeating: "-", count: header.count)
        print("\n\(header)\n\(typeName).\(functionName)() [\(lineNumber)]\(elapsedTime)\n\(text)\n\(footer)\n")

        currentTimeLastCalled = Date()
        showAlertIfNeeded()

        func showAlertIfNeeded() {
            guard let alertType else { return }
            showAlert(alertType, data: (text, metadata))
        }
    }

    // MARK: - Streaming

    public static func openStream(
        message: String? = nil,
        domain: LoggerDomain = .general,
        metadata: [Any]
    ) {
        @Dependency(\.alertKitCore) var akCore: AKCore

        guard canLog(to: domain) else { return }
        guard metadata.isValidMetadata else {
            fallbackLog(message ?? "Improperly formatted metadata.", domain: domain)
            return
        }

        let typeName = String(metadata[0]) // swiftlint:disable force_cast
        let fileName = akCore.fileName(for: metadata[1] as! String)
        let functionName = (metadata[2] as! String).components(separatedBy: "(")[0]
        let lineNumber = metadata[3] as! Int // swiftlint:enable force_cast

        guard let message else {
            // swiftlint:disable:next line_length
            print("\n*------------------------STREAM OPENED------------------------*\n[\(fileName) | \(domain.rawValue.uppercased())]\n\(typeName).\(functionName)()\(elapsedTime)")
            return
        }

        // swiftlint:disable:next line_length
        print("\n*------------------------STREAM OPENED------------------------*\n[\(fileName) | \(domain.rawValue.uppercased())]\n\(typeName).\(functionName)()\n[\(lineNumber)]: \(message)\(elapsedTime)")

        streamOpen = true
        currentTimeLastCalled = Date()
    }

    public static func logToStream(
        _ message: String,
        domain: LoggerDomain = .general,
        line: Int
    ) {
        guard canLog(to: domain) else { return }
        guard streamOpen else {
            log(message, metadata: [self, #file, #function, #line])
            return
        }

        print("[\(line)]: \(message)\(elapsedTime)")
    }

    public static func closeStream(
        message: String? = nil,
        domain: LoggerDomain = .general,
        onLine: Int? = nil
    ) {
        guard canLog(to: domain) else { return }
        guard streamOpen else {
            guard let message else { return }
            log(message, metadata: [self, #file, #function, #line])
            return
        }

        guard let message,
              let onLine else {
            print("*------------------------STREAM CLOSED------------------------*\n")
            return
        }

        print("[\(onLine)]: \(message)\(elapsedTime)\n*------------------------STREAM CLOSED------------------------*\n")

        streamOpen = false
        currentTimeLastCalled = Date()
    }

    // MARK: - Auxiliary

    private static func canLog(to domain: LoggerDomain) -> Bool {
        @Dependency(\.build) var build: Build
        guard build.loggingEnabled,
              subscribedDomains.contains(domain) else { return false }
        return true
    }

    private static func fallbackLog(
        _ text: String,
        domain: LoggerDomain = .general,
        with alertType: AlertType? = .none
    ) {
        guard canLog(to: domain) else {
            showAlertIfNeeded()
            return
        }

        let header = "-------------------- \(domain.rawValue.uppercased()) --------------------"
        let footer = String(repeating: "-", count: header.count)
        print("\n\(header)\n[IMPROPERLY FORMATTED METADATA]\n\(text)\n\(footer)\n")

        currentTimeLastCalled = Date()
        showAlertIfNeeded()

        func showAlertIfNeeded() {
            guard let alertType else { return }
            showAlert(alertType, data: (text, [self, #file, #function, #line]))
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

    private static func showAlert(
        _ type: AlertType,
        exception: Exception? = nil,
        data: (text: String, metadata: [Any])? = nil
    ) {
        @Dependency(\.alertKitCore) var akCore: AKCore
        @Dependency(\.build) var build: Build
        @Dependency(\.coreKit) var core: CoreKit

        guard exception != nil || data != nil else { return }

        let descriptor = exception?.descriptor ?? data?.text
        let userFacingDescriptor = exception?.userFacingDescriptor ?? data?.text
        let metadata = exception?.metadata ?? data?.metadata

        guard let descriptor,
              let userFacingDescriptor,
              let metadata else { return }

        core.hud.hide()

        let mockException: Exception = .init(metadata: [self, #file, #function, #line])
        var shouldTranslate = userFacingDescriptor != mockException.userFacingDescriptor

        switch type {
        case .errorAlert:
            var akError: AKError?
            if let exception {
                akError = .init(exception)
            } else if let data {
                akError = .init(.init(data.text, metadata: data.metadata))
            }

            guard let akError else {
                showAlert(.normalAlert, exception: exception, data: data)
                return
            }

            shouldTranslate = akError.description != mockException.userFacingDescriptor

            AKErrorAlert(
                error: akError,
                shouldTranslate: shouldTranslate ? [.all] : [.actions(indices: nil),
                                                             .cancelButtonTitle]
            ).present()

        case .fatalAlert:
            akCore.present(.fatalErrorAlert, with: [
                descriptor,
                build.stage != .generalRelease,
                metadata,
            ])

        case .normalAlert:
            AKAlert(
                message: userFacingDescriptor,
                cancelButtonTitle: "OK",
                shouldTranslate: shouldTranslate ? [.message] : [.none]
            ).present()

        case let .toast(icon: icon):
            core.gcd.after(.seconds(1)) { core.hud.flash(userFacingDescriptor, image: icon) }
        }
    }
}
