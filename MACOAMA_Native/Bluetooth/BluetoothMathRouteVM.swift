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
    
    @State var isBluetoothUsed : Bool? = nil
    
    
    var body: some View {
        
        VStack {
            
            if isBluetoothUsed != nil {
                
                if isBluetoothUsed == true {
                                    
                    // ----------------------------------------------------------------------
                    BluetoothConnectionVM(mathSbjCtr: self.mathSbjCtr, synthCtr: self.synthCtr, bleCtr: self.bleControls )
                        .frame(alignment: .leading)

                } else if isBluetoothUsed == false {
                    
                    MathSubjectCommandView(ctr: self.mathSbjCtr, synthCtr: self.synthCtr, bluetoothCtr: self.bleControls)
                        .frame(alignment: .leading)
                }
                
            } else {
                
                
                Button("端末に繋げてから使用") {

                    self.isBluetoothUsed = true
   
                }
                .buttonStyle(.plain)
                .controlSize(.large)
                .frame(width: 800, height: 60)
                .font(.title)
                .foregroundColor(.pink)
                

                Button("端末なしで使用") {
                    
                    self.isBluetoothUsed = false
  
                }
                .buttonStyle(.plain)
                .controlSize(.large)
                .frame(width: 800, height: 60)
                .font(.title)
                .foregroundColor(.pink)

            }
        
        }
        .frame(width: 500, height: 800)
        
        
    }
    
    
    
    
}

