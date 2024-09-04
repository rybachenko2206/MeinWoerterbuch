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
}
