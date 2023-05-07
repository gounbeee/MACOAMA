//
//  MathSubjectEditCreateView.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/07.
//

import SwiftUI

struct MathSubjectEditCreateView: View {
    
    @ObservedObject var ctr : MathSubjectController
    
    
    var body: some View {
        
        Button("新規Subject") {
            
            self.ctr.addNewSubject()
            
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        
        
        Button("新規要素") {
            
            self.ctr.addNewElement()
            
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        
    }
}
