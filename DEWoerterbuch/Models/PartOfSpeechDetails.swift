//
//  PartOfSpeechDetails.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 15.02.25.
//

import Foundation

struct PartOfSpeechDetails: Codable {
    // MARK: - Properties
    var partOfSpeech: PartOfSpeech
    
    // For nouns: definite article & plural form
    var article: Article = .notSelected
    var plural: String?
    
    // For verbs: conjugations
    var praeteritum: String?
    var partizip2: String?
    
    // For adjectives: comparative & superlative
    var komparativ: String?
    var superlativ: String?
    
    // MARK: - Init
    init(
        partOfSpeech: PartOfSpeech,
        article: Article? = nil,
        plural: String? = nil,
        praeteritum: String? = nil,
        partizip2: String? = nil,
        komparativ: String? = nil,
        superlativ: String? = nil
    ) {
        self.partOfSpeech = partOfSpeech
        self.article = article ?? .notSelected
        self.plural = plural
        self.praeteritum = praeteritum
        self.partizip2 = partizip2
        self.komparativ = komparativ
        self.superlativ = superlativ
        
        // Asserts for future, when UI to fill these values will be finished
//        assert(partOfSpeech == .noun && article == nil && plural == nil, "fill all fields")
//        assert(partOfSpeech == .verb && praeteritum == nil && partizip2 == nil)
//        assert(partOfSpeech == .adjective && komparativ == nil && superlativ == nil)
    }
}

enum Article: String, CaseIterable, Identifiable, Codable {
    case notSelected
    case der, die, das
    
    static var allCases: [Article] { [.der, .die, .das] }
    
    var description: String {
        switch self {
        case .notSelected: return "Select article"
        default: return self.rawValue
        }
    }
    
    var id: Self { return self }
}
