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
    @ObservedObject var windowCtr : MathSubjectWindowController
    @ObservedObject var blueToothCtr : BluetoothController
 
    init(windowWidth: Int, windowHeight: Int, controller: MathSubjectController, synthCtr: SynthController, linkCtr: MathSubjectLinkController, windowCtr: MathSubjectWindowController, blueToothCtr: BluetoothController) {
        self.windowWidth = windowWidth
        self.windowHeight = windowHeight
        self.controller = controller
        self.synthCtr = synthCtr
        self.linkCtr = linkCtr
        self.windowCtr = windowCtr
        self.blueToothCtr = blueToothCtr
        // 同じ教材ウィンドウを表示するが、ここではクリックで新規教材を開くことはできなくさせたい。
        self.controller.isLinkedView = true
        
        
        //print(self.controller.subjectNo)
        
    }
    
    
    var body: some View {
        
        HStack (alignment: .top) {
            ZStack {
                
                MathSubjectCreatePageView(controller: self.controller,
                                          synthCtr: self.synthCtr,
                                          linkCtr: self.linkCtr,
                                          windowCtr: self.windowCtr,
                                          isSubjectVisible: false,
                                          isPageVisible: true,
                                          subjectSpecified: self.linkCtr.subjectNo,
                                          blueToothCtr: self.blueToothCtr,
                                          isFinalExport: false)
                .scaleEffect(x: 0.5, y: 0.5)
                .frame(width: Double(self.windowWidth), height: Double(self.windowHeight))
                
                
                
            }
        }
   
    }
  
}


