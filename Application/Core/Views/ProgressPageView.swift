//
//  ProgressPageView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

public struct ProgressPageView: View {
    // MARK: - View

    public var body: some View {
        ThemedView {
            ProgressView()
                .dynamicTypeSize(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
                .interactivePopGestureRecognizerDisabled()
        }
    }
}
