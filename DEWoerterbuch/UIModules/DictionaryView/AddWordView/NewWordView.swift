//
//  NewWordView.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 23.08.24.
//

import SwiftUI

struct NewWordView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: WordViewModel
    
    @State private var activeSheet: Sheet?
    
    @FocusState private var focusedField: FocusedField?
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List(content: {
                firstSeection()
                additionalInfoSection()
                partOfSpeechSection()
                partOfSpeechDetalisSection()
                mainButtonSection()
            })
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent()
                keyboardToolbarContent()
            }
            .sheet(item: $activeSheet, content: { item in
                switch item {
                case .selectPartOfSpeech:
                    partOfSpeechSheet()
                case .selectArticle:
                    selectArticleSheet()
                }
            })

        }
    }
    
    // MARK: - ViewBuilder funds
    @ViewBuilder
    private func firstSeection() -> some View {
        Section(content: {
            TextField(viewModel.valuePlaceholder, text: $viewModel.wordValue)
                .font(.headline)
                .focused($focusedField, equals: .word)
            TextField(viewModel.translationPlaceholder, text: $viewModel.translation)
                .focused($focusedField, equals: .translation)
        })
    }
    
    @ViewBuilder
    private func additionalInfoSection() -> some View {
        Section(content: {
            ExpandableTextView(viewModel.addInfoPlaceholder, text: $viewModel.additionalInfo)
                .frame(minHeight: 80)
        }, header: {
            Text("Additional info")
        })
    }
    
    @ViewBuilder
    private func partOfSpeechSection() -> some View {
        Section(content: {
            Button(action: {
                activeSheet = .selectPartOfSpeech
            }, label: {
                HStack(content: {
                    Text(viewModel.partOfSpeech.description)
                        .font(.title2)
                        .foregroundColor(.black)
                    
                    if viewModel.partOfSpeech != .notSelected {
                        Spacer()
                        
                        Text("part of speech")
                            .font(.system(size: 16, weight: .thin))
                            .foregroundColor(.secondary)
                    }
                })
            })
        })
    }
    
    @ViewBuilder
    private func partOfSpeechDetalisSection() -> some View {
        Section(content: {
            switch viewModel.partOfSpeech {
            case .noun:
                Button(action: {
                    activeSheet = .selectArticle
                }, label: {
                    HStack(content: {
                        Text(viewModel.selectedArticle.description)
                            .font(.title3)
                            .foregroundColor(.black)
                        
                        if viewModel.selectedArticle != .notSelected {
                            Spacer()
                            
                            Text("Article")
                                .font(.system(size: 16, weight: .thin))
                                .foregroundColor(.secondary)
                        }
                    })
                })
                
                TextField(viewModel.pluralPlaceholder, text: $viewModel.pluralForm)
                        .font(.title3)
                        .focused($focusedField, equals: .nomenPlural)
                
            case .verb:
                TextField(viewModel.praeteritumPlaceholder, text: $viewModel.praeteritum)
                    .font(.title3)
                    .focused($focusedField, equals: .praeteritum)
                TextField(viewModel.partizip2Placeholder, text: $viewModel.partizip2)
                    .font(.title3)
                    .focused($focusedField, equals: .partizip2)
                
            case .adjective,
                    .adverb:
                TextField(viewModel.komparativPlaceholder, text: $viewModel.komparativ)
                    .font(.title3)
                    .focused($focusedField, equals: .komparativ)
                TextField(viewModel.superlativPlaceholder, text: $viewModel.superlativ)
                    .font(.title3)
                    .focused($focusedField, equals: .superlativ)
                
            default:
                EmptyView()
            }
        })
    }
    
    @ViewBuilder
    private func mainButtonSection() -> some View {
        Section(content: {
            EmptyView()
        }, footer: {
            Button(viewModel.saveButtonTitle, action: {
                viewModel.saveAction()
                dismiss()
            })
            .buttonStyle(MainButton.style)
            .padding(.horizontal, 25)
            .disabled(!viewModel.isSaveButtonEnabled)
        })
        
    }
    
    // MARK: Sheets
    @ViewBuilder
    private func partOfSpeechSheet() -> some View {
        SelectPartOfSpeechView(selectedPartOfSpeech: $viewModel.partOfSpeech)
    }
    
    @ViewBuilder
    private func selectArticleSheet() -> some View {
        SelectArticleView(article: $viewModel.selectedArticle)
            .presentationDetents([.fraction(0.35)])
    }
    
    // MARK: - Private funcs
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Dismiss") {
                dismiss()
            }
        }
    }
    
    private func keyboardToolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .keyboard) {
            HStack {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
    }
        
}

#Preview {
    NewWordView(viewModel: WordViewModel.previewVM)
}


extension NewWordView {
    enum FocusedField: Int, CaseIterable {
        case word
        case translation
        case additionalInfo
        case nomenPlural
        case praeteritum
        case partizip2
        case komparativ
        case superlativ
    }
    
    enum Sheet: String, Identifiable {
        case selectPartOfSpeech
        case selectArticle
        
        var id: Self { return self }
    }
}

struct MainButton: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 9, leading: 50, bottom: 9, trailing: 50))
            .font(Font(UIFont.systemFont(ofSize: 23, weight: .medium)))
            .background(
                isEnabled ? Color(uiColor: UIColor.systemOrange) : Color(uiColor: UIColor.lightGray)
            )
            .foregroundStyle(.white)
            .cornerRadius(10)
            .disabled(!self.isEnabled)
            .opacity(isEnabled ? 1 : 0.6)
    }
    
    static var style: MainButton { .init() }
}
