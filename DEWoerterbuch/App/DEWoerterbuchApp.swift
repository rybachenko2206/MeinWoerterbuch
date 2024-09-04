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
    let modelContainer: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            MainView(modelContext: modelContainer.mainContext)
        }
        .modelContainer(modelContainer)
    }
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Word.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
}
