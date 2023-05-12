//
//  MathSubjectLinkView.swift
//  COARAMAUSE
//
//  Created by Si Young Choi on 2023/05/12.
//

import SwiftUI



struct MathSubjectLinkView: View {
    
    @State var windowWidth : Int
    @State var windowHeight : Int
    
    @ObservedObject var controller : MathSubjectController
    @ObservedObject var synthCtr : SynthController
    @ObservedObject var linkCtr : MathSubjectLinkController
 
    
    var body: some View {
        
        HStack (alignment: .top) {
            
            
            MathSubjectCreatePageView(controller: self.controller, synthCtr: self.synthCtr, linkCtr: self.linkCtr)
                .scaleEffect(x: 0.5, y: 0.5)
                .frame(width: Double(self.windowWidth), height: Double(self.windowHeight))
                
                
            
            
            
            
        }
        
        
        
    }
    
    
    
    
}


