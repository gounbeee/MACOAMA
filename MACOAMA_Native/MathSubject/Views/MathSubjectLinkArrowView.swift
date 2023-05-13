//
//  MathSubjectLinkArrowView.swift
//  COARAMAUSE
//
//  Created by Si Young Choi on 2023/05/13.
//

import SwiftUI

struct MathSubjectLinkArrowView: View {
    
    @ObservedObject var controller : MathSubjectController
    @ObservedObject var windowCtr : MathSubjectWindowController

    @State var position : CGPoint = CGPoint(x: 0.0, y: 0.0)
    @State var opacity: Double = 0.3
    
    
    init(position: CGPoint, controller: MathSubjectController, windowCtr: MathSubjectWindowController, opacity: Double) {
        self.position = position
        self.controller = controller
        self.windowCtr = windowCtr
        self.opacity = opacity
        
        // 新しく生成されたウィンドウと、メインのウィンドウの位置から、角度を計算する
        // 結果は、コントローラが持つ
        self.windowCtr.calcDegreeBetweenTwoPoints()
        
    }
    
    
    var body: some View {
        
        VStack {
            
            // アニメーション
            // https://note.com/hakotensan/n/n655fae5501ea
            
            
            Image(systemName: "arrowshape.forward.fill")
                .font(.system(size: 180))
                .foregroundColor(.red)
                .rotationEffect(.degrees(self.windowCtr.arrowRotation))
                .position(self.position)
                .opacity(self.opacity)
                .transition(.opacity)
//                .onAppear {
//                    withAnimation( .interpolatingSpring(stiffness: 5.0, damping: 0.0)) {
//                    //withAnimation( .easeInOut(duration: 2.0)) {
//                        self.opacity = 0.2
//                        //self.rotationDeg = -180.0
//                    }
//                }

            
        }
    }
    
    
    
    
}

