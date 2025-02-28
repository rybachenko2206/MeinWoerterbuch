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
    /*private*/ let existingWord: Word?
    private var subscriptions: [AnyCancellable] = []
    
    var isEditingMode: Bool { existingWord != nil }
    
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
    var requiresDativCaption: String { "Requires Dativ?" }
    var takesSeinCaption: String { "Takes Sein?" }
    var komparablePlaceholder: String { "Komparable?" }
    var komparativPlaceholder: String { "set komparativ" }
    var superlativPlaceholder: String { "set superlativ" }
    
    var areMainFieldsFilled: Bool { !wordValue.isBlank && !translation.isEmpty }
    
    @Published var partOfSpeech: PartOfSpeech
    @Published var selectedArticle: Article
    @Published var pluralForm: String
    @Published var praeteritum: String
    @Published var partizip2: String
    @Published var requiresDativ: Bool?
    @Published var takesSein: Bool?
    @Published var isComparable: Bool?
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
        self.wordValue = word?.value ?? ""
        self.translation = word?.translation ?? ""
        self.additionalInfo = word?.additionalInfo ?? ""
        
        self.partOfSpeech = word?.partOfSpeechDetails?.partOfSpeech ?? .notSelected
        self.selectedArticle = word?.partOfSpeechDetails?.nounDetails?.article ?? .notSelected
        self.pluralForm = word?.partOfSpeechDetails?.nounDetails?.plural ?? ""
        self.praeteritum = word?.partOfSpeechDetails?.verbDetails?.praeteritum ?? ""
        self.partizip2 = word?.partOfSpeechDetails?.verbDetails?.partizip2 ?? ""
        self.requiresDativ = word?.partOfSpeechDetails?.verbDetails?.requiresDativ
        self.takesSein = word?.partOfSpeechDetails?.verbDetails?.takesSein
        self.isComparable = word?.partOfSpeechDetails?.adjectiveDetails?.isComparable
        self.komparativ = word?.partOfSpeechDetails?.adjectiveDetails?.komparativ ?? ""
        self.superlativ = word?.partOfSpeechDetails?.adjectiveDetails?.superlativ ?? ""
        
        setupBindings()
    }
   
    // MARK: - Public funcs
    func setupRepeatedlyPartOfSpeechDetails() {
        guard let psDetails = existingWord?.partOfSpeechDetails else { return }
//        self.partOfSpeech = psDetails.partOfSpeech
        self.selectedArticle = psDetails.nounDetails?.article ?? .notSelected
        self.pluralForm = psDetails.nounDetails?.plural ?? ""
        self.praeteritum = psDetails.verbDetails?.praeteritum ?? ""
        self.partizip2 = psDetails.verbDetails?.partizip2 ?? ""
        self.requiresDativ = psDetails.verbDetails?.requiresDativ
        self.takesSein = psDetails.verbDetails?.takesSein
        self.isComparable = psDetails.adjectiveDetails?.isComparable
        self.komparativ = psDetails.adjectiveDetails?.komparativ ?? ""
        self.superlativ = psDetails.adjectiveDetails?.superlativ ?? ""
    }
    
    func saveButtonTapped() {
        let word: Word
        
        if let existingWord {
            word = existingWord
            word.value = wordValue
            word.translation = translation
            word.additionalInfo = additionalInfo 
        } else {
            word = Word(value: wordValue, translation: translation, additionalInfo: additionalInfo)
        }
        
        var nounDetails: NounDetails? = nil
        var verbDetails: VerbDetails? = nil
        var adjectiveDetails: AdjectiveDetails? = nil
        
        switch partOfSpeech {
        case .noun:
            nounDetails = NounDetails(article: selectedArticle, plural: pluralForm)
        case .verb:
            verbDetails = VerbDetails(praeteritum: praeteritum, partizip2: partizip2, requiresDativ: requiresDativ, takesSein: takesSein)
        case .adjective,
                .adverb:
            adjectiveDetails = AdjectiveDetails(isComparable: isComparable, komparativ: komparativ, superlativ: superlativ)
        default:
            break
        }
        
        let newDetails = PartOfSpeechDetails(
            partOfSpeech: partOfSpeech,
            nounDetails: nounDetails,
            verbDetails: verbDetails,
            adjectiveDetails: adjectiveDetails
        )
        
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
        let nounDetails = Publishers.CombineLatest($selectedArticle, $pluralForm)
        
        let verbDetails = Publishers.CombineLatest4($praeteritum, $partizip2, $requiresDativ, $takesSein)
        
        let adjectiveDetails = Publishers.CombineLatest3($isComparable, $komparativ, $superlativ)
        
        let partOfSpeechDetCombined = Publishers.CombineLatest4(nounDetails, verbDetails, adjectiveDetails, $partOfSpeech)
        
        Publishers
            .CombineLatest4($wordValue, $translation, $additionalInfo, partOfSpeechDetCombined)
            .receive(on: DispatchQueue.main)
            .map({ (_,_,_,_) in
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
                self?.takesSein = false
                self?.isComparable = false
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
        
        if let article = partOfSpeechDetails.nounDetails?.article, article != selectedArticle {
            return true
        }
        
        if (!pluralForm.isBlank && pluralForm != partOfSpeechDetails.nounDetails?.plural ?? "") ||
            (!praeteritum.isBlank && praeteritum != partOfSpeechDetails.verbDetails?.praeteritum ?? "") ||
            (!partizip2.isBlank && partizip2 != partOfSpeechDetails.verbDetails?.partizip2) ||
            partOfSpeechDetails.verbDetails?.takesSein != takesSein ||
            partOfSpeechDetails.verbDetails?.requiresDativ != requiresDativ ||
            partOfSpeechDetails.adjectiveDetails?.isComparable != isComparable ||
            (!komparativ.isBlank && komparativ != partOfSpeechDetails.adjectiveDetails?.komparativ ?? "") ||
            (!superlativ.isBlank && superlativ != partOfSpeechDetails.adjectiveDetails?.superlativ ?? "")
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

//extension WordViewModel: Hashable /*Equatable*/ {
//    static func == (lhs: WordViewModel, rhs: WordViewModel) -> Bool {
//        if let lhsWord = lhs.existingWord, let rhsWord = rhs.existingWord {
//            return lhsWord == rhsWord
//        } else {
//            return lhs.wordValue == rhs.wordValue &&
//            lhs.translation == rhs.translation &&
//            lhs.additionalInfo == rhs.additionalInfo
//        }
//    }
//    
//    nonisolated func hash(into hasher: inout Hasher) {
//        hasher.combine(wordValue)
//        hasher.combine(translation)
//        hasher.combine(additionalInfo)
//        hasher.combine(partOfSpeech)
//    }
//}

extension WordViewModel {
    private static let verbDetails = VerbDetails(praeteritum: "räumte auf", partizip2: "aufgeräumt", requiresDativ: false, takesSein: false)
    
    private static let wordPreview = Word(
        value: "aufräumen",
        translation: "to clean",
        additionalInfo: "trennbare verb",
        partOfSpeechDetails: PartOfSpeechDetails(partOfSpeech: .verb, verbDetails: verbDetails)
    )
    
    static let previewVM = WordViewModel(word: wordPreview)
}

