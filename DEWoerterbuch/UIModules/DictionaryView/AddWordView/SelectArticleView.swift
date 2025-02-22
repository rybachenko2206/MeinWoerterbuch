//
//  SelectArticleView.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 19.02.25.
//

import SwiftUI

struct SelectArticleView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    
    @Binding var article: Article
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List(content: {
                Picker("Select Article", selection: $article, content: {
                    ForEach(Article.allCases, content: { item in
                        Text(item.rawValue)
                            .font(.system(size: 18, weight: .medium))
                    })
                })
                .pickerStyle(.inline)
                .onChange(of: article) { _, _ in
                    // Dismiss the view when a new value is selected
                    dismiss()
                }
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Select Article")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var _article: Article = .notSelected
    SelectArticleView(article: $_article)
}
