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
    @ObservedObject var linkCtr : MathSubjectLinkController
    @ObservedObject var windowCtr : MathSubjectWindowController
    @ObservedObject var blueToothCtr : BluetoothController
    

    var jsonText : String = "Initial"


    var body: some View {

        MathSubjectCreatePageView(controller: self.controller,
                                  synthCtr: self.synthCtr,
                                  linkCtr: self.linkCtr,
                                  windowCtr: self.windowCtr,
                                  isSubjectVisible: true,
                                  isPageVisible: true,
                                  subjectSpecified: nil,
                                  blueToothCtr: self.blueToothCtr,
                                  isFinalExport: false)
   
    }

}




