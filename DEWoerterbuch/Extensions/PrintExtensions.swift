//
//  PrintExtensions.swift
//
//  Created by Roman Rybachenko on 4/14/17.
//  Copyright © 2017 Roman Rybachenko. All rights reserved.
//

import Foundation


func pl(_ value: Any?, file: String = #file, lineNumber: Int = #line) {
    #if DEBUG
        let fileName = fileName(from: file)
        
        let printValue: Any = value ?? "value is nil"
        print("\n~~ [\(fileName): \(lineNumber)]  \(printValue)\n")
    #endif
}

func pf(file: String = #file, functionName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
        let fileName = fileName(from: file)
    print("~~ [\(fileName), func: \(functionName): \(lineNumber)]")
    #endif
}

func pFile(file: String = #file) {
    #if DEBUG
        let fileName = fileName(from: file)
        print("~~ [\(fileName)]")
    #endif
}

func fileName(from path: String) -> String {
    let components = path.components(separatedBy: "/")
    guard let last = components.last else {
        return ""
    }
    
    return last
}


