//
//  AKConnectionAlertDelegate.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import UIKit

/* 3rd-party */
import AlertKit
import Redux

public class ConnectionAlertDelegate: AKConnectionAlertDelegate {
    // MARK: - AKConnectionAlertDelegate Conformance

    public func presentConnectionAlert() {
        @Dependency(\.build) var build: Build
        @Dependency(\.uiApplication) var uiApplication: UIApplication

        let exception = Exception(
            "The internet connection is offline.",
            isReportable: false,
            extraParams: ["IsConnected": build.isOnline],
            metadata: [self, #file, #function, #line]
        )

        var settingsURL: URL?
        var actions = [AKAction]()

        @Localized(.settings) var settingsString: String

        if let asURL = URL(string: massageRedirectionKey("oddUdfstgb")),
           uiApplication.canOpenURL(asURL) {
            settingsURL = asURL
            actions.append(AKAction(title: settingsString, style: .default))
        }

        @Localized(.noInternetMessage) var noInternetMessage: String
        let errorAlert = AKErrorAlert(
            message: noInternetMessage,
            error: .init(exception),
            actions: actions.isEmpty ? nil : actions,
            cancelButtonTitle: "OK",
            shouldTranslate: [.none]
        )

        errorAlert.present { actionID in
            guard actionID == errorAlert.actions.first(where: { $0.title == settingsString })?.identifier,
                  let settingsURL else { return }
            uiApplication.open(settingsURL)
        }
    }

    // MARK: - Auxiliary

    private func massageRedirectionKey(_ string: String) -> String {
        var lowercasedString = string.lowercased().ciphered(by: 12)
        lowercasedString = lowercasedString.replacingOccurrences(of: "g", with: "-")
        lowercasedString = lowercasedString.replacingOccurrences(of: "n", with: ":")

        var capitalizedCharacters = [String]()
        for (index, character) in lowercasedString.components.enumerated() {
            let finalCharacter = (index == 0 || index == 4) ? character.uppercased() : character
            capitalizedCharacters.append(finalCharacter)
        }

        return capitalizedCharacters.joined()
    }
}
