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
        
    }
    
    
    
    var body: some View {
        
        Button("コントローラを開く") {

            
            BluetoothMathRouteVM(bleControls: self.bleControls,
                                 mathSbjCtr: self.mathSbjCtr,
                                 synthCtr: self.synthCtr)
                .openNewWindow( title: "コントローラ",
                                width: 400,
                                height: 800)
            
        }
        .buttonStyle(.plain)
        .controlSize(.large)
        .frame(width: 800, height: 60)
        .font(.title)
        .foregroundColor(.pink)
        
        
        
        MathSubjectView(controller: self.mathSbjCtr, synthCtr: self.synthCtr)
        

        
    }
    
    
    
    
    
    
    
}

