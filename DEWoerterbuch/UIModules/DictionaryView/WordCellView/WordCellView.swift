//
//  WordCellView.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 22.08.24.
//

import SwiftUI

struct WordCellView: View {
    // MARK: - Properties
    var viewModel: WordCellViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, content: {
            wordRow
            pluralFormRow
            comparableOrPastFormsRow
            translationRow
            summaryRow
        })
    }
    
    // MARK: - some View {
    var wordRow: some View {
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
    }
    
    @ViewBuilder
    var pluralFormRow: some View {
        if let pluralForm = viewModel.pluralForm {
            Text(pluralForm)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.primary)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    var comparableOrPastFormsRow: some View {
        // Comparable forms of .adjective or .adverb
        if let comparableForms = viewModel.comparableForms {
            Text(comparableForms)
                .font(.system(size: 17, weight: .medium))
                .lineLimit(1)
                .foregroundColor(.primary)
        }
        
        // past forms for verb
        if let verbPastForms = viewModel.verbPastForms {
            Text(verbPastForms)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.primary)
        }
    }
    
    var translationRow: some View {
        Text(viewModel.translation)
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(.primary)
    }
    
    @ViewBuilder
    var summaryRow: some View {
        if let summaryStr = viewModel.getWordGrammarSummary() {
            Text(summaryStr)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(uiColor: .secondaryLabel))
        } else {
            EmptyView()
        }
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
