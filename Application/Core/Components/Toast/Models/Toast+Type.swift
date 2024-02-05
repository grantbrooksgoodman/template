//
//  Toast+Type.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

public extension Toast {
    enum ToastType: Equatable {
        // MARK: - Cases

        case banner(
            style: Toast.Style = .none,
            appearanceEdge: Toast.AppearanceEdge = .top,
            colorPalette: Toast.ColorPalette? = nil,
            showsDismissButton: Bool = true
        )
        case capsule(style: Toast.Style = .none)

        // MARK: - Properties

        public var appearanceEdge: Toast.AppearanceEdge? {
            switch self {
            case let .banner(style: _, appearanceEdge: appearanceEdge, colorPalette: _, showsDismissButton: _):
                return appearanceEdge
            default:
                return nil
            }
        }

        public var colorPalette: Toast.ColorPalette? {
            switch self {
            case let .banner(style: _, appearanceEdge: _, colorPalette: colorPalette, showsDismissButton: _):
                return colorPalette
            default:
                return nil
            }
        }

        public var showsDismissButton: Bool? {
            switch self {
            case let .banner(style: _, appearanceEdge: _, colorPalette: _, showsDismissButton: showsDismissButton):
                return showsDismissButton
            default:
                return nil
            }
        }

        public var style: Toast.Style {
            switch self {
            case let .banner(style: style, appearanceEdge: _, colorPalette: _, showsDismissButton: _):
                return style
            case let .capsule(style: style):
                return style
            }
        }
    }
}
