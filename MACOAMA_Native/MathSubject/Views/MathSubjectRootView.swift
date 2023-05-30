//
//  MathSubjectRootView.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/04.
//

import SwiftUI

import Network
import CoreBluetooth




struct MathSubjectRootView: View {
    
    /// BLUETOOTH VIEWMODEL
    @ObservedObject private var bleControls : BluetoothController = BluetoothController()
    @ObservedObject private var synthCtr : SynthController = SynthController()
    @ObservedObject var mathSbjCtr = MathSubjectController()
    @ObservedObject var linkCtr = MathSubjectLinkController()
    @ObservedObject var windowCtr : MathSubjectWindowController
    
    
    var jsonText : String = "Initial"
    
    @Binding var newWindowWidth : String
    @Binding var newWindowHeight : String
    
    var isEditMode : Bool
    
    
    
    init(jsonText: String, newWindowWidth : Binding<String>, newWindowHeight: Binding<String>, windowCtr: MathSubjectWindowController, isEditMode: Bool) {
        

        self.jsonText = jsonText
        
        // Bindingプロパティを初期化
        // https://stackoverflow.com/questions/56973959/swiftui-how-to-implement-a-custom-init-with-binding-variables
        self._newWindowWidth = newWindowWidth
        self._newWindowHeight = newWindowHeight
        
        self.windowCtr = windowCtr
        self.isEditMode = isEditMode
        
        
        // コントローラーをセットアップ
        mathSbjCtr.jsonText = jsonText
        mathSbjCtr.parseJson()
        
        mathSbjCtr.currentWindowWidthStr = self.newWindowWidth
        mathSbjCtr.currentWindowHeightStr = self.newWindowHeight
        
        self.mathSbjCtr.isEditMode = isEditMode
        
    }
    
    
    
    var body: some View {
        
        
        
        Button(action: {
            
            BluetoothMathRouteVM(bleControls: self.bleControls,
                                 mathSbjCtr: self.mathSbjCtr,
                                 synthCtr: self.synthCtr,
                                 linkCtr: self.linkCtr,
                                 windowCtr: self.windowCtr)
                .openNewWindow( title: "コントローラ",
                                xPos: 0,
                                yPos: 0,
                                width: 400,
                                height: 400,
                                isCenter: true,
                                windowCtr: self.windowCtr,
                                view: nil)
            
        }) {
            
            Image(systemName: "network")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30).padding()
                .foregroundColor(.indigo)
                
                
        }
        .buttonStyle(.borderless)
        .padding(EdgeInsets(top: 15.0, leading: 0.0, bottom: -10.0, trailing: 0.0))

        
       
        
        MathSubjectView(controller: self.mathSbjCtr, synthCtr: self.synthCtr, linkCtr: self.linkCtr, windowCtr: self.windowCtr, blueToothCtr: self.bleControls)
        

        
    }
    
    
    
    
    
    
    
}

