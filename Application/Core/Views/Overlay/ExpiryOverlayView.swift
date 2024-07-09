//
//  ExpiryOverlayView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import AlertKit
import CoreArchitecture

public struct ExpiryOverlayView: View {
    // MARK: - Dependencies

    @Dependency(\.coreKit.gcd) private var coreGCD: CoreKit.GCD

    // MARK: - View

    public var body: some View {
        VStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            coreGCD.after(.milliseconds(1500)) {
                Task { await BuildExpiryAlert.present() }
            }
        }
    }
}
