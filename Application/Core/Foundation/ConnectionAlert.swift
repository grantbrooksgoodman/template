//
//  ConnectionAlert.swift
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

public enum ConnectionAlert {
    // MARK: - Present

    @MainActor
    public static func present() async {
        @Dependency(\.build) var build: Build
        @Dependency(\.uiApplication) var uiApplication: UIApplication

        var actions: [AKAction] = [.cancelAction(title: "OK")]
        if let settingsURL = URL(string: massageRedirectionKey("oddUdfstgb")),
           uiApplication.canOpenURL(settingsURL) {
            @Localized(.settings) var settingsString: String
            let settingsAction: AKAction = .init(settingsString) { uiApplication.open(settingsURL) }
            actions.append(settingsAction)
        }

        @Localized(.noInternetMessage) var noInternetMessage: String
        await AKAlert(
            message: noInternetMessage,
            actions: actions
        ).present(translating: [])
    }

    // MARK: - Auxiliary

    private static func massageRedirectionKey(_ string: String) -> String {
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
