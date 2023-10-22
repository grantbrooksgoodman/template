//
//  HeaderView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI
import UIKit

/* 3rd-party */
import Redux

public struct HeaderView: View {
    // MARK: - Types

    public enum CenterItemType {
        case image(ImageAttributes)
        case text(TextAttributes, subtitle: TextAttributes? = nil)
    }

    public enum PeripheralButtonType {
        case image(ImageButtonAttributes)
        case text(TextButtonAttributes)
    }

    // MARK: - Properties

    // Dependencies
    @Dependency(\.uiApplication) private var uiApplication: UIApplication

    // Property Wrappers
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    // PeripheralButtonType
    public let leftItem: PeripheralButtonType?
    public let rightItem: PeripheralButtonType?

    // Other
    public let centerItem: CenterItemType?
    public let isThemed: Bool

    // MARK: - Computed Properties

    private var centerItemImageMaxWidth: CGFloat {
        guard let mainScreen = uiApplication.mainScreen else { return 0 }
        return mainScreen.bounds.width / 3
    }

    // MARK: - Constants Accessors

    private typealias Colors = CoreConstants.Colors.HeaderView
    private typealias Floats = CoreConstants.CGFloats.HeaderView

    // MARK: - Init

    /// - Parameter isThemed: Pass `true` to override all color values to those of the system theme.
    public init(
        leftItem: PeripheralButtonType? = nil,
        centerItem: CenterItemType? = nil,
        rightItem: PeripheralButtonType? = nil,
        isThemed: Bool = false
    ) {
        self.leftItem = leftItem
        self.centerItem = centerItem
        self.rightItem = rightItem
        self.isThemed = isThemed
    }

    // MARK: - View

    public var body: some View {
        Group {
            if isThemed {
                Group {
                    ThemedView {
                        contentView
                    }

                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: Floats.separatorMaxHeight)
                        .foregroundStyle(colorScheme == .dark ? Colors.separatorDarkForeground : Colors.separatorLightForeground)
                        .padding(.top, Floats.separatorTopPadding)
                }
            } else {
                contentView
            }
        }
    }

    private var contentView: some View {
        ZStack {
            HStack {
                if let leftItem {
                    switch leftItem {
                    case let .image(imageButtonAttributes):
                        imageButton(imageButtonAttributes)

                    case let .text(textButtonAttributes):
                        textButton(textButtonAttributes)
                    }
                }

                Spacer()
            }

            VStack {
                if let centerItem {
                    switch centerItem {
                    case let .image(imageAttributes):
                        if let size = imageAttributes.size {
                            imageAttributes.image
                                .renderingMode(.template)
                                .resizable()
                                .foregroundStyle(isThemed ? .navigationBarTitle : imageAttributes.foregroundColor)
                                .frame(
                                    width: size.width > centerItemImageMaxWidth ? nil : size.width,
                                    height: size.height > Floats.centerItemImageMaxHeight ? nil : size.height
                                )
                                .frame(
                                    maxWidth: centerItemImageMaxWidth,
                                    maxHeight: Floats.centerItemImageMaxHeight,
                                    alignment: .center
                                )
                        } else {
                            imageAttributes.image
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(isThemed ? .navigationBarTitle : imageAttributes.foregroundColor)
                                .frame(
                                    maxWidth: centerItemImageMaxWidth,
                                    maxHeight: Floats.centerItemImageMaxHeight,
                                    alignment: .center
                                )
                        }

                    case let .text(titleAttributes, subtitle: subtitleAttributes):
                        Text(titleAttributes.string)
                            .font(titleAttributes.font)
                            .foregroundStyle(isThemed ? .navigationBarTitle : titleAttributes.foregroundColor)

                        if let subtitleAttributes {
                            Text(subtitleAttributes.string)
                                .font(subtitleAttributes.font)
                                .foregroundStyle(isThemed ? .navigationBarTitle : subtitleAttributes.foregroundColor)
                        }
                    }
                } else {
                    EmptyView()
                        .frame(alignment: .center)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Spacer()

                if let rightItem {
                    switch rightItem {
                    case let .image(imageButtonAttributes):
                        imageButton(imageButtonAttributes)

                    case let .text(textButtonAttributes):
                        textButton(textButtonAttributes)
                    }
                }
            }
        }
        .frame(minHeight: Floats.frameMinHeight)
        .padding(.horizontal, Floats.horizontalPadding)
    }

    private func imageButton(_ attributes: ImageButtonAttributes) -> some View {
        Button {
            attributes.action()
        } label: {
            if let size = attributes.image.size {
                attributes.image.image
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(isThemed ? .accent : attributes.image.foregroundColor)
                    .frame(width: size.width, height: size.height)
            } else {
                attributes.image.image
                    .foregroundStyle(isThemed ? .accent : attributes.image.foregroundColor)
            }
        }
    }

    private func textButton(_ attributes: TextButtonAttributes) -> some View {
        Button {
            attributes.action()
        } label: {
            Text(attributes.text.string)
                .font(attributes.text.font)
                .foregroundStyle(isThemed ? .accent : attributes.text.foregroundColor)
        }
    }
}
