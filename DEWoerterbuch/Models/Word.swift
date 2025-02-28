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
    // MARK: - Properties
    private(set) var wordId: String
    
    // german word
    var value: String
    
    // your language translation
    var translation: String
    
    // any additional info which you would like to add (synonims, translation in other language etc
    var additionalInfo: String
    
    // examples of using etc.
    // this field will be shown likely in TextView
    var additionalInfo2: String
    
    // Part of speech details, including additional grammatical information
    var partOfSpeechDetails: PartOfSpeechDetails?
    
    // from 0 to 100
    var learningProgress: Int
    
    // createdAt is added for sorting
    var updatedAt: Date
    
    // MARK: - Init
    init(
        value: String,
        translation: String,
        additionalInfo: String = "",
        learningProgress: Int = 0,
        partOfSpeechDetails: PartOfSpeechDetails? = nil
    ) {
        self.wordId = UUID().uuidString
        self.value = value
        self.translation = translation
        self.partOfSpeechDetails = partOfSpeechDetails
        self.additionalInfo = additionalInfo
        self.additionalInfo2 = ""
        self.learningProgress = learningProgress
        self.updatedAt = .now
    }
    
}
