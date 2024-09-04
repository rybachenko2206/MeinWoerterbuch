//
//  DictionaryView.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 23.08.24.
//

import SwiftUI

typealias DictionaryViewModel = MainView.DictionaryViewModel

struct DictionaryView: View {
    @State private var isShowingAddWordView = false
    var dictionaryViewModel: DictionaryViewModel
    
    
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
                .onDelete(perform: dictionaryViewModel.deleteWords)
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
        })
    }
    
    // MARK: - Actions
    private func addWord() {
        isShowingAddWordView = true
    }
}

#Preview {
    DictionaryView(dictionaryViewModel: DictionaryViewModel.previewVM)
}
