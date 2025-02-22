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
    var value: String { word.value }
    var translation: String { word.translation }
    
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
}
