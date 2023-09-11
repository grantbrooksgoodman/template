//
//  ThemedView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

public struct ThemedView: View {
    
    // MARK: - Dependencies
    
    @ObservedDependency(\.colorProvider) private var colorProvider: ColorProvider
    @Dependency(\.coreKit.ui) private var coreUI: CoreKit.UI
    
    // MARK: - Properties
    
    @State public var onAppearanceChange: (()->())? = nil
    public var reloadsForUpdates = false
    public var viewBody: (()->(any View))
    
    @State private var forceAppearanceUpdate = UUID()
    
    // MARK: - View
    
    public var body: some View {
        AnyView(viewBody())
            .id(forceAppearanceUpdate)
            .onChange(of: colorProvider.currentThemeName) { _ in respondToAppearanceChange() }
            .onChange(of: colorProvider.interfaceStyle) { _ in respondToAppearanceChange() }
    }
    
    // MARK: - Appearance Change Handler
    
    private func respondToAppearanceChange() {
        colorProvider.updateColorState()
        coreUI.setNavigationBarAppearance(backgroundColor: .navigationBarBackground,
                                          titleColor: .navigationBarTitle)
        
        onAppearanceChange?()
        
        guard reloadsForUpdates else { return }
        forceAppearanceUpdate = UUID()
    }
}

