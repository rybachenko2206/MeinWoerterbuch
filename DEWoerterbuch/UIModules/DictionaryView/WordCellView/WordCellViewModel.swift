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
    
    var article: String? { word.partOfSpeechDetails?.nounDetails?.article?.description }
    
    var pluralForm: String? {
        guard let pl = word.partOfSpeechDetails?.nounDetails?.plural else {return nil }
        let pluralCaption: String = "pl.:"
        return "\(pluralCaption) die \(pl.capitalized)"
    }
    
    var translation: String { word.translation }
    
    var comparableForms: String? {
        return [
            word.partOfSpeechDetails?.adjectiveDetails?.komparativ,
            word.partOfSpeechDetails?.adjectiveDetails?.superlativ
        ].joinedBy(" · ")?.lowercased()
    }
    
    var verbPastForms: String? {
        return [
            word.partOfSpeechDetails?.verbDetails?.praeteritum,
            word.partOfSpeechDetails?.verbDetails?.partizip2
        ].joinedBy(" · ")?.lowercased()
    }
    
    // MARK: - Init
    init(word: Word) {
        self.word = word
    }

    // MARK: Public funcs
    func getEditWordViewModel() -> WordViewModel {
        WordViewModel(word: word)
    }
    
    func getWordGrammarSummary() -> String? {
        guard let psDetails = word.partOfSpeechDetails else { return nil }
        
        var strArray: [String?] = [psDetails.partOfSpeech.description.capitalized]
        
        switch psDetails.partOfSpeech {
        case .verb:
            if psDetails.verbDetails?.requiresDativ == true {
                strArray.append("Dat.")
            }
            if let takesSein = psDetails.verbDetails?.takesSein {
                let value = takesSein ? "Sein" : "Haben"
                strArray.append(value)
            }
            
        case .adjective,
                .adverb:
            if psDetails.adjectiveDetails?.isComparable == false {
                strArray.append("Not Comparable")
            }
            
        default:
            break
        }
        
        return strArray.joinedBy(" · ")
    }
}

extension WordCellViewModel {
    static let previewObject = WordCellViewModel(word: Word(value: "morgen", translation: "завтра"))
    
    static let previewObject2 = WordCellViewModel(
        word: Word(
            value: "Hund",
            translation: "собака",
            partOfSpeechDetails: PartOfSpeechDetails(
                partOfSpeech: .noun,
                nounDetails: NounDetails(article: .der, plural: "Hunde")
            )
        )
    )
    
    static let previewObject3 = WordCellViewModel(
        word: Word(
            value: "Hauptbahnhof",
            translation: "головна станція",
            partOfSpeechDetails: PartOfSpeechDetails(
                partOfSpeech: .noun,
                nounDetails: NounDetails(article: .der, plural: "Hauptbahnhöfe")
            )
        )
    )
                                                  
    static let previewObj4 = WordCellViewModel(
        word: Word(
            value: "Häufig",
            translation: "часто",
            additionalInfo: "частий",
            partOfSpeechDetails: PartOfSpeechDetails(
                partOfSpeech: .adverb,
                adjectiveDetails: AdjectiveDetails(
                    isComparable: true,
                    komparativ: "Häufiger",
                    superlativ: "Häufigsten"
                )
            )
            )
        )
    
    static let previewObj5 = WordCellViewModel(
        word: Word(
            value: "versuchen",
            translation: "намагатися",
            additionalInfo: "спробувати",
            partOfSpeechDetails: PartOfSpeechDetails(
                partOfSpeech: .verb,
                verbDetails: VerbDetails(
                    praeteritum: "versuchte",
                    partizip2: "versucht",
                    requiresDativ: false,
                    takesSein: false
                )
            )
        )
    )
}
