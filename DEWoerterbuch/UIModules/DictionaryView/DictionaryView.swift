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
    @State private var activeSheet: Sheet?
    
    @State private var showExistingWordDetails = false
    
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
    
    @State var isActive = false
    
    // MARK: - Views
    private var listContent: some View {
        // FIXME: if code with cell item index is unused - delete it
//        List(content: {
//            ForEach(
//                Array(dictionaryViewModel.filtereWordViewModels.enumerated()),
//                id: \.element.id,
//                content: { tuple in
//                    let index: Int = tuple.offset
//                    let cellVm: WordCellViewModel = tuple.element
//                    
//                    NavigationLink(
//                        destination: {
//                            NewWordView(viewModel: cellVm.getEditWordViewModel())
//                        },
//                        label: {
//                            HStack(alignment: .top) {
//                                if !dictionaryViewModel.isSearching {
//                                    Text("\(index + 1).")
//                                        .font(.system(size: 19, weight: .regular))
//                                        .foregroundColor(.primary)
//                                }
//                                
//                                WordCellView(viewModel: cellVm)
//                            }
//                        }
//                    )
//                }
//            )
//            .onDelete(perform: { indexSet in
//                Task {
//                    await dictionaryViewModel.deleteWords(in: indexSet)
//                }
//            })
            
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
        Button(action: {
            activeSheet = .addNewWord
        }, label: {
            Image(systemName: "plus")
        })
        .fullScreenCover(item: $activeSheet, content: { item in
            switch item {
            case .addNewWord:
                NavigationStack(root: {
                    NewWordView(viewModel: dictionaryViewModel.getAddWordViewModel())
                })
            }
        })
    }
    
    // MARK: - Private funcs
    private func fetchData() {
        Task {
            await dictionaryViewModel.fetchData()
        }
    }
}

#Preview {
    DictionaryView(dictionaryViewModel: DictionaryViewModel(dataStorage: DataStorage(container: try! ModelContainer(for: Word.self))))
}

extension DictionaryView {
    enum Sheet: String, Identifiable {
        case addNewWord
        
        var id: Self { self }
    }
}
