//
//  Toast+Style.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import SwiftUI

public extension Toast {
    enum Style: Equatable {
        // MARK: - Cases

        case error
        case info
        case success
        case warning
        case none

        // MARK: - Constants Accessors

        private typealias Strings = CoreConstants.Strings.ToastView
        private typealias Colors = CoreConstants.Colors.ToastView

        // MARK: - Properties

        public var bannerIconSystemImageName: String? {
            switch self {
            case .error:
                return Strings.bannerErrorIconImageSystemName
            case .info:
                return Strings.bannerInfoIconImageSystemName
            case .success:
                return Strings.bannerSuccessIconImageSystemName
            case .warning:
                return Strings.bannerWarningIconImageSystemName
            case .none:
                return nil
            }
        }

        public var capsuleIconSystemImageName: String? {
            switch self {
            case .error:
                return Strings.capsuleErrorIconImageSystemName
            case .info:
                return Strings.capsuleInfoIconImageSystemName
            case .success:
                return Strings.capsuleSuccessIconImageSystemName
            case .warning:
                return Strings.capsuleWarningIconImageSystemName
            case .none:
                return nil
            }
        }

        public var defaultColor: Color? {
            switch self {
            case .error:
                return Colors.defaultErrorColor
            case .info:
                return Colors.defaultInfoColor
            case .success:
                return Colors.defaultSuccessColor
            case .warning:
                return Colors.defaultWarningColor
            case .none:
                return nil
            }
        }
    }
}
