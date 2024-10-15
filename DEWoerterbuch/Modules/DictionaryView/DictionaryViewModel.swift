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
    
    class DictionaryViewModel: ObservableObject {
        // MARK: - Properties
        private let dataStorage: PDataStorage
        @Published private(set) var wordCellViewModels: [WordCellViewModel] = []
        private var subscriptions: Set<AnyCancellable> = []
        
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
                    Task {
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

