//
//  NewWordView.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 23.08.24.
//

import SwiftUI

struct NewWordView: View {
    @ObservedObject var viewModel: WordViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20.0) {
                Form {
                    Section(content: {
                        TextField(viewModel.valuePlaceholder, text: $viewModel.wordValue)
                            .font(.headline)
                        TextField(viewModel.translationPlaceholder, text: $viewModel.translation)
                    })
                    
                    Section {
                        TextField(viewModel.addInfoPlaceholder, text: $viewModel.additionalInfo)
                    }
                }
                .frame(height: 250)
                
                Button(action: {
                    viewModel.saveButtonTapped()
                    dismiss()
                }, label: {
                    Text("Save")
                        .font(.headline)
                        .padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                        .background(viewModel.isSaveButtonEnabled ? Color.blue : Color(uiColor: .systemGray5))
                        .foregroundColor(viewModel.isSaveButtonEnabled ? .white : Color(uiColor: .systemGray3))
                        .cornerRadius(.greatestFiniteMagnitude)
                    
                })
                .disabled(!viewModel.isSaveButtonEnabled)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            .padding(.vertical, 20.0)
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
        
}

#Preview {
    NewWordView(viewModel: WordViewModel.previewVM)
}
