//
//  MathSubjectView.swift
//  MACOAMA
//
//  Created by Si Young Choi on 2023/04/22.
//

import SwiftUI



struct MathSubjectView: View {
    
    @ObservedObject var controller : MathSubjectController
    

    var jsonText : String = "Initial"


    var body: some View {
        
        HStack (alignment: .top) {
            
            MathSubjectCommandView(ctr: self.controller)
                .frame(width: 400)
                .padding()
            
            
            MathSubjectCreatePageView(controller: self.controller)
                .frame(width: MathSubjectController.ElementWidth)
                .padding()
   
            
        }
        
        
        
    }
    
    
}




