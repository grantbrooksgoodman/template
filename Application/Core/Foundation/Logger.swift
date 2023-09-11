//
//  Logger.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* 3rd-party */
import AlertKit
import Redux

public struct Logger {
    
    // MARK: - Dependencies
    
    @Dependency(\.alertKitCore) private static var akCore: AKCore
    @Dependency(\.coreKit) private static var core: CoreKit
    
    // MARK: - Properties
    
    public static var exposureLevel: ExposureLevel = .normal
    
    private static var currentTimeLastCalled = Date()
    private static var elapsedTime: String {
        get {
            let time = String(abs(currentTimeLastCalled.seconds(from: Date())))
            return time == "0" ? "" : " @ \(time)s FLC"
        }
    }
    private static var streamOpen = false
    
    // MARK: - Enums
    
    public enum AlertType {
        case errorAlert
        case fatalAlert
        case toast(icon: CoreKit.HUD.HUDImage)
        
        case normalAlert
    }
    
    public enum ExposureLevel {
        case verbose
        case normal
    }
    
    // MARK: - Logging
    
    public static func log(_ error: Error,
                           with: AlertType? = .none,
                           verbose: Bool? = nil,
                           metadata: [Any]) {
        log(Exception(error, metadata: metadata),
            with: with,
            verbose: verbose)
    }
    
    public static func log(_ error: NSError,
                           with: AlertType? = .none,
                           verbose: Bool? = nil,
                           metadata: [Any]) {
        log(Exception(error, metadata: metadata),
            with: with,
            verbose: verbose)
    }
    
    public static func log(_ exception: Exception,
                           with: AlertType? = .none,
                           verbose: Bool? = nil) {
        guard Build.loggingEnabled else {
            showAlertIfNeeded()
            return
        }
        
        if let verbose = verbose,
           verbose, exposureLevel != .verbose {
            return
        }
        
        let fileName = akCore.fileName(for: exception.metadata[0] as! String)
        let functionName = (exception.metadata[1] as! String).components(separatedBy: "(")[0]
        let lineNumber = exception.metadata[2] as! Int
        
        guard !streamOpen else {
            logToStream(exception.descriptor!, line: lineNumber)
            return
        }
        
        print("\n--------------------------------------------------\n\(fileName): \(functionName)() [\(lineNumber)]\(elapsedTime)\n\(exception.descriptor!) (\(exception.hashlet!))")
        
        if let params = exception.extraParams {
            printExtraParams(params)
        }
        
        print("--------------------------------------------------\n")
        
        currentTimeLastCalled = Date()
        
        showAlertIfNeeded()
        
        func showAlertIfNeeded() {
            guard let alertType = with else { return }
            
            core.hud.hide()
            
            switch alertType {
            case .errorAlert:
                let sugarCoatedDescriptor = Exception("", metadata: [#file, #function, #line]).userFacingDescriptor
                let translateDescriptor = (exception.userFacingDescriptor != exception.descriptor) || (exception.userFacingDescriptor == sugarCoatedDescriptor)
                
                AKErrorAlert(message: exception.userFacingDescriptor,
                             error: exception.asAkError(),
                             shouldTranslate: translateDescriptor ? [.all] : [.actions(indices: nil),
                                                                              .cancelButtonTitle]).present()
            case .fatalAlert:
                akCore.present(.fatalErrorAlert,
                               with: [exception.descriptor!,
                                      Build.stage != .generalRelease,
                                      exception.metadata!])
                
            case let .toast(icon):
                core.gcd.after(seconds: 1) { core.hud.flash(exception.userFacingDescriptor, image: icon) }
                
            case .normalAlert:
                AKAlert(message: exception.userFacingDescriptor,
                        cancelButtonTitle: "OK",
                        shouldTranslate: [.title, .message]).present()
            }
        }
    }
    
    public static func log(_ text: String,
                           with: AlertType? = .none,
                           verbose: Bool? = nil,
                           metadata: [Any]) {
        if let verbose = verbose,
           verbose, exposureLevel != .verbose {
            return
        }
        
        guard validateMetadata(metadata) else {
            fallbackLog(text, with: with)
            return
        }
        
        let fileName = akCore.fileName(for: metadata[0] as! String)
        let functionName = (metadata[1] as! String).components(separatedBy: "(")[0]
        let lineNumber = metadata[2] as! Int
        
        guard Build.loggingEnabled else {
            showAlertIfNeeded(fileName: fileName, functionName: functionName, lineNumber: lineNumber)
            return
        }
        
        guard !streamOpen else {
            logToStream(text, line: lineNumber)
            return
        }
        
        print("\n--------------------------------------------------\n\(fileName): \(functionName)() [\(lineNumber)]\(elapsedTime)\n\(text)\n--------------------------------------------------\n")
        
        currentTimeLastCalled = Date()
        
        showAlertIfNeeded(fileName: fileName, functionName: functionName, lineNumber: lineNumber)
        
        func showAlertIfNeeded(fileName: String,
                               functionName: String,
                               lineNumber: Int) {
            guard let alertType = with else { return }
            
            core.hud.hide()
            
            switch alertType {
            case .errorAlert:
                let exception = Exception(text,
                                          metadata: [fileName, functionName, lineNumber])
                
                let sugarCoatedDescriptor = Exception("", metadata: [#file, #function, #line]).userFacingDescriptor
                let translateDescriptor = (exception.userFacingDescriptor != exception.descriptor) || (exception.userFacingDescriptor == sugarCoatedDescriptor)
                
                AKErrorAlert(message: exception.userFacingDescriptor,
                             error: exception.asAkError(),
                             shouldTranslate: translateDescriptor ? [.all] : [.actions(indices: nil),
                                                                              .cancelButtonTitle]).present()
            case .fatalAlert:
                akCore.present(.fatalErrorAlert,
                               with: [text,
                                      Build.stage != .generalRelease,
                                      [fileName, functionName, lineNumber]])
                
            case let .toast(icon):
                core.gcd.after(seconds: 1) { core.hud.flash(text, image: icon) }
                
            case .normalAlert:
                AKAlert(message: Exception(text,
                                           metadata: [fileName, functionName, lineNumber]).userFacingDescriptor,
                        cancelButtonTitle: "OK",
                        shouldTranslate: [.title, .message]).present()
            }
        }
    }
    
    // MARK: - Streaming
    
    public static func openStream(message: String? = nil,
                                  metadata: [Any]) {
        guard Build.loggingEnabled else { return }
        
        if exposureLevel == .verbose {
            guard validateMetadata(metadata) else {
                Logger.log("Improperly formatted metadata.",
                           metadata: [#file, #function, #line])
                return
            }
            
            let fileName = akCore.fileName(for: metadata[0] as! String)
            let functionName = (metadata[1] as! String).components(separatedBy: "(")[0]
            let lineNumber = metadata[2] as! Int
            
            streamOpen = true
            
            currentTimeLastCalled = Date()
            
            guard let firstEntry = message else {
                print("\n*------------------------STREAM OPENED------------------------*\n\(fileName): \(functionName)()\(elapsedTime)")
                return
            }
            
            print("\n*------------------------STREAM OPENED------------------------*\n\(fileName): \(functionName)()\n[\(lineNumber)]: \(firstEntry)\(elapsedTime)")
        }
    }
    
    public static func logToStream(_ message: String,
                                   line: Int) {
        guard Build.loggingEnabled,
              streamOpen,
              exposureLevel == .verbose else { return }
        
        print("[\(line)]: \(message)\(elapsedTime)")
    }
    
    public static func closeStream(message: String? = nil,
                                   onLine: Int? = nil) {
        guard Build.loggingEnabled,
              streamOpen,
              exposureLevel == .verbose else { return }
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
    
    private static func fallbackLog(_ text: String,
                                    with: AlertType? = .none) {
        guard Build.loggingEnabled else {
            showAlertIfNeeded()
            return
        }
        
        print("\n--------------------------------------------------\n[IMPROPERLY FORMATTED METADATA]\n\(text)\n--------------------------------------------------\n")
        
        currentTimeLastCalled = Date()
        
        showAlertIfNeeded()
        
        func showAlertIfNeeded() {
            guard let alertType = with else { return }
            
            core.hud.hide()
            
            switch alertType {
            case .errorAlert:
                let exception = Exception(text,
                                          metadata: [#file, #function, #line])
                AKErrorAlert(error: exception.asAkError(),
                             shouldTranslate: [.actions(indices: nil),
                                               .cancelButtonTitle]).present()
            case .fatalAlert:
                akCore.present(.fatalErrorAlert,
                               with: [text,
                                      Build.stage != .generalRelease,
                                      [#file, #function, #line]])
                
            case let .toast(icon):
                core.gcd.after(seconds: 1) { core.hud.flash(text, image: icon) }
                
            case .normalAlert:
                AKAlert(message: text,
                        cancelButtonTitle: "OK",
                        shouldTranslate: [.title, .message]).present()
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
