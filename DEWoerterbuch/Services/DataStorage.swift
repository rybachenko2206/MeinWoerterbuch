//
//  DataStorage.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 04.09.24.
//

import Foundation
import SwiftData

protocol PDataStorage {
    func fetchWords() async -> [Word]
    func addNewWord(_ word: String, translation: String, additionalInfo: String) async
}

@MainActor
class DataStorage: PDataStorage {
    // MARK: - Properties
    private let modelContainer: ModelContainer
//    private var mainContext: ModelContext { modelContainer.mainContext }
    
    // MARK: - Init
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    // MARK: - Public funcs
    func fetchWords() async -> [Word] {
        let fetchDescriptor = FetchDescriptor<Word>()
        do {
            return try modelContainer.mainContext.fetch(fetchDescriptor)
        } catch {
            pl("Fetch data failed with error: \n\(error)")
            return []
        }
    }
    
    func addNewWord(_ word: String, translation: String, additionalInfo: String) {
        let newWord = Word(value: word, translation: translation, additionalInfo: additionalInfo)
        let context = modelContainer.mainContext
        context.insert(newWord)
        saveContext(context)
    }
    
    // MARK: - Private funcs
    private func saveContext(_ context: ModelContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
