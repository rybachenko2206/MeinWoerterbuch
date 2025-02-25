//
//  WordCellViewModel.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 22.08.24.
//

import Foundation

@MainActor
class WordCellViewModel: ObservableObject, @preconcurrency Identifiable {
    // MARK: - Properties
    let word: Word
    
    var id: String { word.wordId }
    
    var value: String {
        if word.partOfSpeechDetails?.partOfSpeech == .noun {
            return word.value.capitalized
        } else {
            return word.value.lowercased()
        }
    }
    
    var article: String? { word.partOfSpeechDetails?.article?.description }
    
    var pluralForm: String? {
        guard let pl = word.partOfSpeechDetails?.plural else {return nil }
        let pluralCaption: String = "pl.:"
        return "\(pluralCaption) die \(pl.capitalized)"
    }
    
    var translation: String { word.translation }
    
    var comparableForms: String? {
        return [word.partOfSpeechDetails?.komparativ, word.partOfSpeechDetails?.superlativ].joinedBy(" · ")?.lowercased()
    }
    
    var verbPastForms: String? {
        return [word.partOfSpeechDetails?.praeteritum, word.partOfSpeechDetails?.partizip2].joinedBy(" · ")?.lowercased()
    }
    
    // MARK: - Init
    init(word: Word) {
        self.word = word
    }

    func getEditWordViewModel() -> WordViewModel {
        WordViewModel(word: word)
    }
}

extension WordCellViewModel {
    static let previewObject: WordCellViewModel = .init(word: Word(value: "morgen", translation: "завтра"))
    static let previewObject2: WordCellViewModel = .init(word: Word(value: "Hund", translation: "собака", partOfSpeechDetails: PartOfSpeechDetails(partOfSpeech: .noun, article: .der, plural: "Hunde")))
    static let previewObject3: WordCellViewModel = .init(word: Word(value: "Hauptbahnhof", translation: "головна станція", partOfSpeechDetails: PartOfSpeechDetails(partOfSpeech: .noun, article: .der, plural: "Hauptbahnhöfe")))
    static let previewObj4 = WordCellViewModel(word: Word(value: "Häufig", translation: "часто", partOfSpeechDetails: PartOfSpeechDetails(partOfSpeech: .adverb, isKomparable: true, komparativ: "Häufiger", superlativ: "am Häufigsten"), additionalInfo: "частий"))
    static let previewObj5 = WordCellViewModel(word: Word(value: "versuchen", translation: "намагатися", partOfSpeechDetails: PartOfSpeechDetails(partOfSpeech: .verb, praeteritum: "versuchte", partizip2: "versucht"), additionalInfo: "спробувати"))
}
