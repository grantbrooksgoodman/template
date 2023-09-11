//
//  SampleReducer.swift
//  Template
//
//  Created by Grant Brooks Goodman on DD/MM/20YY.
//  Copyright © 2013-20YY NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation

/* 3rd-party */
import Redux
import Translator

public struct SampleReducer: Reducer {
    // MARK: - Dependencies
    
    @Dependency(\.translatorService) private var translator: TranslatorService
    
    // MARK: - Actions
    
    public enum Action {
        case viewAppeared
    }
    
    // MARK: - Feedback
    
    public enum Feedback {
        case getTranslationsReturned(Callback<[Translation], Exception>)
    }
    
    // MARK: - State
    
    public struct State: Equatable {
        /* MARK: Properties */
        
        var inputs: SampleViewInputs = .default
        var strings: SampleViewStrings = .default
        var viewState: ViewState = .loading
        
        /* MARK: Init */
        
        public init() { }
    }
    
    // MARK: - View State
    
    public enum ViewState: Equatable {
        case loading
        case error(Exception)
        case loaded
    }
    
    // MARK: - Reduce
    
    public func reduce(into state: inout State, for event: Event) -> Effect<Feedback> {
        switch event {
        case .action(.viewAppeared):
            RuntimeStorage.store(#file, as: .currentFile)
            state.viewState = .loading
            
            let inputs = state.inputs.array
            return .task {
                let result = await translator.getTranslations(for: inputs, languagePair: .system)
                return .getTranslationsReturned(result)
            }
            
        case .feedback(.getTranslationsReturned(.success(let translations))):
            state.strings = mapToStrings(inputs: state.inputs, translations: translations)
            state.viewState = .loaded
            
        case .feedback(.getTranslationsReturned(.failure(let exception))):
            state.viewState = .error(exception)
            Logger.log(exception)
        }
        
        return .none
    }
    
    // MARK: - Translation Mapper
    
    private func mapToStrings(inputs: SampleViewInputs,
                              translations: [Translation]) -> SampleViewStrings {
        var strings: SampleViewStrings = .default
        
        for translation in translations {
            switch translation.input.value() {
            case inputs.titleLabelText.value():
                strings.titleLabelText = translation.output.sanitized
                
            case inputs.subtitleLabelText.value():
                strings.subtitleLabelText = translation.output.sanitized
                
            default:
                continue
            }
        }
        
        return strings
    }
}
