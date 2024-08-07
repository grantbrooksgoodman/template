//
//  Core.swift
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

public struct CoreKit {
    // MARK: - Properties

    public let gcd: GCD
    public let hud: HUD
    public let ui: UI
    public let utils: Utilities

    // MARK: - Init

    public init(
        gcd: GCD,
        hud: HUD,
        ui: UI,
        utils: Utilities
    ) {
        self.gcd = gcd
        self.hud = hud
        self.ui = ui
        self.utils = utils
    }

    // MARK: - Core GCD

    public struct GCD {
        /* MARK: Dependencies */

        @Dependency(\.mainQueue) private var mainQueue: DispatchQueue

        /* MARK: Methods */

        public func after(_ duration: Duration, do effect: @escaping () -> Void) {
            mainQueue.asyncAfter(deadline: .now() + .milliseconds(.init(duration.milliseconds))) {
                effect()
            }
        }
    }

    // MARK: - Core HUD

    public struct HUD {
        /* MARK: Types */

        public enum HUDImage {
            case success
            case exclamation
        }

        /* MARK: Dependencies */

        @Dependency(\.uiApplication.keyWindow) private var keyWindow: UIWindow?
        @Dependency(\.mainQueue) private var mainQueue: DispatchQueue

        /* MARK: Methods */

        public func flash(_ text: String? = nil, image: HUDImage) {
            var alertIcon: AlertIcon?
            var animatedIcon: AnimatedIcon?

            switch image {
            case .success:
                animatedIcon = .succeed
            case .exclamation:
                alertIcon = .exclamation
            }

            var resolvedText = text
            if let text,
               text.hasSuffix(".") {
                resolvedText = text.dropSuffix()
            }

            guard let alertIcon else {
                guard let animatedIcon else { return }
                mainQueue.async { ProgressHUD.show(resolvedText, icon: animatedIcon, interaction: true) }
                return
            }

            mainQueue.async { ProgressHUD.show(resolvedText, icon: alertIcon, interaction: true) }
        }

        public func hide(after delay: Duration? = nil) {
            mainQueue.async {
                let gcd: GCD = .init()

                func hideHUD() {
                    keyWindow?.isUserInteractionEnabled = true
                    ProgressHUD.dismiss()
                    gcd.after(.milliseconds(250)) { ProgressHUD.remove() }
                }

                guard let delay else { return hideHUD() }
                gcd.after(delay) { hideHUD() }
            }
        }

        public func showProgress(
            text: String? = nil,
            after delay: Duration? = nil,
            isModal: Bool = false
        ) {
            mainQueue.async {
                func showHUD() {
                    ProgressHUD.show(text)
                    guard isModal else { return }
                    keyWindow?.isUserInteractionEnabled = false
                }

                guard let delay else { return showHUD() }
                GCD().after(delay) { showHUD() }
            }
        }

        public func showSuccess(text: String? = nil) {
            mainQueue.async {
                ProgressHUD.showSucceed(text)
            }
        }
    }

    // MARK: - Core UI

    public struct UI {
        /* MARK: Dependencies */

        @Dependency(\.mainQueue) private var mainQueue: DispatchQueue
        @Dependency(\.uiApplication) private var uiApplication: UIApplication

        /* MARK: First Responder */

        public func firstResponder(in view: UIView? = nil) -> UIView? {
            guard let view = view ?? uiApplication.keyViewController?.view else { return nil }
            guard !view.isFirstResponder else { return view }

            for subview in view.subviews {
                guard !subview.isFirstResponder else { return subview }
                guard let recursiveSubview = firstResponder(in: subview) else { continue }
                return recursiveSubview
            }

            return nil
        }

        public func resignFirstResponder(in view: UIView? = nil) {
            guard let view = view ?? uiApplication.keyViewController?.view,
                  let firstResponder = firstResponder(in: view) else { return }
            Task { @MainActor in
                firstResponder.resignFirstResponder()
            }
        }

        /* MARK: View Controller Presentation */

        // Public
        public func dismissAlertController(animated: Bool = true) {
            guard uiApplication.isPresentingAlertController else { return }
            uiApplication.keyViewController?.dismiss(animated: animated)
        }

        /// - Parameter embedded: Pass `true` to embed the given view controller inside a `UINavigationController`.
        public func present(
            _ viewController: UIViewController,
            animated: Bool = true,
            embedded: Bool = false,
            forced: Bool = false
        ) {
            func forcePresentation() {
                dismissAlertController()
                present(viewController, animated: animated, embedded: embedded)
            }

            guard !forced else {
                guard Thread.isMainThread else {
                    mainQueue.sync { forcePresentation() }
                    return
                }

                forcePresentation()
                return
            }

            queuePresentation(of: viewController, animated: animated, embedded: embedded)
        }

        public func overrideUserInterfaceStyle(_ style: UIUserInterfaceStyle) {
            uiApplication.keyWindow?.overrideUserInterfaceStyle = style
        }

        // Private
        private func present(
            _ viewController: UIViewController,
            animated: Bool,
            embedded: Bool
        ) {
            HUD().hide()

            let keyVC = uiApplication.keyViewController
            guard embedded else {
                keyVC?.present(viewController, animated: animated)
                return
            }

            keyVC?.present(UINavigationController(rootViewController: viewController), animated: animated)
        }

        private func queuePresentation(
            of viewController: UIViewController,
            animated: Bool,
            embedded: Bool
        ) {
            guard !uiApplication.isPresentingAlertController else {
                GCD().after(.seconds(1)) { queuePresentation(of: viewController, animated: animated, embedded: embedded) }
                return
            }

            guard Thread.isMainThread else {
                mainQueue.sync { present(viewController, animated: animated, embedded: embedded) }
                return
            }

            present(viewController, animated: animated, embedded: embedded)
        }

        /* MARK: View Tagging */

        /// Generates a semantic, integer-based identifier for a given view name.
        public func semTag(for viewName: String) -> Int {
            var float: Float = 1

            for (index, character) in viewName.components.enumerated() {
                guard let position = character.alphabeticalPosition else { continue }
                float += float / Float(position * (index + 1))
            }

            let rawString = String(float).removingOccurrences(of: ["."])
            guard let integer = Int(rawString) else { return Int(float) }
            return integer
        }
    }

    // MARK: - Core Utilities

    public struct Utilities {
        /* MARK: Properties */

        public var localizedLanguageCodeDictionary: [String: String]? {
            guard let languageCodeDictionary = RuntimeStorage.languageCodeDictionary else { return nil }

            let locale = Locale(languageCode: .init(RuntimeStorage.languageCode))

            return languageCodeDictionary.reduce(into: [String: String]()) { partialResult, keyPair in
                let code = keyPair.key
                let name = keyPair.value

                if let localizedName = locale.localizedString(forLanguageCode: code) {
                    let components = name.components(separatedBy: "(")
                    if components.count == 2 {
                        let endonym = components[1]
                        let suffix = localizedName.lowercased() == endonym.lowercased().dropSuffix() ? "" : "(\(endonym)"
                        partialResult[code] = "\(localizedName.firstUppercase) \(suffix)".trimmingBorderedWhitespace
                    } else {
                        let suffix = localizedName.lowercased() == name.lowercased() ? "" : "(\(name))"
                        partialResult[code] = "\(localizedName.firstUppercase) \(suffix)".trimmingBorderedWhitespace
                    }
                } else {
                    partialResult[code] = name.trimmingBorderedWhitespace
                }
            }
        }

        /* MARK: Methods */

        public func restoreDeviceLanguageCode() {
            setLanguageCode(BuildConfig.languageCode)
        }

        public func setLanguageCode(_ languageCode: String, override: Bool = false) {
            @Dependency(\.alertKitConfig) var alertKitConfig: AlertKit.Config

            alertKitConfig.overrideTargetLanguageCode(languageCode)
            RuntimeStorage.store(languageCode, as: .languageCode)
            Observables.languageCodeChanged.trigger()

            guard override else { return }
            RuntimeStorage.store(languageCode, as: .overriddenLanguageCode)
        }
    }
}
