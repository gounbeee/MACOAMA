//
//  Extensions.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/03.
//

import Foundation
import SwiftUI




// Stringの中で特定の文字のINDEX番号を調べる
// https://stackoverflow.com/questions/24029163/finding-index-of-character-in-swift-string
public extension String {
  func indexInt(of char: Character) -> Int? {
    return firstIndex(of: char)?.utf16Offset(in: self)
  }
}



struct IntDoubleBinding {
    let intValue : Binding<Int>
    
    let doubleValue : Binding<Double>
    
    init(_ intValue : Binding<Int>) {
        self.intValue = intValue
        
        self.doubleValue = Binding<Double>(get: {
            return Double(intValue.wrappedValue)
        }, set: {
            intValue.wrappedValue = Int($0)
        })
    }
}




extension CGPoint {
    
    
    
    func toStrTuple() -> (String?, String?) {
        return ("\(x)", "\(y)")
    }
    

}


// 文字列を初期化で入力され、Bindingタイプを返すように拡張
// https://stackoverflow.com/questions/63341176/optional-extension-with-custom-binding-in-swiftui
extension Binding where Value == String? {
    var optionalBinding: Binding<String> {
        .init(
            get: {
                self.wrappedValue ?? ""
            }, set: {
                self.wrappedValue = $0
            }
        )
    }
}
