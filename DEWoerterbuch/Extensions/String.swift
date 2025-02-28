//
//  String.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 22.08.24.
//

import Foundation

extension String {
  var isBlank: Bool {
      return allSatisfy({ $0.isWhitespace }) && allSatisfy({ $0.isNewline })
  }
    
    static func isNilOrEmpty(_ string: String?) -> Bool {
        guard let str = string, !str.isEmpty else { return true }
        return false
    }
    
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        String.isNilOrEmpty(self)
    }
}
