//
//  BluetoothConnectionVM.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/10.
//

import SwiftUI



// MacOS でBluetoothをONにする
// Project settingで、App Sandbox でBluetoothにチェックを入れる
// https://stackoverflow.com/questions/47987219/macos-cbcentralmanager-state-unsupported



struct BluetoothScanButtonVM: View {

    @Binding var isScanning: Bool

    @State var bluetoothCtr : BluetoothController
    
    
    var body: some View {
        
        //MainIntroVM().padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
        
        
        Button(isScanning ? "STOP SCANNING" : "スキャンを開始") {
            self.isScanning.toggle()
            self.bluetoothCtr.startBluetoothScan()
            
        }
        .foregroundColor(Color.red)
        .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.1).delay( 50.0 ), value: 10)
        
    }
    
}






struct BluetoothConnectionVM: View {
    
    
    @ObservedObject var controller : MathSubjectController
    @ObservedObject var synthCtr : SynthController
    @ObservedObject var bluetoothCtr : BluetoothController
    @ObservedObject var linkCtr : MathSubjectLinkController
    @ObservedObject var windowCtr : MathSubjectWindowController
        
    /// FOR BLE CONNECTION CHECK
    @State var isScanning : Bool = false
    @State var isConnected : Bool = false
    
    
    
    init( mathSbjCtr: MathSubjectController, synthCtr: SynthController, bleCtr : BluetoothController, linkCtr: MathSubjectLinkController, windowCtr: MathSubjectWindowController) {
        
        self.controller = mathSbjCtr
        self.synthCtr = synthCtr
        
        /// PASSING TO MEMBER PROPERTY
        self.bluetoothCtr = bleCtr
        self.linkCtr = linkCtr
        self.windowCtr = windowCtr
        ///print(self.bluetoothCtr.peripheralNames)
        ///print("BluetoothConnectionVM IS INITIALIZED")

    }
    
    
    
    var body: some View {
        
        
        VStack {
            
            ///let _ = print(self.isScanning)
            
            
            /// FOR NEW CONNECTION TO PERIPHERAL
            if !self.isScanning && !self.isConnected {
                
                /// BUTTON FOR STARTING SCAN
                BluetoothScanButtonVM(isScanning: $isScanning, bluetoothCtr: self.bluetoothCtr)
                
            } else if self.isScanning && !self.isConnected {
                
                VStack {
                    
                    Text("Bluetoothを検索中")
                        .font(.headline)
                    
                    Text("Coaramauseを選択してください")
                        .font(.body)
                    
                }.padding(EdgeInsets(top: 40, leading: 0, bottom: 40, trailing: 0))
                
                /// -----------------------------------------------
                /// LISTING BLUETOOTH PERIPHERALS
                VStack (alignment: .center) {
                    
                    List(self.bluetoothCtr.peripheralNames,
                         id: \.self) { peripheralName in
                        
                        
                        /// WHEN PERIPHERAL'S NAME IS PRESSED
                        ///let _ = print(peripheralName)
                        Button(action: {
                            //print("BUTTON CLICKED  --  \(peripheralName)")
                            
                            /// print(bluetoothViewModel.peripherals)
                            
                            /// FOR EVERY PERIPHERALS,
                            self.bluetoothCtr.peripherals.forEach { periph in
                                
                                //print(periph)
                                
                                /// WE WILL CONNECT TO 'SELECTED NAME IN THE LIST'
                                if periph.name == peripheralName {
                                    
                                    /// REGISTER CURRENT PERIPHERAL
                                    self.bluetoothCtr.peripheral = periph
                                    
                                    /// CONNECT TO PERIPHERAL
                                    self.bluetoothCtr.centralManager?.connect(periph, options: nil)
                                    
                                    /// STOP SCANNING
                                    self.bluetoothCtr.centralManager?.stopScan()
                                    
                                    print("CONNECTED !!")
                                    
                                    self.isScanning  = false
                                    self.isConnected = true
                                    
                                    
                                    // Bluetooth 連結が成立
                                    // なのでWindowを閉じる
                                    //print(self.windowCtr.windowList.count)
                                    //print(self.windowCtr.windowList[0].title)
                                    //print(self.windowCtr.windowList[1].title)
                                    
                                    for windowObj in self.windowCtr.windowList {
                                        
                                        if windowObj.title == "コントローラ" {
                                            windowObj.close()
                                        }
                                        
                                    }

                                }
                            }
                            
                        }) {
                            Text(peripheralName)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        
                    }
                    .padding()
                    
                    
                }
                
                
                Button(action: {
                    print("RESET")
                    
                    /// STOP CURRENT SCANNING
                    self.bluetoothCtr.centralManager?.stopScan()
                    
                    /// FLAG INITIALIZING
                    self.isScanning  = false
                    self.isConnected = false
                    
                    
                }) {
                    Text("もう一度スキャンする")
                }
                .padding()
                
                
            }
            
            
        }
        
        
    }
        
    
    
    
    
    func toggleScanning() -> Void {
        
        ///print( "isScanning  IS   \(self._isScanning) ")
        
        if self._isScanning.wrappedValue == true {
            self._isScanning.wrappedValue = false
            print( "(IN if Statement :: Block 1) isScanning  IS   \(self._isScanning.wrappedValue) ")
            
            bluetoothCtr.stopBluetoothScan()

        } else {
            self._isScanning.wrappedValue = true
            print( "(IN if Statement :: Block 2) isScanning  IS   \(self._isScanning.wrappedValue) ")
            bluetoothCtr.startBluetoothScan()
        }

        print( "isScanning  IS  AFTER PROCESS ->  \(self._isScanning.wrappedValue) ")

    }
    
    
    
}







