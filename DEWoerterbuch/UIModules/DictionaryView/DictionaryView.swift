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
            listContent
                .navigationTitle(dictionaryViewModel.title)
                .searchable(text: $dictionaryViewModel.searchText)
                .toolbar(content: {
                    toolbarContent
                })
                .onAppear(perform: {
                    fetchData()
                })
        })
    }
    
    // MARK: - Views
    private var listContent: some View {
        List(content: {
            ForEach(dictionaryViewModel.filtereWordViewModels, content: { cellVm in
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
        
    }
    
    private var toolbarContent: some View {
        Button(action: addWord, label: {
            Image(systemName: "plus")
        })
        .fullScreenCover(isPresented: $showAddWordModalView, content: {
            NavigationStack(root: {
                NewWordView(viewModel: dictionaryViewModel.getAddWordViewModel())
            })
        })
    }
    
    // MARK: - Private funcs
    
    // MARK: - Actions
    private func addWord() {
        showAddWordModalView = true
    }
    
    private func fetchData() {
        Task {
            await dictionaryViewModel.fetchData()
        }
    }
}

#Preview {
    DictionaryView(dictionaryViewModel: DictionaryViewModel(dataStorage: DataStorage(container: try! ModelContainer(for: Word.self))))
}
