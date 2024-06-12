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

    public enum Appearance: Equatable {
        /* MARK: Cases */

        case custom(backgroundColor: UIColor)
        case themed

        /* MARK: Properties */

        public var backgroundColor: UIColor {
            switch self {
            case let .custom(backgroundColor: backgroundColor):
                return backgroundColor

            case .themed:
                return .navigationBarBackground
            }
        }
    }

    public enum CenterItemType {
        case image(ImageAttributes)
        case text(TextAttributes, subtitle: TextAttributes? = nil)
    }

    public enum PeripheralButtonType {
        case image(ImageButtonAttributes)
        case text(TextButtonAttributes)
    }

    public enum SizeClass {
        /* MARK: Cases */

        case custom(minHeight: CGFloat)
        case fullScreenCover
        case sheet

        /* MARK: Properties */

        public var minHeight: CGFloat {
            switch self {
            case let .custom(minHeight: minHeight):
                return minHeight

            case .fullScreenCover:
                return Floats.fullScreenCoverSizeClassFrameMinHeight

            case .sheet:
                return Floats.sheetSizeClassFrameMinHeight
            }
        }
    }

    // MARK: - Constants Accessors

    private typealias Colors = CoreConstants.Colors.HeaderView
    private typealias Floats = CoreConstants.CGFloats.HeaderView

    // MARK: - Properties

    // PeripheralButtonType
    public let leftItem: PeripheralButtonType?
    public let rightItem: PeripheralButtonType?

    // Other
    public let attributes: Attributes
    public let centerItem: CenterItemType?

    @Environment(\.keyWindowSize) private var keyWindowSize: CGSize

    // MARK: - Computed Properties

    private var centerItemImageMaxWidth: CGFloat { keyWindowSize.width / Floats.keyWindowSizeWidthDivisor }
    private var isThemed: Bool { attributes.appearance == .themed }

    // MARK: - Init

    public init(
        leftItem: PeripheralButtonType? = nil,
        centerItem: CenterItemType? = nil,
        rightItem: PeripheralButtonType? = nil,
        attributes: Attributes = .init()
    ) {
        self.leftItem = leftItem
        self.centerItem = centerItem
        self.rightItem = rightItem
        self.attributes = attributes
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if isThemed {
                Group {
                    ThemedView {
                        contentView
                    }

                    dividerView
                }
            } else {
                contentView
                dividerView
            }
        }
        .background(Color(uiColor: attributes.appearance.backgroundColor))
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
        .frame(minHeight: attributes.sizeClass.minHeight)
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

    // MARK: - Divider View

    @ViewBuilder
    private var dividerView: some View {
        if attributes.showsDivider {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: Floats.separatorMaxHeight)
                .foregroundStyle(ThemeService.isDarkModeActive ? Colors.separatorDarkForeground : Colors.separatorLightForeground)
                .padding(.top, Floats.separatorTopPadding)
        }
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
                            .fontWeight(attributes.image.weight)
                            .foregroundStyle(isThemed ? .accent : attributes.image.foregroundColor)
                            .frame(width: size.width, height: size.height)
                    } else {
                        attributes.image.image
                            .fontWeight(attributes.image.weight)
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
