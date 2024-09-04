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
    @Observable
    class DictionaryViewModel {
        // MARK: - Properties
        private var modelContext: ModelContext
        private(set) var wordCellViewModels: [WordCellViewModel] = []
        private var subscriptions: Set<AnyCancellable> = []
        
        // MARK: - Init
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            
            fetchData()
        }
        
        // MARK: - Public funcs
        func deleteWords(in indexSet: IndexSet) {
            for index in indexSet {
                if let wordCellVM = wordCellViewModels[safe: index] {
                    wordCellViewModels.remove(at: index)
                    modelContext.delete(wordCellVM.word)
                }
            }
            
            saveContext()
        }
        
        func getAddWordViewModel() -> AddWordViewModel {
            let addVm = AddWordViewModel(word: nil)
            addVm.saveWordCompletion = { [weak self] wordToSave in
                guard let self else { return }
                if !self.wordCellViewModels.contains(where: { $0.id == wordToSave.id }) {
                    self.modelContext.insert(wordToSave)
                }
                self.saveContext()
            }
            
            return addVm
        }
        
        // MARK: - Private funcs
        private func fetchData() {
            do {
                let descriptor = FetchDescriptor<Word>(sortBy: [SortDescriptor(\.value)])
                let words = try modelContext.fetch(descriptor)
                wordCellViewModels = words.map({ WordCellViewModel(word: $0) })
            } catch {
                pl("Fetch data failed")
            }
        }
        
        private func saveContext() {
            do {
                try modelContext.save()
            } catch {
                pl("save context failed with error: \(error)")
            }
        }
        
        static let previewVM = DictionaryViewModel(modelContext: ModelContext.init( try! ModelContainer(for: Word.self)))
    }
}

