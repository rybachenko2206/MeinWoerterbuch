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
    var nounDetails: NounDetails?
    var verbDetails: VerbDetails?
    var adjectiveDetails: AdjectiveDetails?
    
    // MARK: - Init
    init?(
        partOfSpeech: PartOfSpeech,
        nounDetails: NounDetails?,
        verbDetails: VerbDetails?,
        adjectiveDetails: AdjectiveDetails?
    ) {
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
    
    func isEmpty() -> Bool {
        guard partOfSpeech != .notSelected else { return true }
        
        if let article = nounDetails?.article, article != .notSelected {
            return false
        }
        
        if let plural = nounDetails?.plural, !plural.isBlank {
            return false
        }
        
        if let praeteritum = verbDetails?.praeteritum, !praeteritum.isBlank {
            return false
        }
        
        if let partizip2 = verbDetails?.partizip2, !partizip2.isBlank {
            return false
        }
        
        if let requiresDativ = verbDetails?.requiresDativ {
            return false
        }
        
        if let takesSein = verbDetails?.takesSein {
            return false
        }
        
        if let isComparable = adjectiveDetails?.isComparable {
            return false
        }
        
        if let komparativ = adjectiveDetails?.komparativ, !komparativ.isBlank {
            return false
        }
        
        if let superlativ = adjectiveDetails?.superlativ, !superlativ.isBlank {
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
    var article: Article?
    var plural: String?
}

struct VerbDetails: Codable {
    var praeteritum: String?
    var partizip2: String?
    var requiresDativ: Bool?
    var takesSein: Bool?
}

struct AdjectiveDetails: Codable {
    var isComparable: Bool?
    var komparativ: String?
    var superlativ: String?
}
