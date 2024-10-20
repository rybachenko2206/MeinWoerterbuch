//
//  WordCellViewModel.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 22.08.24.
//

import Foundation

class WordCellViewModel: ObservableObject, Identifiable {
    // MARK: - Properties
    let word: Word
    
    var id: String { word.id }
    var value: String { word.value }
    var translation: String { word.translation }
    
    // MARK: - Init
    init(word: Word) {
        self.word = word
    }

    func getEditWordViewModel() -> AddWordViewModel {
        AddWordViewModel(word: word)
    }
}

extension WordCellViewModel {
    static let previewObject: WordCellViewModel = .init(word: Word(value: "morgen", translation: "завтра"))
}
