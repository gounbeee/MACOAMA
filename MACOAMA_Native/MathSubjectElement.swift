//
//  MathSubjectElement.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/04/28.
//

import SwiftUI




struct MathSubjectElement: View {
    

    @GestureState var locationStore = CGPoint(x: 0, y: 0)
    
    @State var differPos = CGPoint(x: 0, y: 0)
    @State var startPos  = CGPoint(x: 0.0, y: 0.0)
    
    
    var elem : MathPageTextElm = MathPageTextElm(id: "initial",
                                                 font: "initial",
                                                 content: "initial",
                                                 size: 10.0,
                                                 position: MathPosition(x: 0.0, y: 0.0),
                                                 color: MathColor(red: 0, green: 0, blue: 0, opacity: 255),
                                                 bgColor: MathColor(red: 0, green: 0, blue: 0, opacity: 0),
                                                 timeIn: 0, timeOut: 0)
    
    var parsedJson : ParsingJson
        
    var initialPos = CGPoint(x: 0.0, y: 0.0)
    
    var sbjNum = 0
    var pgNum = 0
    var canvasWidth = 0
    var canvasHeight = 0
    
    var jsonText : String = "initial"
    var jsonTextModified : String = "initial"
    
    
    
    init(elm: MathPageTextElm, jsonText: String, parsedJson: ParsingJson, sbjNum: Int, pgNum: Int, canvasWidth: Int, canvasHeight: Int) {
        
        self.jsonText = jsonText
        self.parsedJson = parsedJson
        
        //print(self.parsedJson)
        // let _ = print("MathSubjectElement self.parsedJson address: \(Unmanaged.passUnretained(self.parsedJson).toOpaque())")
        
        self.elem = elm
        
        startPos.x = elem.position.x * 540
        startPos.y = elem.position.y * 960
        initialPos.x = elem.position.x * 540
        initialPos.y = elem.position.y * 960
        
        self.sbjNum = sbjNum
        self.pgNum = pgNum
        
        self.canvasWidth = canvasWidth
        self.canvasHeight = canvasHeight
        
        
        //print(startPos)
        
        
        
    }
    
    
    
    var body: some View {
        
        //Text(elem.id)
        
        Text(elem.content)
            .background(Color(red: Double(elem.bgColor.red)/255,
                              green: Double(elem.bgColor.green)/255,
                              blue: Double(elem.bgColor.blue)/255,
                              opacity: Double(elem.bgColor.opacity)/255))

            .font(Font.custom(elem.font, size: elem.size))
            .foregroundColor(Color(red: Double(elem.color.red)/255,
                                   green: Double(elem.color.green)/255,
                                   blue: Double(elem.color.blue)/255,
                                   opacity: Double(elem.color.opacity)/255))
            .textSelection( .disabled )

            .offset(x: initialPos.x + startPos.x + differPos.x,
                    y: initialPos.y + startPos.y + differPos.y)
       
            .gesture(
                
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                
                    // ドラッグする間、カーソルの次の位置を取得できる
                    .updating($locationStore) { currentState, pastLocation, transaction in

                        //print(currentState.location)
                        //print( "locationStore IS  \(locationStore)" )
                        
                        // ここで、新しい位置の情報を更新
                        pastLocation.x = currentState.location.x
                        pastLocation.y = currentState.location.y
                        
                                                
                        transaction.animation = .easeInOut

                    }

                    .onChanged { state in

                        //location = state.location
                        //print( "state.location IS  \(state.location)" )
                        //print( "state.startLocation IS  \(state.startLocation)" )
                        //print( "state.location IS  \(state.location)" )
                        //print( state.translation )
                        
                        // 差分位置を計算
                        differPos.x = state.location.x - state.startLocation.x
                        differPos.y = state.location.y - state.startLocation.y

                    }
                    .onEnded { state in
                        // 初期位置を更新
                        startPos.x += state.location.x - state.startLocation.x
                        startPos.y += state.location.y - state.startLocation.y
                        
                        // 差分位置を初期化
                        differPos.x = 0
                        differPos.y = 0
                        
                        let positionX = initialPos.x + startPos.x + differPos.x
                        let positionY = initialPos.y + startPos.y + differPos.y
                        

                        //print(self.parsedJson.subjects[self.sbjNum].pages[self.pgNum].textElems[0].hashValue)
                        
                        for index in 0...self.parsedJson.value!.subjects[self.sbjNum].pages[self.pgNum].textElems.count-1 {

                            //print( "elem.hashValue  IS  \(elem.hashValue)  AND  HASH VALUE IN parsedJson IS \(self.parsedJson.value!.subjects[self.sbjNum].pages[self.pgNum].textElems[index].hashValue)" )
                            print( "elem.id  IS  \(elem.id)  AND  id VALUE IN parsedJson IS \(self.parsedJson.value!.subjects[self.sbjNum].pages[self.pgNum].textElems[index].id)" )

                            // SEARCHING
                            if elem.id == self.parsedJson.value!.subjects[self.sbjNum].pages[self.pgNum].textElems[index].id {
                                print("SEARCHED!")

                                let resultX = positionX / CGFloat(self.canvasWidth)
                                let resultY = positionY / CGFloat(self.canvasHeight)
                                
                                // 値の更新 ObservableObject
                                // *****
                                // self.parsedJsonは、ParsedJsonタイプで、これはCLASSなので参照として渡せる。（メモリ住所が同じ）
                                // その上に、ObservableObject　プロトコルを遵守しているので、値の変化によって、viewの更新がなされる。
                                // 結果、以下の記述により、HashValueなどの生成されるデータはその度変わっていく。
                                // *****
                                self.parsedJson.value!.subjects[self.sbjNum].pages[self.pgNum].textElems[index].position.x = resultX
                                self.parsedJson.value!.subjects[self.sbjNum].pages[self.pgNum].textElems[index].position.y = resultY

                            }

                        }
                        
                    }
                
            )

    }
    

   
    func parseJson( jsonText : String ) -> MathSubjectResponse {
        
        let json = jsonText.data(using: .utf8)!
        let mathSubjectsRes = try! JSONDecoder().decode(MathSubjectResponse.self, from: json)
        
        return mathSubjectsRes
        
    }
    
    
}




