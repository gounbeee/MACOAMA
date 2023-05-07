//
//  MathSubjectControl.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/04.
//

import SwiftUI

struct MathSubjectCommandView: View {
    
    
    
    @ObservedObject var ctr : MathSubjectController
    
    @State var pageNumInSubject : Int = 10
    
    
    var body: some View {
        
        
        VStack (alignment: .center) {
            
            
            
            HStack {
                
                // Binding<String> タイプを直接使用する。
                // https://stackoverflow.com/questions/69071781/struct-initialization-in-swiftui-self-used-before-all-stored-properties-are-i
                TextField(text: $ctr.currentWindowWidthStr ) {
                    Text("ImgWdh")
                }
                
                TextField(text: $ctr.currentWindowHeightStr ) {
                    Text("ImgHgt")
                }
                
            }
            .frame(alignment: .topLeading)
            
            
            
            //            Slider(value: IntDoubleBinding(Int(controller.currentWindowWidthStr)!).doubleValue,
            //                   in: 200.0...1920,
            //                   step: 10.0) { _ in
            //                //print("CURRENT SUBJECT NO IS ::  \(mathSubjectNo)")
            //
            //                //self.newWindowWidth.wrappedValue = String(controller.currentWindowWidth)
            //
            //            }
            //
            //
            //
            //            Slider(value: IntDoubleBinding($controller.currentWindowHeight).doubleValue,
            //                   in: 200.0...1920,
            //                   step: 10.0) { _ in
            //                //print("CURRENT SUBJECT NO IS ::  \(mathSubjectNo)")
            //
            //                //self.newWindowHeight.wrappedValue = String(controller.currentWindowHeight)
            //
            //            }
            
            
            
            
            
            Button("現在のViewをPNGで出力") {
                
                //let _ = print( self.parsedView )
                
                // Viewを画像ファイルとして保存する
                // https://github.com/alexito4/Raster
                // https://www.hackingwithswift.com/forums/swift/correct-way-to-load-a-raw-image-into-an-image-view/13658
                // https://developer.apple.com/documentation/appkit/nsbitmapimagerep
                
                //let _ = print(self.parsedView)
                
                let nsImage = self.ctr.parsedView.rasterize(at: CGSize(width: Double(ctr.currentWindowWidthStr)!, height: Double(ctr.currentWindowHeightStr)! ))
                
                // Image(nsImage: nsImage)
                //     .openNewWindow( title: "教材 Window RASTERIZED",
                //                     width: self.currentWindowWidth,
                //                     height: self.currentWindowHeight)
                
                
                
                // ┌──────────────────────────────────────┐
                // │                                      │
                // │     SAVING FILE USING DIALOG BOX     │
                // │                                      │
                // └──────────────────────────────────────┘
                // ファイル保存DIALOGを呼び出しファイルを保存する
                // https://swdevnotes.com/swift/2022/save-an-image-to-macos-file-system-with-swiftui/
                //
                if let url = ctr.showSavePanel() {
                    
                    ctr.savePNGDirect(image: nsImage, path: url)
                    
                    //let _ = print(url)
                }
                
                
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            
            Button("すべてのPageをPNGとして出力") {
                
                var allViewsToExport : [AnyView] = []
                
                
                for sbjNo in 0...self.ctr.subjectNumAll-1 {
                    
                    let subject = self.ctr.jsonObj!.subjects[sbjNo]
                    
                    for pgNum in 0...subject.pages.count-1 {
                        
                        // 新しいコントローラーを新規作成後、Subject番号とPage番号だけ変えて適用
                        // TODO :: 既存のコントローラーの流用を検討！
                        let newController = MathSubjectController()
                        newController.currentWindowWidthStr = self.ctr.currentWindowWidthStr
                        newController.currentWindowHeightStr = self.ctr.currentWindowHeightStr
                        newController.subjectNo = sbjNo
                        newController.pageNo = pgNum
                        newController.jsonText = self.ctr.jsonText
                        newController.jsonObj = self.ctr.jsonObj
                        newController.parseJson()
                        
                        // 新規Viewを作成
                        let viewToAdded = MathSubjectCreatePageView(controller: newController)
                        // LISTに追加
                        allViewsToExport.append( AnyView(viewToAdded) )
                        
                    }
                }
                
                
                
                // var pathStr: String = "../EXPORTED"
                // let fileURL: URL = URL(fileURLWithPath: pathStr)
                // file:///Users/siyoungchoi/Desktop/Untitled.png
                
                // フォルダを選ぶためのDIALOGを表示
                let openPanel = NSOpenPanel()
                openPanel.canCreateDirectories = true
                openPanel.canChooseDirectories = true
                
                let res = openPanel.runModal()
                
                if res == .OK {
                    
                    //let _ = print(openPanel.url)
                    
                    for vwNum in 0...allViewsToExport.count-1 {
                        
                        let nsImage = allViewsToExport[vwNum].rasterize(at: CGSize(width: Double(self.ctr.currentWindowWidthStr)!, height: Double(self.ctr.currentWindowHeightStr)!))
                        
                        //let newExtendedUrl = url.appendingPathExtension("_" + String(vwNum) + ".png")
                        ctr.savePNGDirect(image: nsImage, path: openPanel.url!.appendingPathComponent("file" + String(vwNum) + ".png"))
                        
                    }
                    
                }
                
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            
            
            // ┌───────────────────────────┐
            // │                           │
            // │          SLIDER           │
            // │                           │
            // └───────────────────────────┘
            // https://stackoverflow.com/questions/65736518/how-do-i-create-a-slider-in-swiftui-for-an-int-type-property
            //
            Text("Subject番号")
            Slider(value: IntDoubleBinding(self.$ctr.subjectNo).doubleValue,
                   in: 0.0...Double(self.ctr.subjectNumAll-1),
                   step: 1.0) { state in
                print("CURRENT SUBJECT NO IS ::  \(ctr.subjectNo)")
                
                // Subjectの持つページ数を調べ直す
                self.pageNumInSubject = self.ctr.jsonObj!.subjects[ctr.subjectNo].pages.count
                //print(self.pageNumInSubject)
                
                // エレメントの個数を数え直す
                self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[ctr.subjectNo].pages[0].textElems.count
                
                // 初期化
                self.ctr.pageNo = 0
                
            }
            
            
            
            Text("Page番号")
            Slider(value: IntDoubleBinding(self.$ctr.pageNo).doubleValue,
                   in: 0.0...Double(self.pageNumInSubject-1),
                   step: 1.0) { _ in
                print("CURRENT PAGE NO IS ::  \(self.ctr.pageNo)")
                
                // エレメントの個数を数え直す
                self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[ctr.subjectNo].pages[self.ctr.pageNo].textElems.count

            }
                   .onAppear {
                       
                       self.pageNumInSubject = self.ctr.jsonObj!.subjects[ctr.subjectNo].pages.count
                       
                       

                       
                   }
            
            
            Button("新規JSONファイルとして出力") {
                
                // 変更された要素情報にアクセス -> これは、ObservableObject とClassで定義しなおすことで解決した
                // self.parsedJsonを更新
                //let _ = print("--------------")
                //let _ = print(self.parsedJson.value!.subjects[0].pages)
                //let _ = print("--------------")
                
                
                // JSONとして書き出し
                let encoder = JSONEncoder()
                
                // 綺麗なJSONフォーマットに出力
                // https://www.hackingwithswift.com/example-code/language/how-to-format-json-using-codable-and-pretty-printing
                encoder.outputFormatting = .prettyPrinted
                
                guard let jsonValue = try? encoder.encode(self.ctr.jsonObj!) else {
                    
                    fatalError("JSON構成でエラー発生")
                    
                }
                
                // 現在のJSONテキストを更新
                self.ctr.jsonText = String(bytes: jsonValue, encoding: .utf8)!
                
                // JSONファイルを新規保存
                PersistenceController.shared.addTextDataWithString(input: self.ctr.jsonText)
                
                
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            
            
        }
        
        
    }
    
    
}




