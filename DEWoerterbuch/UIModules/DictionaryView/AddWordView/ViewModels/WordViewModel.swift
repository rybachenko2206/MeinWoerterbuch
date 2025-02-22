//
//  WordViewModel.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 23.08.24.
//

import Foundation
import Combine

@MainActor
class WordViewModel: ObservableObject {
    // MARK: - Properties
    private let word: Word?
    private var subscriptions: [AnyCancellable] = []
    
    private var partOfSpeechDetails: PartOfSpeechDetails
    
    @Published private(set) var isSaveButtonEnabled: Bool = true
    
    let saveButtonTitle: String = "Save"
    var title: String { "Add new word" }
    var valuePlaceholder: String { "new word" }
    var translationPlaceholder: String { "translation" }
    var addInfoPlaceholder: String { "additional info" }
    var additionalInfoSectionHeader: String { "Additional Info" }
    var partOfSpeechSectionHeader: String { "Part of speech" }
    
    var articlePlaceholder: String { "Select article" }
    var pluralPlaceholder: String { "Set plural form" }
    var praeteritumPlaceholder: String { "set präteritum" }
    var partizip2Placeholder: String { "set partizip II" }
    var komparativPlaceholder: String { "set komparativ" }
    var superlativPlaceholder: String { "set superlativ" }
    
    @Published var partOfSpeech: PartOfSpeech
    @Published var selectedArticle: Article
    @Published var pluralForm: String
    @Published var praeteritum: String
    @Published var partizip2: String
    @Published var komparativ: String
    @Published var superlativ: String
    
    @Published var wordValue: String = ""
    @Published var translation: String = ""
    @Published var additionalInfo: String = ""
    @Published var additionalInfo2: String = ""
    
    var saveWordCompletion: ((Word) -> Void)?
    
    // MARK: - Init
    init(word: Word? = nil) {
        self.word = word
        self.wordValue = word?.value ?? ""
        self.translation = word?.translation ?? ""
        self.additionalInfo = word?.additionalInfo ?? ""
        self.partOfSpeechDetails = word?.partOfSpeechDetails ?? PartOfSpeechDetails(partOfSpeech: .notSelected)
        
        self.partOfSpeech = partOfSpeechDetails.partOfSpeech
        self.selectedArticle = partOfSpeechDetails.article
        self.pluralForm = partOfSpeechDetails.plural ?? ""
        self.praeteritum = partOfSpeechDetails.praeteritum ?? ""
        self.partizip2 = partOfSpeechDetails.partizip2 ?? ""
        self.komparativ = partOfSpeechDetails.komparativ ?? ""
        self.superlativ = partOfSpeechDetails.superlativ ?? ""
        
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
    
    func saveAction() {
        pl("save model or return?")
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
    private static let wordPreview = Word(
        value: "aufräumen",
        translation: "to clean",
        partOfSpeechDetails: PartOfSpeechDetails(partOfSpeech: .verb, praeteritum: "räumte auf", partizip2: "aufgeräumt"),
        additionalInfo: "trennbare verb"
    )
    
    static let previewVM = WordViewModel(word: wordPreview)
}

