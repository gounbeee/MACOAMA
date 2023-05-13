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
    
    
    var jsonText : String = "Initial"
    
    @Binding var newWindowWidth : String
    @Binding var newWindowHeight : String
    
    
    
    
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
        
        // ここでデバックモードを切り替えている
        mathSbjCtr.isEditMode = false
    }
    
    
    
    var body: some View {
        
        Button("コントローラを開く") {

            
            BluetoothMathRouteVM(bleControls: self.bleControls,
                                 mathSbjCtr: self.mathSbjCtr,
                                 synthCtr: self.synthCtr,
                                 linkCtr: self.linkCtr)
                .openNewWindow( title: "コントローラ",
                                xPos: 0,
                                yPos: 0,
                                width: 400,
                                height: 400,
                                isCenter: true)
            
        }
        .buttonStyle(.plain)
        .font(.title2)
        .foregroundColor(.pink)
        .padding(EdgeInsets(top: 15.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
        
        
        MathSubjectView(controller: self.mathSbjCtr, synthCtr: self.synthCtr, linkCtr: self.linkCtr)
        

        
    }
    
    
    
    
    
    
    
}

