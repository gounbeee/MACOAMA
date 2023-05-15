//
//  TextTokenizer.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/09.
//

import Foundation

import NaturalLanguage


class TextProcessor : ObservableObject {
    
    
    @Published var inputText : String = "Initial Text"

    
    
    func detectLanguage(text: String) {
        
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        
        print("Language: \(recognizer.dominantLanguage?.rawValue ?? "unknown")")
        
    }
    
    
    // 自然言語処理を行う
    // https://qiita.com/mashunzhe/items/28c06eafc024954e4256
    func tokenize(text: String) -> [String] {
        //let unit = NLTokenUnit()
        //print(unit.Attributes.symbolic)
        
        let tokenizer = NLTokenizer(unit: .word)
        
        tokenizer.string = text
        
        let tokens = tokenizer.tokens(for: text.startIndex ..< text.endIndex)
        
        var textTokens: [String] = []
        
        for token in tokens {
            
            let tokenStartI = token.lowerBound
            
            let tokenEndI = token.upperBound
            
            let text = text[tokenStartI ..< tokenEndI]
            
            textTokens.append(String(text))
            
        }
        
        // print(textTokens)

        return textTokens
        
    }
    
    
    
    
    func tokenizeTest(text: String) {
        
        let tokenizer = NLTokenizer(unit: .word)
        
        tokenizer.string = text
        
        let tokens = tokenizer.tokens(for: text.startIndex ..< text.endIndex)
        
        var textTokens: [String] = []
        
        for token in tokens {
            
            let tokenStartI = token.lowerBound
            
            let tokenEndI = token.upperBound
            
            let text = text[tokenStartI ..< tokenEndI]
            
            textTokens.append(String(text))
            
        }
        
        print(textTokens)
        
        
    }
    
    
}
