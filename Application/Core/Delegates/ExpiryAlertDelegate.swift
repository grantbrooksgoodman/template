//
//  ExpiryAlertDelegate.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import UIKit

/* 3rd-party */
import AlertKit
import Redux
import Translator

public class ExpiryAlertDelegate: AKExpiryAlertDelegate {
    
    // MARK: - Properties
    
    // Dependencies
    @Dependency(\.coreKit) private var core: CoreKit
    
    // Strings
    private var continueUseString = "Continue Use"
    private var exitApplicationString = "Exit Application"
    private var expiryMessage = "The evaluation period for this pre-release build of \(Build.codeName) has ended.\n\nTo continue using this version, enter the six-digit expiration override code associated with it.\n\nUntil updated to a newer build, entry of this code will be required each time the application is launched.\n\nTime remaining for successful entry: 00:30"
    private var expiryTitle = "End of Evaluation Period"
    private var incorrectCodeMessage = "The code entered was incorrect.\n\nPlease enter the correct expiration override code or exit the application."
    private var incorrectCodeTitle = "Incorrect Override Code"
    private var timeExpiredMessage = "The application will now exit."
    private var timeExpiredTitle = "Time Expired"
    private var tryAgainString = "Try Again"
    
    // Other
    private var didTranslateStrings = false
    private var expiryAlertController: UIAlertController!
    private var exitTimer: Timer?
    private var remainingSeconds = 30
    
    // MARK: - Public
    
    public func presentExpiryAlert() {
        func present() {
            self.expiryAlertController = UIAlertController(title: self.expiryTitle,
                                                           message: self.expiryMessage,
                                                           preferredStyle: .alert)
            
            self.expiryAlertController.addTextField { textField in
                textField.clearButtonMode = .never
                textField.isSecureTextEntry = true
                textField.keyboardAppearance = .light
                textField.keyboardType = .numberPad
                textField.placeholder = "\(Build.bundleVersion) | \(Build.buildSKU)"
                textField.textAlignment = .center
            }
            
            let continueUseAction = UIAlertAction(title: self.continueUseString,
                                                  style: .default) { _ in
                let returnedString = self.expiryAlertController.textFields![0].text!
                
                if returnedString == self.getExpirationOverrideCode() {
                    self.exitTimer?.invalidate()
                    self.exitTimer = nil
                    
                    RuntimeStorage.topWindow?.removeSubviews(for: "EXPIRY_OVERLAY_WINDOW")
                } else {
                    let incorrectAlertController = UIAlertController(title: self.incorrectCodeTitle,
                                                                     message: self.incorrectCodeMessage,
                                                                     preferredStyle: .alert)
                    
                    let tryAgainAction = UIAlertAction(title: self.tryAgainString,
                                                       style: .default) { _ in
                        self.presentExpiryAlert()
                    }
                    
                    let exitApplicationAction = UIAlertAction(title: self.exitApplicationString,
                                                              style: .destructive) { _ in
                        fatalError("Evaluation period ended")
                    }
                    
                    incorrectAlertController.addAction(tryAgainAction)
                    incorrectAlertController.addAction(exitApplicationAction)
                    incorrectAlertController.preferredAction = tryAgainAction
                    
                    self.core.ui.present(incorrectAlertController)
                }
            }
            
            continueUseAction.isEnabled = false
            self.expiryAlertController.addAction(continueUseAction)
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: self.expiryAlertController.textFields![0], queue: .main) { _ in
                continueUseAction.isEnabled = self.expiryAlertController.textFields![0].text!.lowercasedTrimmingWhitespace.count == 6
            }
            
            self.expiryAlertController.addAction(UIAlertAction(title: self.exitApplicationString,
                                                               style: .destructive) { _ in
                fatalError("Evaluation period ended")
            })
            
            self.expiryAlertController.preferredAction = self.expiryAlertController.actions[0]
            self.setAttributedExpiryMessage()
            self.core.ui.present(self.expiryAlertController)
            
            guard let timer = self.exitTimer else {
                self.exitTimer = Timer.scheduledTimer(timeInterval: 1,
                                                      target: self,
                                                      selector: #selector(self.decrementSecond),
                                                      userInfo: nil,
                                                      repeats: true)
                return
            }
            
            if !timer.isValid {
                self.exitTimer = Timer.scheduledTimer(timeInterval: 1,
                                                      target: self,
                                                      selector: #selector(self.decrementSecond),
                                                      userInfo: nil,
                                                      repeats: true)
            }
        }
        
        guard !didTranslateStrings else {
            present()
            return
        }
        
        translateStrings { present() }
    }
    
    public func getExpirationOverrideCode() -> String {
        guard Build.codeName.count > 0 else { return "" }
        let firstLetter = String(Build.codeName.first!)
        let lastLetter = String(Build.codeName.last!)
        
        let middleIndex = Build.codeName.index(Build.codeName.startIndex,
                                               offsetBy: Int((Double(Build.codeName.count) / 2).rounded(.down)))
        let middleLetter = String(Build.codeName[middleIndex])
        
        var numberStrings: [String] = []
        
        for letter in [firstLetter, middleLetter, lastLetter] {
            guard let position = letter.alphabeticalPosition else { continue }
            numberStrings.append(String(format: "%02d", position))
        }
        
        return numberStrings.joined()
    }
    
    // MARK: - Private
    
    @objc private func decrementSecond() {
        remainingSeconds -= 1
        
        if remainingSeconds < 0 {
            exitTimer?.invalidate()
            exitTimer = nil
            
            core.ui.dismissAlertController()
            
            let alertController = UIAlertController(title: self.timeExpiredTitle,
                                                    message: self.timeExpiredMessage,
                                                    preferredStyle: .alert)
            
            core.ui.present(alertController)
            core.gcd.after(seconds: 5) { fatalError("Evaluation period ended") }
        } else {
            let decrementString = String(format: "%02d", remainingSeconds)
            expiryMessage = "\(expiryMessage.components(separatedBy: ":")[0]): 00:\(decrementString)"
            setAttributedExpiryMessage()
        }
    }
    
    private func setAttributedExpiryMessage() {
        let alternateAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red,
                                                                  .font: UIFont.systemFont(ofSize: 17)]
        
        let messageComponents = expiryMessage.components(separatedBy: ":")
        let attributeRange = messageComponents[1...messageComponents.count - 1].joined(separator: ":")
        
        let attributedMessage = expiryMessage.attributed(mainAttributes: [.font: UIFont.systemFont(ofSize: 13)],
                                                         alternateAttributes: alternateAttributes,
                                                         alternateAttributeRange: [attributeRange])
        
        expiryAlertController.setValue(attributedMessage, forKey: "attributedMessage")
    }
    
    private func translateStrings(completion: @escaping() -> Void) {
        @Dependency(\.translatorService) var translator: TranslatorService
        
        let dispatchGroup = DispatchGroup()
        var leftDispatchGroup = false
        
        var inputsToTranslate: [Translator.TranslationInput] = [.init(expiryTitle),
                                                                .init(expiryMessage),
                                                                .init(continueUseString),
                                                                .init(incorrectCodeTitle),
                                                                .init(incorrectCodeMessage),
                                                                .init(tryAgainString),
                                                                .init(exitApplicationString),
                                                                .init(timeExpiredTitle),
                                                                .init(timeExpiredMessage)]
        
        inputsToTranslate = inputsToTranslate.filter({$0.value().lowercasedTrimmingWhitespace != ""})
        dispatchGroup.enter()
        translator.getTranslations(for: inputsToTranslate,
                                   languagePair: .init(from: "en", to: RuntimeStorage.languageCode!),
                                   requiresHUD: true,
                                   using: .google) { translations, errorDescriptors in
            guard let translations else {
                Logger.log(errorDescriptors?.keys.joined(separator: "\n") ?? "An unknown error occurred.",
                           metadata: [#file, #function, #line])
                return
            }
            
            self.expiryTitle = translations.first(where: { $0.input.value() == self.expiryTitle })?.output ?? self.expiryTitle
            self.expiryMessage = translations.first(where: { $0.input.value() == self.expiryMessage })?.output ?? self.expiryMessage
            self.continueUseString = translations.first(where: { $0.input.value() == self.continueUseString })?.output ?? self.continueUseString
            self.incorrectCodeTitle = translations.first(where: { $0.input.value() == self.incorrectCodeTitle })?.output ?? self.incorrectCodeTitle
            self.incorrectCodeMessage = translations.first(where: { $0.input.value() == self.incorrectCodeMessage })?.output ?? self.incorrectCodeMessage
            self.tryAgainString = translations.first(where: { $0.input.value() == self.tryAgainString })?.output ?? self.tryAgainString
            self.exitApplicationString = translations.first(where: { $0.input.value() == self.exitApplicationString })?.output ?? self.exitApplicationString
            self.timeExpiredTitle = translations.first(where: { $0.input.value() == self.timeExpiredTitle })?.output ?? self.timeExpiredTitle
            self.timeExpiredMessage = translations.first(where: { $0.input.value() == self.timeExpiredMessage })?.output ?? self.timeExpiredMessage
            
            if !leftDispatchGroup {
                dispatchGroup.leave()
                leftDispatchGroup = true
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.didTranslateStrings = true
            completion()
        }
    }
}
