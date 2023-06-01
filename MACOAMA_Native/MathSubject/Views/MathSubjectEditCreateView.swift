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
        
        Text("要素の編集").font(.system(size: 18))
        
        
        HStack {
            
            Button("新規サブジェクト") {
                
                self.ctr.addNewSubject()
                self.ctr.renameElemTitleWithIndex()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            
            Button("新規ページ") {
                
                self.ctr.addNewPage()
                self.ctr.renameElemTitleWithIndex()
                
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            
            Button("新規要素") {
                
                self.ctr.addNewElement()
                self.ctr.renameElemTitleWithIndex()
                
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            
        }
    }
}
