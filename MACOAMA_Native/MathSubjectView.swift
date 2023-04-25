//
//  MathSubjectView.swift
//  MACOAMA
//
//  Created by Si Young Choi on 2023/04/22.
//

import SwiftUI
import PhotosUI




struct MathSubjectView: View {
    
    var jsonText : String = "Default Json Text"
    
    var parsedJson : MathSubjectResponse? = nil
    
    var parsedView : some View {
        
        return createViews(parsedJson: self.parsedJson!, sbjNum: 0)
    }
    
    
    var body: some View {
        
        //let _ = print("MathSubjectView ENTERED !")
        //print(self.jsonText)
        
                
        if self.parsedJson != nil {
            
            Button("EXPORT TO PNG") {
                
                print( self.parsedView )
                
                // Viewを画像ファイルとして保存する
                // https://www.youtube.com/watch?v=iNCXmq99mjw&t=276s
                // https://www.youtube.com/watch?v=nQNnHOeGmU4
                

                
            }
            
            
            self.parsedView
            



        }
        
        
        
        

        
        
    }
    
    
    
    init(jsonText: String) {
        self.jsonText = jsonText
        self.parsedJson = self.parseJson(jsonText: jsonText)
        
    }
    
    
    
    

    
    
    
    @ViewBuilder
    private func createViews( parsedJson: MathSubjectResponse, sbjNum: Int) -> some View {
        
        
        let _ = print(parsedJson.subjects[sbjNum].title)
        let _ = print(parsedJson.subjects[sbjNum].pages[0].pageNum)
        let _ = print(parsedJson.subjects[sbjNum].pages[0].textElems[0].content)
        let _ = print(parsedJson.subjects[sbjNum].pages[0].textElems[0].position)
        let _ = print(parsedJson.subjects[sbjNum].pages[0].textElems[0].timeIn)
        let _ = print(parsedJson.subjects[sbjNum].pages[0].textElems[0].timeOut)

        let _ = print(parsedJson.subjects[sbjNum].pages[0].graphicElems[0].url)
        let _ = print(parsedJson.subjects[sbjNum].pages[0].graphicElems[0].position)
        let _ = print(parsedJson.subjects[sbjNum].pages[0].graphicElems[0].timeIn)
        let _ = print(parsedJson.subjects[sbjNum].pages[0].graphicElems[0].timeOut)
        
        let subject = parsedJson.subjects[sbjNum]
        //let pageNum = subject.pages.count
        
        // 画面サイズを取得する
        // https://stackoverflow.com/questions/24110762/swift-determine-ios-screen-size
        //let screenSize: CGRect = UIScreen.main.bounds
        
        
        //let _ = print(screenSize)
        //let _ = print(pageNum)
        

        ZStack (alignment: .topLeading) {
            
            
            VStack (alignment: .leading){
                

                
                
                TabView {
                    
                    ForEach(subject.pages, id: \.self) { page in
                        
                        ZStack (alignment: .topLeading) {
                            
                            //let _ = print( page )
                            
                            // BG
                            Color
                                .init(red: Double(subject.color.red)/255, green: Double(subject.color.green)/255, blue: Double(subject.color.blue)/255)
                                .opacity(1.0)
                                .edgesIgnoringSafeArea(.all)
                            
                            
                            // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓
                            // ┃    USING CUSTOM FONT     ┃
                            // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                            // https://developer.apple.com/documentation/swiftui/applying-custom-fonts-to-text
                            //
                            // カスタムフォントは、プロジェクト設定にまず、
                            // Fonts provided by application -> Item 0 で新規追加
                            // そのValueに、フォントのファイル名を記述
                            //
                            // その後、以下のように使用する。
                            // .font(Font.custom("GenEiKoburiMin6-R", size: 42))
                            //
                            
                            
                            // ----------------------------------------------------------------
                            // TITLE
                            
                            // CONTENTS
                            
                            
                            // ┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓
                            // ┃  ALIGNING TO RIGHT SIDE  ┃
                            // ┗━━━━━━━━━━━━━━━━━━━━━━━━━━┛
                            //
                            // Viewを右揃えにする
                            // https://stackoverflow.com/questions/56443535/swiftui-text-alignment
                            //
                            // View単体の「複数行での揃え方」をまず定義し、
                            // その後、frame()でこのText View自体の、「全体での揃え方」を設定する。
                            //
                            Text(subject.title)
                                .font(Font.custom("GenEiKoburiMin6-R", size: 42))
                                .foregroundColor(Color.black)
                                .textSelection(.enabled)
                                .multilineTextAlignment(.trailing)
                                .frame(
                                    maxWidth: .infinity,
                                    maxHeight: .infinity,
                                    alignment: .topTrailing)
                            
                            // ----------------------------------------------------------------
                            // CONTENTS
                            
                            
                            // ┏━━━━━━━━━━┓
                            // ┃  offset  ┃
                            // ┗━━━━━━━━━━┛
                            //
                            // OFFSETを使用し、親階層のViewより相対的な位置を設定する
                            // https://developer.apple.com/documentation/swiftui/gaugestyleconfiguration/currentvaluelabel-swift.struct/offset(x:y:)

                            
                            // ---------------------------
                            // テキストをコピーできるようにする
                            // https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-select-text
                            
                            
                            ForEach(page.textElems, id: \.self) { elem in
                                Group {
                                    Text(elem.content)
                                        .background(Color(red: Double(elem.bgColor.red)/255,
                                                          green: Double(elem.bgColor.green)/255,
                                                          blue: Double(elem.bgColor.blue)/255,
                                                          opacity: Double(elem.bgColor.opacity)/255))
                                        .offset(x: elem.position.x * 1024,
                                                y: elem.position.y * 768)
                                        .font(Font.custom(elem.font, size: elem.size))
                                        .foregroundColor(Color(red: Double(elem.color.red)/255,
                                                               green: Double(elem.color.green)/255,
                                                               blue: Double(elem.color.blue)/255,
                                                               opacity: Double(elem.color.opacity)/255))
                                    
                                        
                                }
                            }
                                

                            
                            
                            // let _ = print(page.textElems[0].position.x * screenSize.width)
                            // let _ = print(page.textElems[0].position.y * screenSize.height)
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .textSelection(.enabled)
                        
                        
                    }
                }

                
            }
            
        }
        
  
    }
    
    
    
    
    private func parseJson( jsonText : String ) -> MathSubjectResponse {
        
        let json = jsonText.data(using: .utf8)!
        let mathSubjectsRes = try! JSONDecoder().decode(MathSubjectResponse.self, from: json)
        
        return mathSubjectsRes
       
    }
    
    
    
    
}









struct MathSubjectView_Previews: PreviewProvider {
    

    static var previews: some View {
        let jsonText : String = "Default Json Text"
        
        MathSubjectView(jsonText: jsonText)
    }
}


//MathSubject(
//    title: "TITLE OF PAGE 1",
//    pages: [
//        MACOAMA.MathPage(pageNum: 1,
//                         duration: 5000,
//                         textElems:
//                            [MACOAMA.MathPageTextElm(type: "text",
//                                                     content: "CONTENTS OF TEXT ELEMENT!!",
//                                                     position: MACOAMA.MathPosition(x: 300, y: 200),
//                                                     color: MACOAMA.MathColor(red: 255,
//                                                                              green: 255,
//                                                                              blue: 255),
//                                                     timeIn: 0,
//                                                     timeOut: 1000)],
//                         graphicElems: [MACOAMA.MathPageGrpElm(type: "graphic",
//                                                               url: "URL OF GRAPHIC 1",
//                                                               position: MACOAMA.MathPosition(x: 300, y: 200),
//                                                               timeIn: 0,
//                                                               timeOut: 1000)
//                         ]
//                        )
//    ],
//
//    color: MACOAMA.MathColor(red: 255, green: 128, blue: 180)
//
//)
