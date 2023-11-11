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

    // MARK: - Constants Accessors

    private typealias Colors = CoreConstants.Colors.HeaderView
    private typealias Floats = CoreConstants.CGFloats.HeaderView

    // MARK: - Properties

    // Environment
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(\.keyWindowSize) private var keyWindowSize: CGSize

    // Instance
    public let centerItem: CenterItemType?
    public let isThemed: Bool
    public let leftItem: PeripheralButtonType?
    public let rightItem: PeripheralButtonType?

    // MARK: - Computed Properties

    private var centerItemImageMaxWidth: CGFloat { keyWindowSize.width / Floats.keyWindowSizeWidthDivisor }

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

    // MARK: - Body

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

    // MARK: - Content View

    private var contentView: some View {
        ZStack {
            HStack {
                if let leftItem {
                    peripheralButton(for: leftItem)
                }

                Spacer()
            }

            VStack {
                if let centerItem {
                    switch centerItem {
                    case let .image(imageAttributes):
                        centerImage(for: imageAttributes)

                    case let .text(titleAttributes, subtitle: subtitleAttributes):
                        centerText(for: titleAttributes)

                        if let subtitleAttributes {
                            centerText(for: subtitleAttributes)
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
                    peripheralButton(for: rightItem)
                }
            }
        }
        .frame(minHeight: Floats.frameMinHeight)
        .padding(.horizontal, Floats.horizontalPadding)
    }

    // MARK: - Center Image

    private func centerImage(for attributes: ImageAttributes) -> some View {
        let image = attributes.image
            .renderingMode(.template)
            .resizable()
            .foregroundStyle(isThemed ? .navigationBarTitle : attributes.foregroundColor)

        if let size = attributes.size {
            return AnyView(
                image
                    .frame(
                        width: size.width > centerItemImageMaxWidth ? nil : size.width,
                        height: size.height > Floats.centerItemImageMaxHeight ? nil : size.height
                    )
                    .frame(
                        maxWidth: centerItemImageMaxWidth,
                        maxHeight: Floats.centerItemImageMaxHeight,
                        alignment: .center
                    )
            )
        }

        return AnyView(
            image
                .scaledToFit()
                .frame(
                    maxWidth: centerItemImageMaxWidth,
                    maxHeight: Floats.centerItemImageMaxHeight,
                    alignment: .center
                )
        )
    }

    // MARK: - Center Text

    private func centerText(for attributes: TextAttributes) -> some View {
        Text(attributes.string)
            .font(attributes.font)
            .foregroundStyle(isThemed ? .navigationBarTitle : attributes.foregroundColor)
    }

    // MARK: - Peripheral Button

    private func peripheralButton(for type: PeripheralButtonType) -> some View {
        Group {
            switch type {
            case let .image(attributes):
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

            case let .text(attributes):
                Button {
                    attributes.action()
                } label: {
                    Text(attributes.text.string)
                        .font(attributes.text.font)
                        .foregroundStyle(isThemed ? .accent : attributes.text.foregroundColor)
                }
            }
        }
    }
}
