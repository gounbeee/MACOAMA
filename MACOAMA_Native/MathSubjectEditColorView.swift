//
//  MathSubjectEditColorView.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/07.
//

import SwiftUI

struct MathSubjectEditColorView: View {
    
    
    @Binding var el : MathPageTextElemIdFied
    
    
    var body: some View {
        
        Text("Color")
        Text($el.element.color.red.wrappedValue.formatted())
        Text($el.element.color.green.wrappedValue.formatted())
        Text($el.element.color.blue.wrappedValue.formatted())
        Text($el.element.color.opacity.wrappedValue.formatted())

        Text("BgColor")
        Text($el.element.bgColor.red.wrappedValue.formatted())
        Text($el.element.bgColor.green.wrappedValue.formatted())
        Text($el.element.bgColor.blue.wrappedValue.formatted())
        Text($el.element.bgColor.opacity.wrappedValue.formatted())
        
    }
}

