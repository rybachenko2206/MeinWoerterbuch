//
//  WordViewModel.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 23.08.24.
//

import Foundation
import Combine

class WordViewModel: ObservableObject {
    // MARK: - Properties
    private let word: Word?
    private var subscriptions: [AnyCancellable] = []
    var title: String { "Add new word" }
    var valuePlaceholder: String { "new word" }
    var translationPlaceholder: String { "translation" }
    var addInfoPlaceholder: String { "additional info" }
    
    @Published var wordValue: String = ""
    @Published var translation: String = ""
    @Published var additionalInfo: String = ""
    @Published var additionalInfo2: String = ""
    @Published var isSaveButtonEnabled: Bool = false
    
    var saveWordCompletion: ((Word) -> Void)?
    
    // MARK: - Init
    init(word: Word?) {
        self.word = word
        self.wordValue = word?.value ?? ""
        self.translation = word?.translation ?? ""
        self.additionalInfo = word?.additionalInfo ?? ""
        
        setupBindings()
    }
    
    // MARK: - Public funcs
    func saveButtonTapped() {
        if let word {
            word.value = wordValue
            word.translation = translation
            word.additionalInfo = additionalInfo
            saveWordCompletion?(word)
        } else {
            let newWord = Word(value: wordValue, translation: translation, additionalInfo: additionalInfo)
            saveWordCompletion?(newWord)
        }
    }
    
    // MARK: - Private funcs
    private func setupBindings() {
        $wordValue.sink(receiveValue: { [weak self] _ in
            self?.handleWordOrTranslationValueChanged()
        })
        .store(in: &subscriptions)
        
        $translation.sink(receiveValue: { [weak self] _ in
            self?.handleWordOrTranslationValueChanged()
        })
        .store(in: &subscriptions)
    }
    
    private func handleWordOrTranslationValueChanged() {
        let isFilled = !wordValue.isBlank && !translation.isEmpty
        
        let isChanged: Bool
        if let word {
            let translationChanged = word.translation != translation
            isChanged = word.value != wordValue || translationChanged || word.additionalInfo != additionalInfo
        } else {
            isChanged = true
        }
        
        isSaveButtonEnabled = isFilled && isChanged
    }
}

extension WordViewModel {
    private static let wordPreview = Word(value: "aufräumen", translation: "to clean", additionalInfo: "trennbare verb")
    static let previewVM = WordViewModel(word: wordPreview)
}
