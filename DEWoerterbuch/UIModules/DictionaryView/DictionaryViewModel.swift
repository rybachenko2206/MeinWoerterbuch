//
//  DictionaryViewModel.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 23.08.24.
//

import Foundation
import SwiftData
import Combine

extension MainView {
    
    @MainActor
    class DictionaryViewModel: ObservableObject {
        // MARK: - Properties
        private let dataStorage: PDataStorage
        @Published private(set) var wordCellViewModels: [WordCellViewModel] = []
        private var subscriptions: Set<AnyCancellable> = []
        
        let title: String = "Dictionary"
        
        @Published var searchText: String = ""
        
        var filtereWordViewModels: [WordCellViewModel] {
            guard !searchText.isEmpty else { return wordCellViewModels }
            
            let wordResults = wordCellViewModels.filter({
                $0.word.value.lowercased().contains(searchText.lowercased())
            })
            
            let translationResults = wordCellViewModels.filter({
                $0.word.translation.lowercased().contains(searchText.lowercased())
            })
            
            // TODO: add search in partOfSpeech
            
            // FIXME: awoid duplicates
            return wordResults + translationResults
        }
        
        // MARK: - Init
        init(dataStorage: PDataStorage) {
            self.dataStorage = dataStorage
        }
        
        // MARK: - Public funcs
        func deleteWords(in indexSet: IndexSet) async {
            for index in indexSet {
                if let wordCellVM = wordCellViewModels[safe: index] {
                    wordCellViewModels.remove(at: index)
                    await dataStorage.deleteWord(wordCellVM.word)
                }
            }
        }
        
        func fetchData() async {
            let words = await dataStorage.fetchWords()
            
            await MainActor.run(body: {
                wordCellViewModels = words.map({ WordCellViewModel(word: $0) })
            })
        }
        
        func getAddWordViewModel() -> WordViewModel {
            let addVm = WordViewModel(word: nil)
            addVm.saveWordCompletion = { [weak self] word in
                guard let self else { return }
                if !self.wordCellViewModels.contains(where: { $0.id == word.id }) {
                    Task { @MainActor in
                        await self.dataStorage.addNewWord(word)
                        let wordCellVm = WordCellViewModel(word: word)
                        self.wordCellViewModels.append(wordCellVm)
                    }
                }
            }
            
            return addVm
        }
        
        // MARK: - Private funcs
        
    }
}

