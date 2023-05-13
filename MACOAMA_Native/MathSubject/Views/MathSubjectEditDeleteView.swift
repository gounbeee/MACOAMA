//
//  MathSubjectEditDeleteView.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/07.
//

import SwiftUI

struct MathSubjectEditDeleteView: View {
    
    
    @Binding var deleteElemNo : String 
    @ObservedObject var ctr : MathSubjectController
    
    
    
    var body: some View {
        
        
        HStack {
            
            
            Button("サブジェクト削除") {
                
                self.ctr.deleteCurrentSubject()
                
                
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            
            Button("ページ削除") {

                self.ctr.deleteCurrentPage()
                
                
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            

        }
        
        
        HStack {

            TextField("削除する要素の番号", text: self.$deleteElemNo)

            Button("要素削除") {

                print("\(self.deleteElemNo)  を削除します")
                
                self.ctr.deleteElementWithNumber(num: Int(self.deleteElemNo)! - 1 )
                
                self.deleteElemNo = ""
                
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            

        }

        
    }
}

