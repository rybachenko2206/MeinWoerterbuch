//
//  PartOfSpeech.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 15.02.25.
//

import Foundation

enum PartOfSpeech: String, CaseIterable, Codable {
    case notSelected
    case noun
    case verb
    case adjective
    case adverb
    case pronoun
    case preposition
    case conjunction
    case particle
    case interjection
    case numerale
    case phrase // for idioms or expressions
    
    static var allCases: [PartOfSpeech] = [
        .noun, .verb, .adjective, .adverb, .pronoun, .preposition, .conjunction, .particle, .interjection, .numerale, .phrase
    ]
    
    var description: String {
        switch self {
        case .notSelected: return "Select part of speech"
        case .noun: return "Nomen"
        case .verb: return "Verb"
        case .adjective: return "Adjektiv"
        case .adverb: return "Adverb"
        case .pronoun: return "Pronomen"
        case .preposition: return "Präposition"
        case .conjunction: return "Konjunktion"
        case .particle: return "Partikel"
        case .interjection: return "Interjektion"
        case .numerale: return "Numerale"
        case .phrase: return "Phrase"
        }
    }
    
    var uaDescription: String? {
        // TODO: Think about getting this value using localization.
        switch self {
        case .notSelected: return nil
        case .noun: return "Іменник"
        case .verb: return "Дієслово"
        case .adjective: return "Прикметник"
        case .adverb: return "Прислівник"
        case .pronoun: return "Займенник"
        case .preposition: return "Прийменник"
        case .conjunction: return "Сполучник"
        case .particle: return "Частка"
        case .interjection: return "Вигук"
        case .numerale: return "Числівник"
        case .phrase: return "Фраза"
        }
    }
    
    var sampleDE: String {
        switch self {
        case .notSelected: return ""
        case .noun: return "der Tisch, das Buch, die Stadt, das Glück, das Wasser"
        case .verb: return "lesen, schreiben, arbeiten, rennen, lieben"
        case .adjective: return " schön, schnell, klug, fröhlich, kalt"
        case .adverb: return "schnell, gut, laut, weit, immer"
        case .pronoun: return "ich, du, er, sie, wir, sie, mein, dein"
        case .preposition: return "in, auf, vor, nach, zwischen"
        case .conjunction: return "und, aber, weil, denn, oder"
        case .particle: return "nicht, doch, mal, ja, bloß"
        case .interjection: return "oh, ach, äh, na, pfui"
        case .numerale: return "eins, zwei, fünf, zehn, hundert"
        case .phrase: return ""
        }
    }
}

extension PartOfSpeech: Identifiable {
    var id: Self { self }
}
