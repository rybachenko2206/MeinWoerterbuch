//
//  DEWoerterbuchApp.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 22.08.24.
//

import SwiftUI
import SwiftData

@main
struct DEWoerterbuchApp: App {
    private let modelContainer: ModelContainer
    private let dataStorage: PDataStorage
    
    var body: some Scene {
        WindowGroup {
            MainView(modelContext: modelContainer.mainContext)
        }
        .modelContainer(modelContainer)
    }
    
    init() {
        do {
            let container = try ModelContainer(for: Word.self)
            self.modelContainer = container
            self.dataStorage = DataStorage(modelContainer: modelContainer)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
}
