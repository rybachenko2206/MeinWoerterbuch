//
//  ContentView.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 22.08.24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    private var viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView(content: {
            DictionaryView(dictionaryViewModel: viewModel.dictionaryViewModel)
                .tabItem {
                    Label("Dictionary", systemImage: "text.book.closed")
                }
            TrainerView()
                .tabItem {
                    Label("Trainer", systemImage: "brain.filled.head.profile")
                }
            
        })
    }
}

#Preview {
    MainView(viewModel: MainViewModel(dataStorage: DataStorage(container: try! ModelContainer(for: Word.self))))
}
