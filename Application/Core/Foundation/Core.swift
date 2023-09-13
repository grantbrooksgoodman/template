//
//  CoreKit.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import AlertKit
import ProgressHUD
import Redux

public struct CoreKit {
    
    // MARK: - Properties
    
    public let gcd: GCD
    public let hud: HUD
    public let ui: UI
    public let utils: Utilities
    
    // MARK: - Init
    
    public init(gcd: GCD,
                hud: HUD,
                ui: UI,
                utils: Utilities) {
        self.gcd = gcd
        self.hud = hud
        self.ui = ui
        self.utils = utils
    }
    
    // MARK: - Core GCD
    
    public struct GCD {
        public func after(milliseconds: Int, do: @escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds)) {
                `do`()
            }
        }
        
        public func after(seconds: Int, do: @escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
                `do`()
            }
        }
    }
    
    // MARK: - Core HUD
    
    public struct HUD {
        /* MARK: Properties */
        
        public enum HUDImage {
            case success
            case exclamation
        }
        
        /* MARK: Methods */
        
        public func flash(_ text: String, image: HUDImage) {
            var alertIcon: AlertIcon?
            var animatedIcon: AnimatedIcon?
            
            switch image {
            case .success:
                animatedIcon = .succeed
            case .exclamation:
                alertIcon = .exclamation
            }
            
            var text = text
            if text.hasSuffix(".") {
                text = text.dropSuffix()
            }
            
            guard let alertIcon else {
                guard let animatedIcon else { return }
                DispatchQueue.main.async { ProgressHUD.show(text, icon: animatedIcon, interaction: true) }
                return
            }
            
            DispatchQueue.main.async { ProgressHUD.show(text, icon: alertIcon, interaction: true) }
        }
        
        public func hide(delay: Double? = nil) {
            let gcd: GCD = .init()
            
            guard let delay = delay else {
                ProgressHUD.dismiss()
                gcd.after(milliseconds: 250) { ProgressHUD.remove() }
                return
            }
            
            let millisecondDelay = Int(delay * 1000)
            gcd.after(milliseconds: millisecondDelay) {
                ProgressHUD.dismiss()
                gcd.after(milliseconds: 250) { ProgressHUD.remove() }
            }
        }
        
        public func showProgress(delay: Double? = nil, text: String? = nil) {
            guard let delay = delay else {
                DispatchQueue.main.async {
                    ProgressHUD.show(text ?? nil)
                }
                
                return
            }
            
            let millisecondDelay = Int(delay * 1000)
            GCD().after(milliseconds: millisecondDelay) {
                ProgressHUD.show(text ?? nil)
            }
        }
        
        public func showSuccess(text: String? = nil) {
            DispatchQueue.main.async { ProgressHUD.showSucceed(text) }
        }
    }
    
    // MARK: - Core UI
    
    public struct UI {
        /* MARK: Dependencies */
        
        @Dependency(\.uiApplication) private var uiApplication: UIApplication
        
        /* MARK: Properties */
        
        public var isPresentingAlertController: Bool {
            guard let keyVC = uiApplication.keyViewController,
                  keyVC.isKind(of: UIAlertController.self) else { return false }
            return true
        }
        
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
            DispatchQueue.main.async { firstResponder.resignFirstResponder() }
        }
        
        /* MARK: Navigation Bar Appearance */
        
        public func resetNavigationBarAppearance() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        public func setNavigationBarAppearance(backgroundColor: UIColor,
                                               titleColor: UIColor) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = backgroundColor
            
            appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
            appearance.titleTextAttributes = [.foregroundColor: titleColor]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        /* MARK: View Controller Presentation */
        
        public func dismissAlertController(animated: Bool = true) {
            guard isPresentingAlertController else { return }
            uiApplication.keyViewController?.dismiss(animated: animated)
        }
        
        /// - Parameter embedded: Pass `true` to embed the given view controller inside a `UINavigationController`.
        public func present(_ viewController: UIViewController,
                            animated: Bool = true,
                            embedded: Bool = false) {
            queuePresentation(of: viewController, animated: animated, embedded: embedded)
        }
        
        private func queuePresentation(of viewController: UIViewController,
                                       animated: Bool,
                                       embedded: Bool) {
            HUD().hide()
            
            let keyVC = uiApplication.keyViewController
            func present() {
                guard embedded else {
                    keyVC?.present(viewController, animated: animated)
                    return
                }
                
                keyVC?.present(UINavigationController(rootViewController: viewController), animated: animated)
            }
            
            guard !isPresentingAlertController else {
                GCD().after(seconds: 1) {
                    queuePresentation(of: viewController, animated: animated, embedded: embedded)
                }
                return
            }
            
            guard Thread.isMainThread else {
                DispatchQueue.main.sync {
                    present()
                }
                return
            }
            
            present()
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
            guard let languageCode = RuntimeStorage.languageCode,
                  let languageCodeDictionary = RuntimeStorage.languageCodeDictionary else { return nil }
            
            let locale = Locale(identifier: languageCode)
            
            var localizedNames = [String: String]()
            for (code, name) in languageCodeDictionary {
                guard let localizedName = locale.localizedString(forLanguageCode: code) else {
                    localizedNames[code] = name
                    continue
                }
                
                let components = name.components(separatedBy: "(")
                guard components.count == 2 else {
                    let suffix = localizedName.lowercased() == name.lowercased() ? "" : "(\(name))"
                    localizedNames[code] = "\(localizedName.firstUppercase) \(suffix)"
                    continue
                }
                
                let endonym = components[1]
                let suffix = localizedName.lowercased() == endonym.lowercased().dropSuffix() ? "" : "(\(endonym)"
                localizedNames[code] = "\(localizedName.firstUppercase) \(suffix)"
            }
            
            return localizedNames
        }
        
        /* MARK: Methods */
        
        @discardableResult
        public func restoreDeviceLanguageCode() -> Exception? {
            @Dependency(\.alertKitCore) var akCore: AKCore
            
            let preferredLanguages = Locale.preferredLanguages
            guard !preferredLanguages.isEmpty else {
                return .init("No preferred languages.", metadata: [#file, #function, #line])
            }
            
            let components = preferredLanguages[0].components(separatedBy: "-")
            guard !components.isEmpty else {
                return .init("No language separator key.", metadata: [#file, #function, #line])
            }
            
            RuntimeStorage.store(components[0], as: .languageCode)
            
            guard !akCore.languageCodeIsLocked else {
                akCore.unlockLanguageCode(andSetTo: components[0])
                return nil
            }
            
            akCore.setLanguageCode(components[0])
            return nil
        }
    }
}
