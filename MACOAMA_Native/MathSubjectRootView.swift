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
    @ObservedObject private var bleControls : BluetoothController
    
    
    
    var jsonText : String = "Initial"
    
    @Binding var newWindowWidth : String
    @Binding var newWindowHeight : String
    
    @ObservedObject var mathSbjCtr = MathSubjectController()
    
    
    init(jsonText: String, newWindowWidth : Binding<String>, newWindowHeight: Binding<String>) {
        
        
        let bleController = BluetoothController()
        self.bleControls = bleController
        
        
        
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
        
        Button("端末に繋げる") {
            // ----------------------------------------------------------------------
            BluetoothConnectionVM(mathSbjCtr: self.mathSbjCtr, bleCtr: self.bleControls )
                .openNewWindow( title: "Bluetooth連結",
                                width: 400,
                                height: 800)
        }
        .buttonStyle(.plain)
        .controlSize(.large)
        .frame(width: 800, height: 60)
        .font(.title)
        .foregroundColor(.pink)
        
        
        
        MathSubjectView(controller: mathSbjCtr)
        

        
    }
    
    
    
    
    
    
    
}

