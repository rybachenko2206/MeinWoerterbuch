//
//  WordCellView.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 22.08.24.
//

import SwiftUI

struct WordCellView: View {
    var viewModel: WordCellViewModel
    
    var body: some View {
        VStack(alignment: .leading, content: {
            // Word
            HStack(spacing: 3, content: {
                if let article = viewModel.article {
                    Text(article)
                        .font(.system(size: 19, weight: .regular))
                        .foregroundColor(.primary)
                }
                
                Text(viewModel.value)
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(.primary)
            })
            
            // Plural form of .noun
            if let pluralForm = viewModel.pluralForm {
                Text(pluralForm)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.primary)
            }
            
            // Comparable forms of .adjective or .adverb
            if let comparableForms = viewModel.comparableForms {
                Text(comparableForms)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.primary)
            }
            
            // past forms for verb
            if let verbPastForms = viewModel.verbPastForms {
                Text(verbPastForms)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.primary)
            }
            
            // Translation
            Text(viewModel.translation)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.primary)
        })
    }
}

#Preview {
    VStack(spacing: 8, content: {
        WordCellView(viewModel: WordCellViewModel.previewObject)
        WordCellView(viewModel: WordCellViewModel.previewObject2)
        WordCellView(viewModel: WordCellViewModel.previewObject3)
        WordCellView(viewModel: WordCellViewModel.previewObj4)
        WordCellView(viewModel: WordCellViewModel.previewObj5)
    })
    
}
