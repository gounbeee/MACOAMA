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
 
        
        Text( self.getStyledTokenizedString(inputTxt: self.elmCtr.element.content) )
        //Text( self.stylingText(inputTxt: self.elmCtr.element.content) )
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
            //.frame(width: 500)
            .padding()
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
    
    
    
    // ----------------------------------------------------------------------------------------------------------------
    
    
    // 以下の二つの関数で、文字を形態素解析をし、それらに個別のスタイリング施す
    
    // AttributedStringを使用し、文字の部分をスタイリング
    // https://developer.apple.com/documentation/foundation/attributedstring
    // https://betterprogramming.pub/text-formatting-in-ios-and-swift-with-attributedstring-e821536fbdec
    func stylingText(inputTxt: String) -> AttributedString {
        
        var attributedString = AttributedString(inputTxt)
        if let range = attributedString.range(of: "の") {

            attributedString[range].foregroundColor = Color(CGColor(red: Double.random(in: 0.6...1.0),
                                                                    green: Double.random(in: 0...0.3),
                                                                    blue: Double.random(in: 0...0.3),
                                                                    alpha: 1.0))
            
            attributedString[range].font = Font.custom(self.elmCtr.element.font, size: self.elmCtr.element.size/1.3)
            
            return attributedString
            
        } else if let range = attributedString.range(of: "link") {
            
            attributedString[range].foregroundColor = Color(CGColor(red: Double.random(in: 0.6...1.0),
                                                                    green: Double.random(in: 0...0.3),
                                                                    blue: Double.random(in: 0...0.3),
                                                                    alpha: 1.0))
            
            attributedString[range].font = Font.custom(self.elmCtr.element.font, size: self.elmCtr.element.size/3)
            
            return attributedString
            
        } else {
            
            // サイズのランダム化
            attributedString.font = Font.custom(self.elmCtr.element.font, size: self.elmCtr.element.size * Double.random(in: 0.7...1.0))
            
            // カラーのランダム化
            attributedString.foregroundColor = Color(CGColor(red: Double.random(in: 0...0.6),
                                                             green: Double.random(in: 0...0.6),
                                                             blue: Double.random(in: 0...0.6),
                                                             alpha: 1.0))
            
            return attributedString
            
        }
        
        
    }
    

    
    
    func getStyledTokenizedString(inputTxt : String) -> AttributedString {
        
        //checkLinkNumber(inputTxt: inputTxt)
        
        
        let txtProc = TextProcessor()
        
        txtProc.inputText = inputTxt
        
        let arrayText : [String] = txtProc.tokenize(text: txtProc.inputText)
        
        var resultString : AttributedString = AttributedString("")
        
        for word in arrayText {
            
            let styledWord = self.stylingText(inputTxt: word)
            
            resultString += styledWord
            
        }
        
        return resultString
        
    }

    
    
    func checkLinkNumber(inputTxt : String) {
        
        // Search for one string in another.
        let result = inputTxt.range(of: "->",
                                options: NSString.CompareOptions.literal,
                                range: inputTxt.startIndex..<inputTxt.endIndex,
                                locale: nil)

        // See if string was found.
        if let range = result {
            
            // Start of range of found string.
            var start = range.lowerBound
            
            // Display string starting at first index.
            //print(inputTxt[start..<inputTxt.endIndex])
            
            // Display string before first index.
            //print(inputTxt[inputTxt.startIndex..<start])
            
            let beforePart = inputTxt[inputTxt.startIndex..<start]
            var afterPart = inputTxt[start..<inputTxt.endIndex]
            
            if let i = afterPart.firstIndex(of: "-") {
                afterPart.remove(at: i)
            }
            if let t = afterPart.firstIndex(of: ">") {
                afterPart.remove(at: t)
            }
            
            // Display string starting at first index.
            print(beforePart)
            
            // Display string before first index.
            print(afterPart)
            
            
        }

        
    }
    
    
}




