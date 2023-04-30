//
//  ParsedJson.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/04/30.
//

import Foundation


// @ObservableObjectを使用する
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-observedobject-to-manage-state-from-external-objects
class ParsingJson : ObservableObject {
    
    @Published var jsonText : String = "Default Json Text"
    @Published var value : MathSubjectResponse? = nil
        
}
