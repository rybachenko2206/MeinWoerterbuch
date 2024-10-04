//
//  DataStorage.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 04.09.24.
//

import Foundation
import SwiftUI
import SwiftData

protocol PDataStorage {
    func fetchWords() async -> [Word]
    func addNewWord(_ word: Word) async
    func deleteWord(_ word: Word) async
}

@MainActor
class DataStorage: PDataStorage {
    // MARK: - Properties
    private let container: ModelContainer
    
    init(container: ModelContainer) {
        self.container = container
    }
    
    // MARK: - Public funcs
    func fetchWords() async -> [Word] {
        let fetchDescriptor = FetchDescriptor<Word>()
        do {
            return try container.mainContext.fetch(fetchDescriptor)
        } catch {
            pl("Fetch data failed with error: \n\(error)")
            return []
        }
    }
    
    func addNewWord(_ word: Word) async {
        container.mainContext.insert(word)
        await saveContext(container.mainContext)
    }
    
    func deleteWord(_ word: Word) async {
        let context = container.mainContext
        context.delete(word)
        await saveContext(context)
    }
    
    // MARK: - Private funcs
    private func saveContext(_ context: ModelContext) async {
        do {
            try context.save()
        } catch {
            pl("Failed to save context: \(error)")
        }
    }
}
