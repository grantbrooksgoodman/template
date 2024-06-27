//
//  AKExpiryAlertDelegate.swift
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

public final class ExpiryAlertDelegate: AKExpiryAlertDelegate {
    // MARK: - Properties

    // Dependencies
    @Dependency(\.alertKitCore) private var akCore: AKCore
    @Dependency(\.build) private var build: Build
    @Dependency(\.coreKit) private var core: CoreKit
    @Dependency(\.notificationCenter) private var notificationCenter: NotificationCenter
    @Dependency(\.uiApplication) private var uiApplication: UIApplication

    // String
    private var continueUseString = ""
    private var exitApplicationString = ""
    private var expiryMessage = ""
    private var expiryTitle = ""
    private var incorrectCodeMessage = ""
    private var incorrectCodeTitle = ""
    private var timeExpiredMessage = ""
    private var timeExpiredTitle = ""
    private var tryAgainString = ""

    // Other
    private var didTranslateStrings = false
    private var expiryAlertController: UIAlertController!
    private var exitTimer: Timer?
    private var remainingSeconds = 30

    // MARK: - Init

    public init() {
        continueUseString = "Continue Use"
        exitApplicationString = "Exit"
        // swiftlint:disable:next line_length
        expiryMessage = "The evaluation period for this pre-release build of \(build.codeName) has ended.\n\nTo continue using this version, enter the six-digit expiration override code associated with it.\n\nUntil updated to a newer build, entry of this code will be required each time the application is launched.\n\nTime remaining for successful entry: 00:30"
        expiryTitle = "End of Evaluation Period"
        incorrectCodeMessage = "The code entered was incorrect.\n\nPlease enter the correct expiration override code or exit the application."
        incorrectCodeTitle = "Incorrect Override Code"
        timeExpiredMessage = "The application will now exit."
        timeExpiredTitle = "Time Expired"
        tryAgainString = "Try Again"
    }

    // MARK: - AKExpiryAlertDelegate Conformance

    public func presentExpiryAlert() {
        func present() {
            expiryAlertController = UIAlertController(
                title: expiryTitle,
                message: expiryMessage,
                preferredStyle: .alert
            )

            expiryAlertController.addTextField { textField in
                textField.clearButtonMode = .never
                textField.isSecureTextEntry = true
                textField.keyboardAppearance = .light
                textField.keyboardType = .numberPad
                textField.placeholder = "\(self.build.bundleVersion) | \(self.build.buildSKU)"
                textField.textAlignment = .center
            }

            let continueUseAction = UIAlertAction(
                title: continueUseString,
                style: .default
            ) { _ in
                let returnedString = self.expiryAlertController.textFields![0].text!

                if returnedString == self.build.expirationOverrideCode {
                    self.exitTimer?.invalidate()
                    self.exitTimer = nil
                    self.uiApplication.keyWindow?.removeSubviews(for: "EXPIRY_OVERLAY_WINDOW")
                } else {
                    let incorrectAlertController = UIAlertController(
                        title: self.incorrectCodeTitle,
                        message: self.incorrectCodeMessage,
                        preferredStyle: .alert
                    )

                    let tryAgainAction = UIAlertAction(
                        title: self.tryAgainString,
                        style: .default
                    ) { _ in
                        self.presentExpiryAlert()
                    }

                    let exitApplicationAction = UIAlertAction(
                        title: self.exitApplicationString,
                        style: .destructive
                    ) { _ in
                        fatalError("Evaluation period ended")
                    }

                    incorrectAlertController.addAction(tryAgainAction)
                    incorrectAlertController.addAction(exitApplicationAction)
                    incorrectAlertController.preferredAction = tryAgainAction

                    self.core.ui.present(incorrectAlertController)
                }
            }

            continueUseAction.isEnabled = false
            expiryAlertController.addAction(continueUseAction)

            notificationCenter.addObserver(
                forName: UITextField.textDidChangeNotification,
                object: expiryAlertController.textFields![0],
                queue: .main
            ) { _ in
                continueUseAction.isEnabled = self.expiryAlertController.textFields![0].text!.lowercasedTrimmingWhitespaceAndNewlines.count == 6
            }

            expiryAlertController.addAction(UIAlertAction(
                title: exitApplicationString,
                style: .destructive
            ) { _ in
                fatalError("Evaluation period ended")
            })

            expiryAlertController.preferredAction = expiryAlertController.actions[0]
            setAttributedExpiryMessage()
            core.ui.present(expiryAlertController)

            guard let timer = exitTimer else {
                exitTimer = Timer.scheduledTimer(
                    timeInterval: 1,
                    target: self,
                    selector: #selector(decrementSecond),
                    userInfo: nil,
                    repeats: true
                )
                return
            }

            if !timer.isValid {
                exitTimer = Timer.scheduledTimer(
                    timeInterval: 1,
                    target: self,
                    selector: #selector(decrementSecond),
                    userInfo: nil,
                    repeats: true
                )
            }
        }

        guard !didTranslateStrings else {
            present()
            return
        }

        translateStrings { present() }
    }

    // MARK: - Auxiliary

    @objc
    private func decrementSecond() {
        remainingSeconds -= 1

        guard remainingSeconds < 0 else {
            let decrementString = String(format: "%02d", remainingSeconds)
            expiryMessage = "\(expiryMessage.components(separatedBy: ":")[0]): 00:\(decrementString)"
            setAttributedExpiryMessage()
            return
        }

        exitTimer?.invalidate()
        exitTimer = nil

        core.ui.dismissAlertController()

        AKAlert(
            title: timeExpiredTitle,
            message: timeExpiredMessage,
            showsCancelButton: false
        ).present()

        core.gcd.after(.seconds(5)) { fatalError("Evaluation period ended") }
    }

    private func setAttributedExpiryMessage() {
        let alternateAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red,
                                                                  .font: UIFont.systemFont(ofSize: 17)]

        let messageComponents = expiryMessage.components(separatedBy: ":")
        let attributeRange = messageComponents[1 ... messageComponents.count - 1].joined(separator: ":")

        let attributedMessage = expiryMessage.attributed(
            mainAttributes: [.font: UIFont.systemFont(ofSize: 13)],
            alternateAttributes: alternateAttributes,
            alternateAttributeRange: [attributeRange]
        )

        expiryAlertController.setValue(attributedMessage, forKey: "attributedMessage")
    }

    private func translateStrings(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        var leftDispatchGroup = false

        var inputsToTranslate: [AlertKit.TranslationInput] = [
            .init(expiryTitle),
            .init(expiryMessage),
            .init(continueUseString),
            .init(incorrectCodeTitle),
            .init(incorrectCodeMessage),
            .init(tryAgainString),
            .init(exitApplicationString),
            .init(timeExpiredTitle),
            .init(timeExpiredMessage),
        ]

        inputsToTranslate = inputsToTranslate.filter { $0.value().lowercasedTrimmingWhitespaceAndNewlines != "" }
        dispatchGroup.enter()
        akCore.translationDelegate().getTranslations(
            for: inputsToTranslate,
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
