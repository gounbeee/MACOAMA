//
//  MathSubjectRootView.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/04.
//

import SwiftUI



struct MathSubjectRootView: View {
    
    
    var jsonText : String = "Initial"
    
    @Binding var newWindowWidth : String
    @Binding var newWindowHeight : String
    
    @ObservedObject var mathSbjCtr = MathSubjectController()
    
    
    init(jsonText: String, newWindowWidth : Binding<String>, newWindowHeight: Binding<String>) {
        
        self.jsonText = jsonText
        
        // Bindingプロパティを初期化
        // https://stackoverflow.com/questions/56973959/swiftui-how-to-implement-a-custom-init-with-binding-variables
        self._newWindowWidth = newWindowWidth
        self._newWindowHeight = newWindowHeight
        
        // コントローラーをセットアップ
        mathSbjCtr.jsonText = jsonText
        mathSbjCtr.parseJson()
        
        mathSbjCtr.currentWindowWidthStr = self.newWindowWidth
        mathSbjCtr.currentWindowHeightStr = self.newWindowHeight
        
    }
    
    
    
    var body: some View {
        
        
        MathSubjectView(controller: mathSbjCtr)
        
        
        
        
    }
    
    
    
    
    
    
    
}

