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
import Redux
import Translator

public class BuildInfoOverlayViewService {
    
    // MARK: - Dependencies
    
    @Dependency(\.coreKit) private var core: CoreKit
    
    // MARK: - Properties
    
    private var willPresentDisclaimerAlert = false
    
    // MARK: - Build Information Alert
    
    private func presentBuildInformationAlert() {
        let message = "Build Number\n\(String(Build.buildNumber))\n\nBuild Stage\n\(Build.stage.description(short: false).capitalized(with: nil))\n\nBundle Version\n\(Build.bundleVersion)\n\nProject ID\n\(Build.projectID)\n\nSKU\n\(Build.buildSKU)"
        
        let alertController = UIAlertController(title: "",
                                                message: "",
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: Localized(.dismiss).wrappedValue,
                                                style: .cancel,
                                                handler: nil))
        
        let mainAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13)]
        let alternateAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 14)]
        
        let attributed = message.attributed(mainAttributes: mainAttributes,
                                            alternateAttributes: alternateAttributes,
                                            alternateAttributeRange: ["Build Number",
                                                                      "Build Stage",
                                                                      "Bundle Version",
                                                                      "Project ID",
                                                                      "SKU"])
        
        alertController.setValue(attributed, forKey: "attributedMessage")
        core.ui.present(alertController)
    }
    
    // MARK: - Disclaimer Alert
    
    public func buildInfoButtonTapped() {
        @Dependency(\.currentCalendar) var calendar: Calendar
        @Dependency(\.translatorService) var translator: TranslatorService
        
        guard !core.ui.isPresentingAlertController,
              !willPresentDisclaimerAlert else { return }
        willPresentDisclaimerAlert = true
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        let typeString = Build.stage.description(short: false)
        let expiryString = Build.timebombActive ? "\n\n\(Build.expiryInfoString)" : ""
        
        var messageToDisplay = "This is a\(typeString == "alpha" ? "n" : "") \(typeString) version of *project code name \(Build.codeName)*.\(expiryString)"
        
        if Build.appStoreReleaseVersion > 0 {
            messageToDisplay = "This is a pre-release update to \(Build.finalName).\(Build.expiryInfoString)"
        }
        
        messageToDisplay += "\n\nAll features presented here are subject to change, and any new or previously undisclosed information presented within this software is to remain strictly confidential.\n\nRedistribution of this software by unauthorized parties in any way, shape, or form is strictly prohibited.\n\nBy continuing your use of this software, you acknowledge your agreement to the above terms.\n\nAll content herein, unless otherwise stated, is copyright © \(calendar.dateComponents([.year], from: Date()).year!) NEOTechnica Corporation. All rights reserved."
        
        let projectTitle = "Project \(Build.codeName)"
        let viewBuildInformationString = "View Build Information"
        
        let enableOrDisable = Build.developerModeEnabled ? "Disable" : "Enable"
        let developerModeString = "\(enableOrDisable) Developer Mode"
        
        var hasPresented = false
        core.gcd.after(milliseconds: 750) {
            guard !hasPresented else { return }
            self.core.hud.showProgress()
        }
        
        translator.getTranslations(for: [.init(messageToDisplay),
                                         .init(projectTitle),
                                         .init(viewBuildInformationString)],
                                   languagePair: .init(from: "en", to: RuntimeStorage.languageCode!),
                                   requiresHUD: false,
                                   using: .google) { translations, errorDescriptors in
            guard let translations else {
                self.core.hud.hide()
                self.willPresentDisclaimerAlert = false
                Logger.log(errorDescriptors?.keys.joined(separator: "\n") ?? "An unknown error occurred.",
                           metadata: [#file, #function, #line])
                return
            }
            
            let controllerTitle = translations.first(where: { $0.input.value() == projectTitle })?.output ?? projectTitle
            let controllerMessage = translations.first(where: { $0.input.value() == messageToDisplay })?.output.sanitized ?? messageToDisplay.sanitized
            let alertController = UIAlertController(title: controllerTitle,
                                                    message: controllerMessage,
                                                    preferredStyle: .alert)
            
            
            let viewBuildInformationActionTitle = translations.first(where: { $0.input.value() == viewBuildInformationString })?.output ?? viewBuildInformationString
            let viewBuildInformationAction = UIAlertAction(title: viewBuildInformationActionTitle,
                                                           style: .default) { _ in
                self.willPresentDisclaimerAlert = false
                self.presentBuildInformationAlert()
            }
            
            let developerModeAction = UIAlertAction(title: developerModeString,
                                                    style: enableOrDisable == "Enable" ? .default : .destructive) { _ in
                self.willPresentDisclaimerAlert = false
                DevModeService.promptToToggle()
            }
            
            let dismissAction = UIAlertAction(title: Localized(.dismiss).wrappedValue, style: .cancel) { _ in
                self.willPresentDisclaimerAlert = false
            }
            
            alertController.addAction(viewBuildInformationAction)
            alertController.addAction(developerModeAction)
            alertController.addAction(dismissAction)
            
            guard Build.timebombActive else {
                alertController.message = translations.first(where: { $0.input.value() == messageToDisplay })?.output.sanitized ?? messageToDisplay.sanitized
                hasPresented = true
                self.willPresentDisclaimerAlert = false
                self.core.ui.present(alertController)
                
                return
            }
            
            let mainAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13)]
            let alternateAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red]
            
            var dateComponent: String!
            let preExpiryComponents = Build.expiryInfoString.components(separatedBy: "expire on")
            let postExpiryComponents = Build.expiryInfoString.components(separatedBy: "ended on")
            
            if preExpiryComponents.count > 1 {
                dateComponent = preExpiryComponents[1].components(separatedBy: ".")[0]
            } else if postExpiryComponents.count > 1 {
                dateComponent = postExpiryComponents[1].components(separatedBy: ".")[0]
            }
            
            let message = translations.first(where: { $0.input.value() == messageToDisplay })?.output.sanitized ?? messageToDisplay.sanitized
            let attributed = message.attributed(mainAttributes: mainAttributes,
                                                alternateAttributes: alternateAttributes,
                                                alternateAttributeRange: [dateComponent])
            alertController.setValue(attributed, forKey: "attributedMessage")
            
            hasPresented = true
            self.willPresentDisclaimerAlert = false
            self.core.ui.present(alertController)
        }
    }
    
    // MARK: - Send Feedback Action Sheet
    
    public func sendFeedbackButtonTapped() {
        @Dependency(\.alertKitCore) var akCore: AKCore
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        let sendFeedbackAction = AKAction(title: "Send Feedback", style: .default)
        let reportBugAction = AKAction(title: "Report a Bug", style: .default)
        
        let actionSheet = AKActionSheet(message: "File a Report",
                                        actions: [sendFeedbackAction, reportBugAction],
                                        networkDependent: true)
        
        actionSheet.present { actionID in
            guard actionID != -1 else { return }
            
            if actionID == sendFeedbackAction.identifier {
                akCore.reportDelegate().fileReport(forBug: false,
                                                   body: "Any general feedback is appreciated in the appropriate section.",
                                                   prompt: "General Feedback",
                                                   metadata: [RuntimeStorage.currentFile ?? #file,
                                                              #function,
                                                              #line])
            } else if actionID == reportBugAction.identifier {
                akCore.reportDelegate().fileReport(forBug: true,
                                                   body: "In the appropriate section, please describe the error encountered and the steps to reproduce it.",
                                                   prompt: "Description/Steps to Reproduce",
                                                   metadata: [RuntimeStorage.currentFile ?? #file,
                                                              #function,
                                                              #line])
            }
        }
    }
}
