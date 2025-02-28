//
//  PartOfSpeechDetails.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 15.02.25.
//

import Foundation

struct PartOfSpeechDetails: Codable {
    // MARK: - Properties
    private(set) var partOfSpeech: PartOfSpeech
    private(set) var nounDetails: NounDetails?
    private(set) var verbDetails: VerbDetails?
    private(set) var adjectiveDetails: AdjectiveDetails?
    
    // MARK: - Init
    init?(
        partOfSpeech: PartOfSpeech,
        nounDetails: NounDetails? = nil,
        verbDetails: VerbDetails? = nil,
        adjectiveDetails: AdjectiveDetails? = nil
    ) {
        guard partOfSpeech != .notSelected else { return nil }
        
        self.partOfSpeech = partOfSpeech
        
        switch partOfSpeech {
        case .notSelected:
            return nil
        case .noun:
            self.nounDetails = nounDetails
        case .verb:
            self.verbDetails = verbDetails
        case .adjective,
                .adverb:
            self.adjectiveDetails = adjectiveDetails
        default:
            break
        }
    }
    
    // MARK: - Public funcs
    func isEmpty() -> Bool {
        guard partOfSpeech != .notSelected else { return true }
        
        if nounDetails != nil || verbDetails != nil || adjectiveDetails != nil {
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

struct NounDetails: Codable {
    private(set) var article: Article?
    private(set) var plural: String?
    
    init?(article: Article? = nil, plural: String? = nil) {
        if (article == nil || article == .notSelected) && plural.isNilOrEmpty {
            return nil
        }
        
        self.article = article
        self.plural = plural
    }
}

struct VerbDetails: Codable {
    private(set) var praeteritum: String?
    private(set) var partizip2: String?
    private(set) var requiresDativ: Bool?
    private(set) var takesSein: Bool?
    
    init?(praeteritum: String? = nil, partizip2: String? = nil, requiresDativ: Bool? = nil, takesSein: Bool? = nil) {
        if praeteritum == nil && partizip2 == nil && requiresDativ == nil && takesSein == nil {
            return nil
        }
        
        self.praeteritum = praeteritum
        self.partizip2 = partizip2
        self.requiresDativ = requiresDativ
        self.takesSein = takesSein
    }
}

struct AdjectiveDetails: Codable {
    private(set) var isComparable: Bool?
    private(set) var komparativ: String?
    private(set) var superlativ: String?
    
    init?(isComparable: Bool? = nil, komparativ: String? = nil, superlativ: String? = nil) {
        if isComparable == nil && komparativ == nil && superlativ == nil {
            return nil
        }
        
        self.isComparable = isComparable
        self.komparativ = komparativ
        self.superlativ = superlativ
    }
}
