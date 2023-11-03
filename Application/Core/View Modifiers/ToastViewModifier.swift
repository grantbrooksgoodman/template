//
//  ToastViewModifier.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

private struct ToastViewModifier: ViewModifier {
    // MARK: - Constants Accessors

    private typealias Floats = CoreConstants.CGFloats.ToastView

    // MARK: - Dependencies

    @Dependency(\.coreKit.gcd) private var coreGCD: CoreKit.GCD

    // MARK: - Properties

    @State private var dismissWorkItem: DispatchWorkItem?
    private var onTap: (() -> Void)?
    @Binding private var toast: Toast?

    // MARK: - Init

    public init(_ toast: Binding<Toast?>, onTap: (() -> Void)?) {
        _toast = toast
        self.onTap = onTap
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    toastView
                        .offset(y: toast?.type.appearanceEdge == .bottom ? Floats.bottomAppearanceEdgeYOffset : Floats.topAppearanceEdgeYOffset)
                        .onSwipe(toast?.type.appearanceEdge == .bottom ? .down : .up) {
                            dismiss()
                        }
                }
                .animation(.spring(), value: toast)
            )
            .onChange(of: toast) { _ in
                present()
            }
    }

    @ViewBuilder
    private var toastView: some View {
        if let toast {
            VStack {
                if toast.type.appearanceEdge == .bottom {
                    Spacer()
                }

                ToastView(
                    toast.type,
                    title: toast.title,
                    message: toast.message,
                    onTap: onTap
                ) {
                    dismiss()
                }

                if toast.type.appearanceEdge == .top {
                    Spacer()
                }
            }
            .transition(.move(edge: toast.type.appearanceEdge == .bottom ? .bottom : .top))
        }
    }

    // MARK: - Auxiliary

    private func dismiss() {
        withAnimation { toast = nil }

        dismissWorkItem?.cancel()
        dismissWorkItem = nil
    }

    private func present() {
        guard let toast else { return }

        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        dismissWorkItem?.cancel()

        switch toast.perpetuation {
        case let .ephemeral(duration):
            let dismissTask: DispatchWorkItem = .init { dismiss() }
            dismissWorkItem = dismissTask
            coreGCD.after(duration) { dismissTask.perform() }
        default: ()
        }
    }
}

public extension View {
    func toast(_ toast: Binding<Toast?>, onTap: (() -> Void)? = nil) -> some View {
        modifier(ToastViewModifier(toast, onTap: onTap))
    }
}
