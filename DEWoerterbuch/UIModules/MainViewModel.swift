//
//  MainViewModel.swift
//  DEWoerterbuch
//
//  Created by Roman Rybachenko on 27.09.24.
//

import Foundation
import SwiftData

@MainActor
class MainViewModel: ObservableObject {
    private let dataStorage: PDataStorage
    
    lazy var dictionaryViewModel: DictionaryViewModel = DictionaryViewModel(dataStorage: dataStorage)
    
    init(dataStorage: PDataStorage) {
        self.dataStorage = dataStorage
    }
    
}
