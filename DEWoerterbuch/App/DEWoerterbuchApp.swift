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
            let mainVm = MainViewModel(dataStorage: dataStorage)
            MainView(viewModel: mainVm)
        }
        .modelContainer(modelContainer)
    }
    
    init() {
        do {
            let container = try ModelContainer(for: Word.self)
            self.modelContainer = container
            self.dataStorage = DataStorage(container: modelContainer)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
}
