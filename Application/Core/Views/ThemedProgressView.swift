//
//  ThemedProgressView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* First-party Frameworks */
import Foundation
import SwiftUI

/* Third-party Frameworks */
import Redux

public struct ThemedProgressView: View {
    // MARK: - View

    public var body: some View {
        ThemedView {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
        }
    }
}
