//
//  BluetoothMathRouteVM.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/11.
//

import SwiftUI

struct BluetoothMathRouteVM: View {
    
    /// BLUETOOTH VIEWMODEL
    @ObservedObject var bleControls : BluetoothController
    @ObservedObject var mathSbjCtr : MathSubjectController
    @ObservedObject var synthCtr : SynthController
    @ObservedObject var linkCtr : MathSubjectLinkController
    @ObservedObject var windowCtr : MathSubjectWindowController
    
    @State var isBluetoothUsed : Bool? = nil
    
    
    var body: some View {
        
        VStack {
            
            if isBluetoothUsed != nil {
                
                if isBluetoothUsed == true {
                                    
                    // ----------------------------------------------------------------------
                    BluetoothConnectionVM(mathSbjCtr: self.mathSbjCtr, synthCtr: self.synthCtr, bleCtr: self.bleControls, linkCtr: self.linkCtr, windowCtr: self.windowCtr)
                        .frame(alignment: .leading)

                } else if isBluetoothUsed == false {
                    
                    MathSubjectCommandView(ctr: self.mathSbjCtr, bluetoothCtr: self.bleControls, synthCtr: self.synthCtr)
                        .frame(alignment: .leading)
                }
                
            } else {
                
                Text("""
                     Bluetoothの使用許可をお願いします。
                     Bluetooth装置を検索し、COARAMAUSEを選択して下さい。
                     """)
                .frame(alignment: .center)
                

                
                Button("Bluetoothで繋げる") {

                    self.isBluetoothUsed = true

                }
                .buttonStyle(.plain)
                .controlSize(.large)
                .frame(width: 400, height: 60)
                .font(.title)
                .foregroundColor(.pink)
//
//
//                Button("端末なしで使用") {
//
//                    self.isBluetoothUsed = false
//
//                }
//                .buttonStyle(.plain)
//                .controlSize(.large)
//                //.frame(width: 800, height: 60)
//                .font(.title)
//                .foregroundColor(.pink)

            }
        
        }
        .frame(width: 400, height: 300)
        
        
    }
    
    
    
    
}

