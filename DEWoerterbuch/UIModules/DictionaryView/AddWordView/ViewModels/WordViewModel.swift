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
    private let existingWord: Word?
    private var subscriptions: [AnyCancellable] = []
    
    private(set) var isEditingMode: Bool
    
    @Published private(set) var isSaveButtonEnabled: Bool = true
    
    var saveButtonTitle: String { "Save" }
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
    var requiresDativPlaceholder: String { "Requires Dativ?" }
    var komparablePlaceholder: String { "Komparable?" }
    var komparativPlaceholder: String { "set komparativ" }
    var superlativPlaceholder: String { "set superlativ" }
    
    var areMainFieldsFilled: Bool { !wordValue.isBlank && !translation.isEmpty }
    
    @Published var partOfSpeech: PartOfSpeech
    @Published var selectedArticle: Article
    @Published var pluralForm: String
    @Published var praeteritum: String
    @Published var partizip2: String
    @Published var requiresDativ: Bool
    @Published var isKomparable: Bool
    @Published var komparativ: String
    @Published var superlativ: String
    
    @Published var wordValue: String = ""
    @Published var translation: String = ""
    @Published var additionalInfo: String = ""
    @Published var additionalInfo2: String = ""
    
    var saveWordCompletion: ((Word) -> Void)?
    
    // MARK: - Init
    init(word: Word? = nil) {
        self.existingWord = word
        self.isEditingMode = word != nil
        self.wordValue = word?.value ?? ""
        self.translation = word?.translation ?? ""
        self.additionalInfo = word?.additionalInfo ?? ""
        
        self.partOfSpeech = word?.partOfSpeechDetails?.partOfSpeech ?? .notSelected
        self.selectedArticle = word?.partOfSpeechDetails?.article ?? .notSelected
        self.pluralForm = word?.partOfSpeechDetails?.plural ?? ""
        self.praeteritum = word?.partOfSpeechDetails?.praeteritum ?? ""
        self.partizip2 = word?.partOfSpeechDetails?.partizip2 ?? ""
        self.requiresDativ = word?.partOfSpeechDetails?.requiresDativ ?? false
        self.isKomparable = word?.partOfSpeechDetails?.komparable ?? false
        self.komparativ = word?.partOfSpeechDetails?.komparativ ?? ""
        self.superlativ = word?.partOfSpeechDetails?.superlativ ?? ""
        
        setupBindings()
    }
    
    // MARK: - Public funcs
    func saveButtonTapped() {
        let word: Word
        
        if let existingWord {
            word = existingWord
        } else {
            word = Word(value: wordValue, translation: translation, additionalInfo: additionalInfo)
        }
        
        let newDetails = PartOfSpeechDetails(partOfSpeech: partOfSpeech, article: selectedArticle, plural: pluralForm, praeteritum: praeteritum, partizip2: partizip2, requiresDativ: requiresDativ, komparativ: komparativ, superlativ: superlativ)
        
        if arePartOfSpeechDetailsChanged() {
            word.partOfSpeechDetails = newDetails
        }
        
        saveWordCompletion?(word)
    }
    
    // MARK: - Private funcs
    private func setupBindings() {
        bindFieldsToSaveButtonEnabled()
        bindPartOfSpeechChanged()
    }
    
    private func bindFieldsToSaveButtonEnabled() {
        Publishers
            .CombineLatest4($wordValue, $translation, $additionalInfo, $partOfSpeech)
            .receive(on: DispatchQueue.main)
            .map({ (wordStr: String, translation: String, additionalInfo: String, partOfSpeech: PartOfSpeech) in
                if self.existingWord != nil {
                    return self.areMainFieldsFilled && self.areFieldsChanged()
                } else {
                    return self.areMainFieldsFilled
                }
            })
            .assign(to: \.isSaveButtonEnabled, on: self)
            .store(in: &subscriptions)
    }
    
    private func bindPartOfSpeechChanged() {
        $partOfSpeech
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.selectedArticle = .notSelected
                self?.pluralForm = ""
                self?.partizip2 = ""
                self?.praeteritum = ""
                self?.requiresDativ = false
                self?.komparativ = ""
                self?.superlativ = ""
            })
            .store(in: &subscriptions)
    }
    
    private func arePartOfSpeechDetailsChanged() -> Bool {
        guard let partOfSpeechDetails = existingWord?.partOfSpeechDetails else { return true }
        
        if partOfSpeechDetails.partOfSpeech != partOfSpeech {
            return true
        }
        
        if let article = partOfSpeechDetails.article, article != selectedArticle {
            return true
        }
        
        if (!pluralForm.isBlank && pluralForm != partOfSpeechDetails.plural ?? "") ||
            (!praeteritum.isBlank && praeteritum != partOfSpeechDetails.praeteritum ?? "") ||
            (!partizip2.isBlank && partizip2 != partOfSpeechDetails.partizip2) ||
            (!komparativ.isBlank && komparativ != partOfSpeechDetails.komparativ ?? "") ||
            (!superlativ.isBlank && superlativ != partOfSpeechDetails.superlativ ?? "")
        {
            return true
        } else {
            return false
        }
    }
    
    private func areFieldsChanged() -> Bool {
        guard let word = existingWord else { return true }
        
        return word.value != wordValue ||
        word.translation != translation ||
        word.additionalInfo != additionalInfo ||
        arePartOfSpeechDetailsChanged()
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

