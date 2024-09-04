//
//  Category.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 22.08.24.
//

import Foundation

class Category {
    let name: String
    
    init?(name: String) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        self.name = name
    }
}
