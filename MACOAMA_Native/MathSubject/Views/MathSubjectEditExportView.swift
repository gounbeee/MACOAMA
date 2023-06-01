//
//  MathSubjectEditExportView.swift
//  COARAMAUSE
//
//  Created by Si Young Choi on 2023/05/12.
//

import SwiftUI





struct MathSubjectEditExportView: View {
    
    @ObservedObject var ctr : MathSubjectController
    @ObservedObject var synthCtr : SynthController
    
    @ObservedObject var linkCtr : MathSubjectLinkController
    @ObservedObject var windowCtr : MathSubjectWindowController
    @ObservedObject var blueToothCtr : BluetoothController
    
    
    @State var isShowingOK : Bool = false
    
    
    
    var body: some View {
        
        
        
        
        
        // TODO :: SLIDERでは、インデックス最大値のエラーが出た。
        
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
        
        VStack (alignment: .leading) {
            
            HStack {
                
                // Binding<String> タイプを直接使用する。
                // https://stackoverflow.com/questions/69071781/struct-initialization-in-swiftui-self-used-before-all-stored-properties-are-i
                TextField(text: $ctr.currentWindowWidthStr ) {
                    Text("イメージ横")
                }
                
                TextField(text: $ctr.currentWindowHeightStr ) {
                    Text("イメージ縦")
                }
                
            }
            .frame(alignment: .topLeading)
            
            
            HStack {
                
                VStack {
                    
                    
                    Button(action: {
                        
                        self.ctr.renameElemTitleWithIndex()
                        self.isShowingOK = true
                        
                    }) {
                        
                        Text("要素の名前整理")
                        //.frame(maxWidth: .infinity)
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    
                    
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
                            self.isShowingOK = true
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
                                let viewToAdded = MathSubjectCreatePageView(controller: newController,
                                                                            synthCtr: self.synthCtr,
                                                                            linkCtr: self.linkCtr,
                                                                            windowCtr: self.windowCtr,
                                                                            isSubjectVisible: false,
                                                                            isPageVisible: false,
                                                                            subjectSpecified: nil,
                                                                            blueToothCtr: self.blueToothCtr,
                                                                            isFinalExport: true)
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
                                
                                
                                self.isShowingOK = true
                            }
                            
                        }
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                }
                
                
                VStack {
                    
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
                        PersistenceController.shared.addTextDataWithString(title: "New Json", input: self.ctr.jsonText)
                        self.isShowingOK = true
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    
                    
                    Button("CSVファイルの出力") {
                        
                        var csvText = ""
                        
                        for subject in self.ctr.jsonObj!.subjects {
                            
                            //print(i)
                            csvText += String(subject.pages.count) + "\n"
                            
                        }
                        
                        // JSONファイルを新規保存
                        PersistenceController.shared.addTextDataWithString(title: "New CSV", input: csvText)
                        
                        self.isShowingOK = true
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    
                    Button("CSVタイトルの出力") {
                        
                        var csvText = ""
                        
                        for subject in self.ctr.jsonObj!.subjects {
                            
                            //print(i)
                            csvText += String(subject.title) + "\n"
                            
                        }
                        
                        // JSONファイルを新規保存
                        PersistenceController.shared.addTextDataWithString(title: "New CSV TITLE", input: csvText)
                        
                        self.isShowingOK = true
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    
                    
                    Button("HEADERファイルの出力") {
                        
                        var hdTextSbjArray = [[String]]()
                        
                        
                        for subjectInd in 0...self.ctr.jsonObj!.subjects.count-1 {
                            // 各要素たちのリンク文字列を取得
                            var lnkCollected : [String] = []
                            
                            // すべてのPageたちに対して
                            for pageInd in 0...self.ctr.jsonObj!.subjects[subjectInd].pages.count-1 {
                                
                                // すべてのElementたちに対して
                                for elemInd in 0...self.ctr.jsonObj!.subjects[subjectInd].pages[pageInd].textElems.count-1 {
                                    
                                    let elem = self.ctr.jsonObj!.subjects[subjectInd].pages[pageInd].textElems[elemInd]
                                    
                                    // elem.links は１ベースのインデックス
                                    // subjectInd は０ベースのインデックスなので１を足して使用
                                    if let lnk = elem.links {
                                        
                                        if lnk == "none" {
                                            lnkCollected.append(String(subjectInd+1))
                                        } else {
                                            
                                            lnkCollected.append(lnk)
                                        }
                                        //print(lnk)
                                    }
                                    
                                }
                            }
                            
                            //print(lnkCollected)
                            
                            // ヘッダーファイル
                            // 配列内のインデックス番号 -> 教材のサブジェクト番号
                            // {61, 52, 51, 50, 59, 52, 51, 50, 59},関連するサブジェクト番号　→ 左は旧教材番号
                            
                            // 1. まずは、現行の教材番号でリンク情報をまとめ、
                            
                            // 重複を消す
                            // https://stackoverflow.com/questions/25738817/removing-duplicate-elements-from-an-array-in-swift
                            lnkCollected = Array(Set(lnkCollected))
                            
                            //print("\(subjectInd) vv" )
                            //print(lnkCollected)
                            
                            let resultSbjString = self.ctr.randomLinkArray(currentSbjNo: subjectInd, inputLinks: lnkCollected)
                            //print(resultSbjString)
                            
                            
                            hdTextSbjArray.append(self.ctr.transformLinkArray(inputLinksStr: resultSbjString))
                            
                        }
                        
                        print(hdTextSbjArray)
                        //print(hdTextSbjArray.count)
                        
                        // CSV で出力
                        
                        var csvFinal : String = ""
                        
                        
                        for sbjInd in 1...hdTextSbjArray.count {
                            
                            var csvTextOneLine : String = ""
                            
                            csvTextOneLine += "//-- SUBJECT INDEX \(sbjInd) \n"
                            csvTextOneLine += "//           TITLE \(self.ctr.jsonObj!.subjects[sbjInd-1].title) \n"
                            
                            csvTextOneLine += "{ "
                            
                            for i in 0...hdTextSbjArray[sbjInd-1].count-1 {
                                
                                let oneSbj = hdTextSbjArray[sbjInd-1][i] + ","
                                csvTextOneLine += oneSbj
                            }
                            
                            // 最後の文字を削除
                            // https://stackoverflow.com/questions/24122288/remove-last-character-from-string-swift-language
                            csvTextOneLine.remove(at: csvTextOneLine.index(before: csvTextOneLine.endIndex))
                            
                            csvTextOneLine += " },\n"
                            
                            csvFinal += csvTextOneLine
                            
                        }
                        
                        //print(csvFinal)
                        
                        // JSONファイルを新規保存
                        PersistenceController.shared.addTextDataWithString(title: "New HEADER", input: csvFinal)
                        
                        self.isShowingOK = true
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                }
                
                
                
                // Button("PRINT OLD SUBJECT INDEX") {
                //
                //     print(self.ctr.transformLinkArray(inputLinksStr: ["119","120","121","122","123","124","125","126","157"]))
                //
                //     self.isShowingOK = true
                // }
                // .buttonStyle(.borderedProminent)
                // .controlSize(.large)
                
                
            }
            .alert(isPresented: self.$isShowingOK) {
                
                Alert(title: Text("メッセージ"), message: Text("実行しました"), dismissButton: .cancel())
                
            }
            
            
        }
        
        
    }
    
}


