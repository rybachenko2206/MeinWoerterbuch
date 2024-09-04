//
//  Word.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 22.08.24.
//

import Foundation
import SwiftData

@Model
class Word {
    let id: String
    
    // german word
    var value: String
    
    // your language translation
    var translation: String
    
    // any additional information, as synonim(s), past version for verbs, articles for noun etc
    var additionalInfo: String
    var additionalInfo2: String
    
    // from 0 to 100
    var learningProgress: Int
    
    // createdAt is added for sorting
    var updatedAt: Date
    
    // MARK: - Init
    init(value: String, translation: String, additionalInfo: String = "", learningProgress: Int = 0) {
        self.id = UUID().uuidString
        self.value = value
        self.translation = translation
        self.additionalInfo = additionalInfo
        self.additionalInfo2 = ""
        self.learningProgress = learningProgress
        self.updatedAt = .now
    }
}
