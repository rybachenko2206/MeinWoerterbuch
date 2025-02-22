//
//  SelectPartOfSpeechView.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 17.02.25.
//

import SwiftUI

struct SelectPartOfSpeechView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedPartOfSpeech: PartOfSpeech
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form(content: {
                Picker(selection: $selectedPartOfSpeech,
                       label: Text("Parts Of Speech"),
                       content: {
                    ForEach(PartOfSpeech.allCases) { item in
                        VStack(alignment: .leading) {
                            Text(item.description)
                                .font(.system(size: 20, weight: .medium))
                            Text(item.sampleDE)
                                .lineLimit(1)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        .tag(item)
                    }
                })
                .pickerStyle(.inline)
//                .labelsHidden()
//                .listRowInsets(EdgeInsets())
                .onChange(of: selectedPartOfSpeech) { _, _ in
                    // Dismiss the view when a new value is selected
                    dismiss()
                }
            })
            .navigationBarTitleDisplayMode(.inline)
//            .navigationTitle("Parts Of Speech")
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
    @Previewable @State var _selectedItem: PartOfSpeech = .noun
    SelectPartOfSpeechView(selectedPartOfSpeech: $_selectedItem)
}
