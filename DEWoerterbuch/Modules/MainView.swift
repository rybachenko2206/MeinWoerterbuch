//
//  ContentView.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 22.08.24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    private let modelContext: ModelContext
    @State private var dictionaryViewModel: DictionaryViewModel
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        let dictionaryVm = DictionaryViewModel(modelContext: modelContext)
        _dictionaryViewModel = State(initialValue: dictionaryVm)
    }
    
    var body: some View {
        TabView(content: {
            DictionaryView(dictionaryViewModel: dictionaryViewModel)
                .tabItem {
                    Label("Dictionary", systemImage: "text.book.closed")
                }
            TrainerView()
                .tabItem {
                    Label("Trainer", systemImage: "brain.filled.head.profile")
                }
            
        })
//        NavigationStack(root: {
//            List(content: {
//                ForEach(allWords, content: { item in
//                    VStack(alignment: .leading, content: {
//                        Text(item.value)
//                            .font(.headline)
//                        Text(item.translation)
//                            .font(.subheadline)
//                    })
//                })
//            })
//            .navigationTitle("Dictionary")
//            .toolbar(content: {
//                Button(action: addWord, label: {
//                    Image(systemName: "plus")
//                })
//            })
//        })
    }
    
    func addWord() {
        pl("add word button tapped")
    }
    
}

#Preview {
    MainView(modelContext: try! ModelContainer(for: Word.self).mainContext)
}
