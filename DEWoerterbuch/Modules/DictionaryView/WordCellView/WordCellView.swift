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
            Text(viewModel.value)
                .font(.headline)
            Text(viewModel.translation)
                .font(.subheadline)
        })
    }
}

#Preview {
    WordCellView(viewModel: WordCellViewModel.previewObject)
}
