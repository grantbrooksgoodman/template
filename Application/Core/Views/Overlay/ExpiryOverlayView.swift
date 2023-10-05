//
//  ExpiryOverlayView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import SwiftUI

/* 3rd-party */
import AlertKit
import Redux

public struct ExpiryOverlayView: View {
    // MARK: - Dependencies

    @Dependency(\.alertKitCore) private var akCore: AKCore
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
                akCore.present(.expiryAlert)
            }
        }
    }
}
