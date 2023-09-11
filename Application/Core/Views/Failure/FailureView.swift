//
//  FailureView.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* First-party Frameworks */
import Foundation
import SwiftUI

/* Third-party Frameworks */
import Redux

public struct FailureView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: ViewModel<FailureReducer>
    
    // MARK: - Constants Accessors
    
    private typealias Colors = AppConstants.Colors.FailureView
    private typealias Floats = AppConstants.CGFloats.FailureView
    private typealias Strings = AppConstants.Strings.FailureView
    
    // MARK: - Init
    
    public init(_ viewModel: ViewModel<FailureReducer>) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    // MARK: - View
    
    public var body: some View {
        Image(systemName: Strings.imageSystemName)
            .renderingMode(.template)
            .foregroundColor(Colors.imageForegroundColor)
            .font(.system(size: Floats.imageSystemSize))
            .padding(.bottom, Floats.imageBottomPadding)
        
        Text(viewModel.exception.userFacingDescriptor)
            .font(Font.custom(Strings.exceptionLabelFontName, size: Floats.exceptionLabelFontSize))
            .foregroundColor(Colors.exceptionLabelFontColor)
            .padding(.vertical, Floats.exceptionLabelBottomPadding)
            .multilineTextAlignment(.center)
        
        if viewModel.retryHandler != nil {
            Button {
                viewModel.send(.executeRetryHandler)
            } label: {
                Text(viewModel.retryButtonText)
                    .font(.system(size: Floats.buttonLabelFontSize, weight: .semibold))
                    .foregroundColor(Colors.retryButtonColor)
            }
        }
        
        Button {
            viewModel.send(.reportBugButtonTapped)
        } label: {
            Text(viewModel.reportBugButtonText)
                .font(.system(size: Floats.buttonLabelFontSize))
                .foregroundColor(viewModel.didReportBug ? Colors.reportBugButtonDisabledColor : Colors.reportBugButtonEnabledColor)
        }
        .padding(.top, Floats.reportBugButtonTopPadding)
        .disabled(viewModel.didReportBug)
    }
}