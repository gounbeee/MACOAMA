//
//  MathSubjectElement.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/04/28.
//

import SwiftUI



// 1つのエレメントずつ持つView
struct MathSubjectElementView: View {
    

    @ObservedObject var ctr : MathSubjectController
    @ObservedObject var elmCtr : MathSubjectElementController
    
    @GestureState var locationStore = CGPoint(x: 0, y: 0)
    
    var sbjNo : Int = 0
    var pgNo : Int = 0

    
    
    
    init(controller: MathSubjectController, elmController: MathSubjectElementController, elementInfo: MathPageTextElm) {
        self.ctr = controller
        //self.elemIndex = elemIndex
        self.sbjNo = controller.subjectNo
        self.pgNo = controller.pageNo
        
        // エレメントのコントロールのエレメント本体は差し替え
        self.elmCtr = elmController
        self.elmCtr.element = elementInfo
        
        controller.elmCtr = elmController
        
    }
    
    
    
    var body: some View {

        Text(self.elmCtr.element.content)
            .background(Color(red: Double(self.elmCtr.element.bgColor.red)/255,
                              green: Double(self.elmCtr.element.bgColor.green)/255,
                              blue: Double(self.elmCtr.element.bgColor.blue)/255,
                              opacity: Double(self.elmCtr.element.bgColor.opacity)/255))

            .font(Font.custom(self.elmCtr.element.font, size: self.elmCtr.element.size))
            .foregroundColor(Color(red: Double(self.elmCtr.element.color.red)/255,
                                   green: Double(self.elmCtr.element.color.green)/255,
                                   blue: Double(self.elmCtr.element.color.blue)/255,
                                   opacity: Double(self.elmCtr.element.color.opacity)/255))
            .textSelection( .disabled )
            .lineSpacing(self.elmCtr.element.size * 0.2)

            .offset(x: self.elmCtr.element.position.x * Double(self.ctr.currentWindowWidthStr)!  + self.elmCtr.differPos.x  ,
                    y: self.elmCtr.element.position.y * Double(self.ctr.currentWindowHeightStr)! + self.elmCtr.differPos.y )
        
            .gesture(
                
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                
                    // ドラッグする間、カーソルの次の位置を取得できる
                    .updating($locationStore) { currentState, pastLocation, transaction in
                        // print("----")
                        // print( "currentState.location IS  \(currentState.location)" )
                        // print( "pastLocation.location IS  \(pastLocation)" )
                        // print( "locationStore IS  \(locationStore)" )
                        
                        // ここで、新しい位置の情報を更新
                        pastLocation.x = currentState.location.x
                        pastLocation.y = currentState.location.y
                        
                                                
                        //transaction.animation = .easeInOut

                    }

                    .onChanged { state in

                        //print("---")
                        
                        // 最初にクリックした地点のピクセルの座標
                        //print( "state.startLocation IS  \(state.startLocation)" )
                        
                        // 現在の位置のピクセル座標
                        //print( "state.location IS  \(state.location)" )
                        
                        // 移動距離の差分
                        // state.startLocation + state.translation = state.location
                        //print( "state.translation IS   \(state.translation)")
                        
                        // 差分位置を計算
                        self.elmCtr.differPos.x = state.location.x - state.startLocation.x
                        self.elmCtr.differPos.y = state.location.y - state.startLocation.y
                        


                    }
                    .onEnded { state in
                        

                        // 差分の比率を計算して更新
                        self.elmCtr.element.position.x += self.elmCtr.differPos.x / Double(self.ctr.currentWindowWidthStr)!
                        self.elmCtr.element.position.y += self.elmCtr.differPos.y / Double(self.ctr.currentWindowHeightStr)!
  
                        // JSONドキュメントの情報も更新
                        // このページ内で検索
                        for index in 0...self.ctr.jsonObj!.subjects[sbjNo].pages[pgNo].textElems.count-1 {
                            
                            // SEARCHING
                            // IDが同じであれば検索終了
                            if self.elmCtr.element.id == self.ctr.jsonObj!.subjects[sbjNo].pages[pgNo].textElems[index].id {
                                //print("SEARCHED!")
                                
                                // 新しい位置に更新
                                self.ctr.jsonObj!.subjects[sbjNo].pages[pgNo].textElems[index].position.x = self.elmCtr.element.position.x
                                self.ctr.jsonObj!.subjects[sbjNo].pages[pgNo].textElems[index].position.y = self.elmCtr.element.position.y
                                self.elmCtr.isSelected = true
                                
                            } else {
                                
                                self.elmCtr.isSelected = false
                                
                            }
                            
                        }
                        
                        // 差分位置を初期化
                        // 差分の初期化は、JSONの更新に関わらず行うべき
                        self.elmCtr.differPos.x = 0
                        self.elmCtr.differPos.y = 0
                        
                        self.ctr.elmCtr!.isSelected = false
                        // JSON 更新とView更新を誘発
                        self.ctr.updateJsonAndReload()
  
                    }
                
            )

    }
    


    
    
}




