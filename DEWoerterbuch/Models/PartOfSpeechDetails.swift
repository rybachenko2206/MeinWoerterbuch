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
    var article: Article?
    var plural: String?
    
    // For verbs: conjugations
    var praeteritum: String?
    var partizip2: String?
    var requiresDativ: Bool?
    
    // For adjectives: comparative & superlative
    var komparable: Bool?
    var komparativ: String?
    var superlativ: String?
    
    // MARK: - Init
    init?(
        partOfSpeech: PartOfSpeech,
        article: Article? = nil,
        plural: String? = nil,
        praeteritum: String? = nil,
        partizip2: String? = nil,
        requiresDativ: Bool? = nil,
        isKomparable: Bool? = nil,
        komparativ: String? = nil,
        superlativ: String? = nil
    ) {
        self.partOfSpeech = partOfSpeech
        
        switch partOfSpeech {
        case .notSelected:
            return nil
        case .noun:
            self.article = article
            self.plural = plural
        case .verb:
            self.praeteritum = praeteritum
            self.partizip2 = partizip2
            self.requiresDativ = requiresDativ
        case .adjective,
                .adverb:
            self.komparable = isKomparable
            self.komparativ = komparativ
            self.superlativ = superlativ
        default:
            break
        }
    }
    
    func isEmpty() -> Bool {
        guard partOfSpeech != .notSelected else { return true }
        
        if let article, article != .notSelected {
            return false
        }
        
        if let plural, !plural.isBlank {
            return false
        }
        
        if let praeteritum, !praeteritum.isBlank {
            return false
        }
        
        if let partizip2, !partizip2.isBlank {
            return false
        }
        
        if let komparativ, !komparativ.isBlank {
            return false
        }
        
        if let superlativ, !superlativ.isBlank {
            return false
        }
        
        return true
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
