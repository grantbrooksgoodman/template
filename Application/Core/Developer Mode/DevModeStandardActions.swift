//
//  DevModeStandardActions.swift
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

public extension DevModeAction {
    enum Standard {
        
        // MARK: - Available Actions Getter
        
        public static var available: [DevModeAction] {
            var availableActions: [DevModeAction] = [.Standard.toggleBuildInfoOverlayAction,
                                                     .Standard.overrideLanguageCodeAction,
                                                     .Standard.resetUserDefaultsAction,
                                                     .Standard.disableDeveloperModeAction]
            guard AppTheme.allCases.count > 1 else { return availableActions }
            availableActions.insert(.Standard.changeThemeAction, at: 0)
            return availableActions
        }
        
        // MARK: - Standard Actions
        
        public static var changeThemeAction: DevModeAction {
            func changeTheme() {
                var actions = [AKAction]()
                var actionIDs = [Int: String]()
                
                for `case` in AppTheme.allCases where `case`.theme.name != ThemeService.currentTheme.name {
                    let action = AKAction(title: `case`.theme.name, style: .default)
                    actions.append(action)
                    actionIDs[action.identifier] = `case`.theme.name
                }
                
                AKActionSheet(message: "Change Theme",
                              actions: actions,
                              shouldTranslate: [.none]).present { actionID in
                    guard actionID != -1,
                          let themeName = actionIDs[actionID],
                          let correspondingCase = AppTheme.allCases.first(where: { $0.theme.name == themeName }) else { return }
                    
                    ThemeService.setTheme(correspondingCase.theme, checkStyle: false)
                }
            }
            
            return .init(title: "Change Theme", perform: changeTheme)
        }
        
        public static var disableDeveloperModeAction: DevModeAction {
            return .init(title: "Disable Developer Mode",
                         perform: DevModeService.promptToToggle,
                         isDestructive: true)
        }
        
        public static var overrideLanguageCodeAction: DevModeAction {
            @Dependency(\.alertKitCore) var akCore: AKCore
            
            func setLanguageCode(_ code: String) {
                guard akCore.languageCodeIsLocked else {
                    akCore.lockLanguageCode(to: code)
                    return
                }
                
                akCore.unlockLanguageCode(andSetTo: code)
            }
            
            func overrideLanguageCode() {
                @Dependency(\.coreKit.hud) var coreHUD: CoreKit.HUD
                
                setLanguageCode("en")
                let languageCodePrompt = AKTextFieldAlert(title: "Override Language Code",
                                                          message: "Enter the two-letter code of the language to apply:",
                                                          actions: [AKAction(title: "Done", style: .preferred)],
                                                          textFieldAttributes: [.placeholderText: "en",
                                                                                .capitalizationType: UITextAutocapitalizationType.none,
                                                                                .correctionType: UITextAutocorrectionType.no,
                                                                                .textAlignment: NSTextAlignment.center],
                                                          shouldTranslate: [.none],
                                                          networkDependent: true)
                
                languageCodePrompt.presentTextFieldAlert { inputString, actionID in
                    akCore.unlockLanguageCode()
                    guard actionID != -1 else { return }
                    guard let inputString,
                          inputString.lowercasedTrimmingWhitespace != "" else {
                        setLanguageCode("en")
                        AKConfirmationAlert(title: "Override Language Code",
                                            message: "No input was entered.\n\nWould you like to try again?",
                                            cancelConfirmTitles: (cancel: nil, confirm: "Try Again"),
                                            confirmationStyle: .preferred,
                                            shouldTranslate: [.none]).present { didConfirm in
                            akCore.unlockLanguageCode()
                            guard didConfirm == 1 else { return }
                            overrideLanguageCode()
                        }
                        
                        return
                    }
                    
                    guard let languageCodes = RuntimeStorage.languageCodeDictionary,
                          languageCodes.keys.contains(inputString.lowercasedTrimmingWhitespace) else {
                        setLanguageCode("en")
                        AKConfirmationAlert(title: "Override Language Code",
                                            message: "The language code entered was invalid. Please try again.",
                                            cancelConfirmTitles: (cancel: nil, confirm: "Try Again"),
                                            confirmationStyle: .preferred,
                                            shouldTranslate: [.none]).present { didConfirm in
                            akCore.unlockLanguageCode()
                            guard didConfirm == 1 else { return }
                            overrideLanguageCode()
                        }
                        
                        return
                    }
                    
                    RuntimeStorage.store(inputString, as: .languageCode)
                    RuntimeStorage.store(inputString, as: .overriddenLanguageCode)
                    
                    setLanguageCode(inputString)
                    coreHUD.showSuccess()
                }
            }
            
            return .init(title: "Override Language Code", perform: overrideLanguageCode)
        }
        
        public static var resetUserDefaultsAction: DevModeAction {
            func resetUserDefaults() {
                @Dependency(\.coreKit.hud) var coreHUD: CoreKit.HUD
                @Dependency(\.userDefaults) var defaults: UserDefaults
                
                defaults.reset(keeping: [.currentTheme,
                                         .developerModeEnabled,
                                         .hidesBuildInfoOverlay])
                defaults.set(true, forKey: .developerModeEnabled)
                coreHUD.showSuccess(text: "Reset UserDefaults")
            }
            
            return .init(title: "Reset UserDefaults", perform: resetUserDefaults)
        }
        
        public static var toggleBuildInfoOverlayAction: DevModeAction {
            func toggleBuildInfoOverlay() {
                @Dependency(\.userDefaults) var defaults: UserDefaults
                
                guard let overlayWindow = RuntimeStorage.topWindow?.firstSubview(for: "BUILD_INFO_OVERLAY_WINDOW") as? UIWindow else { return }
                
                guard let currentValue = defaults.value(forKey: .hidesBuildInfoOverlay) as? Bool else {
                    overlayWindow.isHidden.toggle()
                    defaults.set(overlayWindow.isHidden, forKey: .hidesBuildInfoOverlay)
                    return
                }
                
                let toggledValue = !currentValue
                overlayWindow.isHidden = toggledValue
                defaults.set(toggledValue, forKey: .hidesBuildInfoOverlay)
            }
            
            return .init(title: "Show/Hide Build Info Overlay", perform: toggleBuildInfoOverlay)
        }
    }
}