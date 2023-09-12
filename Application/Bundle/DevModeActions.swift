//
//  DevModeActions.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import AlertKit
import Redux

/**
 Use this extension to add actions to the Developer Mode menu.
 */
public extension DevModeService {
    
    // MARK: - Standard Action Addition Method
    
    static func addStandardActions() {
        let changeThemeAction = DevModeAction(title: "Change Theme", perform: changeTheme)
        let toggleBuildInfoOverlayAction = DevModeAction(title: "Show/Hide Build Info Overlay", perform: toggleBuildInfoOverlay)
        let overrideLanguageCodeAction = DevModeAction(title: "Override Language Code", perform: overrideLanguageCode)
        let resetUserDefaultsAction = DevModeAction(title: "Reset UserDefaults", perform: resetUserDefaults)
        let disableDeveloperModeAction = DevModeAction(title: "Disable Developer Mode",
                                                       perform: promptToToggle,
                                                       isDestructive: true)
        
        var standardActions = [toggleBuildInfoOverlayAction,
                               overrideLanguageCodeAction,
                               resetUserDefaultsAction,
                               disableDeveloperModeAction]
        
        if AppTheme.allCases.count > 1 {
            standardActions.insert(changeThemeAction, at: 0)
        }
        
        addActions(standardActions)
    }
    
    // MARK: - Action Handlers
    
    private static func changeTheme() {
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
    
    private static func overrideLanguageCode() {
        @Dependency(\.alertKitCore) var akCore: AKCore
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
                    self.overrideLanguageCode()
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
                    self.overrideLanguageCode()
                }
                
                return
            }
            
            RuntimeStorage.store(inputString, as: .languageCode)
            RuntimeStorage.store(inputString, as: .overriddenLanguageCode)
            
            setLanguageCode(inputString)
            coreHUD.showSuccess()
        }
    }
    
    private static func resetUserDefaults() {
        @Dependency(\.coreKit.hud) var coreHUD: CoreKit.HUD
        @Dependency(\.userDefaults) var defaults: UserDefaults
        
        defaults.reset(keeping: [.currentTheme,
                                 .developerModeEnabled,
                                 .hidesBuildInfoOverlay])
        defaults.set(true, forKey: .developerModeEnabled)
        coreHUD.showSuccess(text: "Reset UserDefaults")
    }
    
    private static func toggleBuildInfoOverlay() {
        @Dependency(\.userDefaults) var defaults: UserDefaults
        
        guard let overlay = RuntimeStorage.topWindow?.firstSubview(for: "BUILD_INFO_OVERLAY_WINDOW") as? UIWindow else { return }
        
        guard let currentValue = defaults.value(forKey: .hidesBuildInfoOverlay) as? Bool else {
            overlay.isHidden.toggle()
            defaults.set(overlay.isHidden, forKey: .hidesBuildInfoOverlay)
            return
        }
        
        let toggledValue = !currentValue
        overlay.isHidden = toggledValue
        defaults.set(toggledValue, forKey: .hidesBuildInfoOverlay)
    }
    
    // MARK: - Auxiliary
    
    private static func setLanguageCode(_ code: String) {
        @Dependency(\.alertKitCore) var akCore: AKCore
        
        guard akCore.languageCodeIsLocked else {
            akCore.lockLanguageCode(to: code)
            return
        }
        
        akCore.unlockLanguageCode(andSetTo: code)
    }
}
