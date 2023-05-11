//
//  MathSubjectView.swift
//  MACOAMA
//
//  Created by Si Young Choi on 2023/04/22.
//

import SwiftUI



struct MathSubjectView: View {
    
    @ObservedObject var controller : MathSubjectController
    @ObservedObject var synthCtr : SynthController
    

    var jsonText : String = "Initial"


    var body: some View {
        
        HStack (alignment: .top) {
            

            
            
            MathSubjectCreatePageView(controller: self.controller, synthCtr: self.synthCtr)
                .frame(width: MathSubjectController.ElementWidth)
                .padding()
   
            
        }
        
        
        
    }
    
    
}




