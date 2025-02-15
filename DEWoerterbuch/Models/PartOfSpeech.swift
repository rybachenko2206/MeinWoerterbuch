//
//  PartOfSpeech.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 15.02.25.
//

import Foundation

enum PartOfSpeech: String, CaseIterable, Codable {
    case noun
    case verb
    case adjective
    case adverb
    case pronoun
    case preposition
    case conjunction
    case particle
    case interjection
    case phrase // for idioms or expressions
    
    var description: String {
        switch self {
        case .noun: return "Nomen (Іменник)"
        case .verb: return "Verb (Дієслово)"
        case .adjective: return "Adjektiv (Прикметник)"
        case .adverb: return "Adverb (Прислівник)"
        case .pronoun: return "Pronomen (Займенник)"
        case .preposition: return "Präposition (Прийменник)"
        case .conjunction: return "Konjunktion (Сполучник)"
        case .particle: return "Partikel (Частка)"
        case .interjection: return "Interjektion (Вигук)"
        case .phrase: return "Phrase (Фраза)"
        }
    }
}
