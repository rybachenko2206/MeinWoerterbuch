//
//  AddWordView.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 23.08.24.
//

import SwiftUI

struct AddWordView: View {
    @ObservedObject var viewModel: AddWordViewModel
    
    var body: some View {
        VStack {
            Form {
                TextField(viewModel.valuePlaceholder, text: $viewModel.wordValue)
                    .font(.headline)
                TextField(viewModel.translationPlaceholder, text: $viewModel.translation)
                
                Section {
                    TextField(viewModel.addInfoPlaceholder, text: $viewModel.additionalInfo)
                }
            }
            
            Button(action: {
                viewModel.saveButtonTapped()
            }, label: {
                Text("Save")
                    .font(.headline)
                    .padding(EdgeInsets(top: 10, leading: 36, bottom: 10, trailing: 36))
//                    .frame(width: 100)
                    .background(viewModel.isSaveButtonEnabled ? Color.blue : Color(uiColor: .systemGray5))
                    .foregroundColor(viewModel.isSaveButtonEnabled ? .white : Color(uiColor: .systemGray3))
                    .cornerRadius(.greatestFiniteMagnitude)
                
            })
            .disabled(!viewModel.isSaveButtonEnabled)
            
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        
        Spacer()
    }
}

#Preview {
    AddWordView(viewModel: AddWordViewModel.previewVM)
}
