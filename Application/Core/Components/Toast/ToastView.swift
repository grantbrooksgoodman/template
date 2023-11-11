//
//  ToastView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

/* 3rd-party */
import Redux

public struct ToastView: View {
    // MARK: - Constants Accessors

    private typealias Colors = CoreConstants.Colors.ToastView
    private typealias Floats = CoreConstants.CGFloats.ToastView
    private typealias Strings = CoreConstants.Strings.ToastView

    // MARK: - Dependencies

    @Dependency(\.uiSelectionFeedbackGenerator) var uiSelectionFeedbackGenerator: UISelectionFeedbackGenerator

    // MARK: - Properties

    // Closure
    private let onDismiss: () -> Void
    private let onTap: (() -> Void)?

    // String
    private let message: String
    private let title: String?

    // Other
    private let type: Toast.ToastType

    // MARK: - Init

    public init(
        _ type: Toast.ToastType,
        title: String? = nil,
        message: String,
        onTap: (() -> Void)?,
        onDismiss: @escaping () -> Void
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.onTap = onTap
        self.onDismiss = onDismiss
    }

    // MARK: - Body

    public var body: some View {
        switch type {
        case let .banner(style: style, appearanceEdge: appearanceEdge, colorPalette: colorPalette):
            bannerContentView(style: style, appearanceEdge: appearanceEdge, colorPalette: colorPalette)

        case let .capsule(style: style):
            capsuleContentView(style: style)
            Spacer()
        }
    }

    // MARK: - Banner Content View

    private func bannerContentView(
        style: Toast.Style,
        appearanceEdge: Toast.AppearanceEdge,
        colorPalette: Toast.ColorPalette?
    ) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: title == nil ? .center : .top) {
                if let iconSystemImageName = style.bannerIconSystemImageName,
                   let defaultColor = style.defaultColor {
                    Image(systemName: iconSystemImageName)
                        .foregroundColor(colorPalette?.accent ?? defaultColor)
                }

                let labelView = VStack(alignment: .leading) {
                    if let title {
                        Text(title)
                            .font(.sanFrancisco(.semibold, size: Floats.bannerTitleLabelFontSize))
                            .foregroundStyle(colorPalette?.text ?? .titleText.opacity(Floats.bannerTitleLabelForegroundColorOpacity))
                    }

                    Text(message)
                        .font(.sanFrancisco(title == nil ? .semibold : .regular, size: Floats.bannerMessageLabelFontSize))
                        .foregroundStyle(colorPalette?.text ?? .titleText.opacity(Floats.bannerMessageLabelForegroundColorOpacity))
                }

                if let onTap {
                    Button {
                        vibrate()
                        onTap()
                        onDismiss()
                    } label: {
                        labelView
                    }
                } else {
                    labelView
                }

                Spacer(minLength: Floats.bannerSpacerMinLength)

                Button {
                    onDismiss()
                } label: {
                    Image(systemName: Strings.bannerDismissButtonImageSystemName)
                        .foregroundStyle(colorPalette?.dismissButton ?? .titleText.opacity(Floats.bannerDismissButtonForegroundColorOpacity))
                }
            }
            .padding()
        }
        .background(colorPalette?.background ?? .navigationBarBackground)
        .frame(maxWidth: .infinity)
        .overlay(
            overlay(colorPalette?.accent ?? style.defaultColor),
            alignment: .leading
        )
        .cornerRadius(Floats.bannerCornerRadius)
        .shadow(
            color: Colors.bannerShadowColor.opacity(Floats.bannerShadowColorOpacity),
            radius: Floats.bannerShadowRadius,
            x: Floats.bannerShadowX,
            y: Floats.bannerShadowY
        )
        .padding(.horizontal, Floats.bannerHorizontalPadding)
    }

    // MARK: - Capsule Content View

    private func capsuleContentView(style: Toast.Style) -> some View {
        VStack {
            let labelView = HStack {
                if let iconSystemImageName = style.capsuleIconSystemImageName,
                   let defaultColor = style.defaultColor {
                    Image(systemName: iconSystemImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            maxWidth: Floats.capsuleImageFrameMaxWidth,
                            maxHeight: Floats.capsuleImageFrameMaxHeight,
                            alignment: .center
                        )
                        .foregroundColor(defaultColor)
                }

                if let title {
                    VStack(alignment: style.capsuleIconSystemImageName == nil ? .center : .leading) {
                        Text(title)
                            .font(.sanFrancisco(.semibold, size: Floats.capsuleTitleLabelFontSize))
                            .foregroundStyle(Color.titleText)

                        Text(message)
                            .font(.sanFrancisco(size: Floats.capsuleMessageLabelFontSize))
                            .foregroundStyle(Colors.capsuleMessageLabelForeground)
                    }
                } else {
                    Text(message)
                        .font(.sanFrancisco(.semibold, size: Floats.capsuleTitleLabelFontSize))
                        .foregroundStyle(Color.titleText)
                        .padding(.horizontal, Floats.capsuleMessageLabelHorizontalPadding)
                        .padding(.vertical, Floats.capsuleMessageLabelVerticalPadding)
                }
            }

            if let onTap {
                Button {
                    vibrate()
                    onTap()
                    onDismiss()
                } label: {
                    labelView
                }
            } else {
                labelView
                    .onTapGesture {
                        onDismiss()
                    }
            }
        }
        .padding(.horizontal, Floats.capsulePrimaryHorizontalPadding)
        .padding(.vertical, Floats.capsuleVerticalPadding)
        .background(Color.navigationBarBackground)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(
                    Colors.capsuleOverlayStroke.opacity(Floats.capsuleOverlayStrokeColorOpacity),
                    lineWidth: Floats.capsuleOverlayStrokeLineWidth
                )
        )
        .frame(maxWidth: .infinity)
        .shadow(
            color: Colors.capsuleShadowColor.opacity(Floats.capsuleShadowColorOpacity),
            radius: Floats.capsuleShadowRadius,
            x: Floats.capsuleShadowX,
            y: Floats.capsuleShadowY
        )
        .padding(.horizontal, Floats.capsuleSecondaryHorizontalPadding)
    }

    // MARK: - Overlay

    private func overlay(_ fillColor: Color?) -> some View {
        if let fillColor {
            return AnyView(
                Rectangle()
                    .fill(fillColor)
                    .frame(width: Floats.bannerOverlayFrameWidth)
                    .clipped(antialiased: true)
            )
        }

        return AnyView(EmptyView())
    }

    // MARK: - Auxiliary

    private func vibrate() {
        uiSelectionFeedbackGenerator.selectionChanged()
    }
}

/* MARK: UISelectionFeedbackGenerator Dependency */

private enum UISelectionFeedbackGeneratorDependency: DependencyKey {
    public static func resolve(_ dependencies: DependencyValues) -> UISelectionFeedbackGenerator {
        .init()
    }
}

private extension DependencyValues {
    var uiSelectionFeedbackGenerator: UISelectionFeedbackGenerator {
        get { self[UISelectionFeedbackGeneratorDependency.self] }
        set { self[UISelectionFeedbackGeneratorDependency.self] = newValue }
    }
}
