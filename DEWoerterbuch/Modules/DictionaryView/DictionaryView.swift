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
    @State private var isShowingAddWordView = false
    @ObservedObject var dictionaryViewModel: DictionaryViewModel
    
    
    var body: some View {
        NavigationStack(root: {
            List(content: {
                ForEach(dictionaryViewModel.wordCellViewModels, content: { cellVm in
                    NavigationLink(destination: {
                        AddWordView(viewModel: cellVm.getEditWordViewModel())
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
            })
            .navigationDestination(isPresented: $isShowingAddWordView, destination: {
                AddWordView(viewModel: dictionaryViewModel.getAddWordViewModel())
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
        isShowingAddWordView = true
    }
}

#Preview {
    DictionaryView(dictionaryViewModel: DictionaryViewModel(dataStorage: DataStorage(container: try! ModelContainer(for: Word.self))))
}
