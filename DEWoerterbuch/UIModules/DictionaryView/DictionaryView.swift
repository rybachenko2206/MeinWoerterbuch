//
//  DictionaryView.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 23.08.24.
//

import SwiftUI
import SwiftData

typealias DictionaryViewModel = MainView.DictionaryViewModel

struct DictionaryView: View {
    @State private var showAddWordModalView = false
    
    @ObservedObject var dictionaryViewModel: DictionaryViewModel
    
    var body: some View {
        NavigationStack(root: {
            List(content: {
                ForEach(dictionaryViewModel.wordCellViewModels, content: { cellVm in
                    NavigationLink(destination: {
                        NewWordView(viewModel: cellVm.getEditWordViewModel())
                    }, label: {
                        WordCellView(viewModel: cellVm)
                    })
                })
                .onDelete(perform: { indexSet in
                    Task {
                        await dictionaryViewModel.deleteWords(in: indexSet)
                    }
                })
            })
            .navigationTitle("Dictionary")
            .toolbar(content: {
                Button(action: addWord, label: {
                    Image(systemName: "plus")
                })
                .fullScreenCover(isPresented: $showAddWordModalView, content: {
                    NavigationStack(root: {
                        NewWordView(viewModel: dictionaryViewModel.getAddWordViewModel())
                    })
                })
            })
            .onAppear(perform: {
                Task {
                    await dictionaryViewModel.fetchData()
                }
            })
        })
    }
    
    // MARK: - Actions
    private func addWord() {
        showAddWordModalView = true
    }
}

#Preview {
    DictionaryView(dictionaryViewModel: DictionaryViewModel(dataStorage: DataStorage(container: try! ModelContainer(for: Word.self))))
}
