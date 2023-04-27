//
//  MathSubjectView.swift
//  MACOAMA
//
//  Created by Si Young Choi on 2023/04/22.
//

import SwiftUI
import PhotosUI




struct IntDoubleBinding {
    let intValue : Binding<Int>
    
    let doubleValue : Binding<Double>
    
    init(_ intValue : Binding<Int>) {
        self.intValue = intValue
        
        self.doubleValue = Binding<Double>(get: {
            return Double(intValue.wrappedValue)
        }, set: {
            intValue.wrappedValue = Int($0)
        })
    }
}




struct MathSubjectView: View {
    
    @State public var mathSubjectNo: Int = 0
    @State public var mathPageNo: Int = 0
    
    var subjectNumAll: Int = 0
    var pageNumInSubject: Int = 0
    var pageNumAll: Int = 0
    
    var jsonText : String = "Default Json Text"
    
    var parsedJson : MathSubjectResponse? = nil
    
    // Binding<String> タイプを直接使用する。
    // https://stackoverflow.com/questions/69071781/struct-initialization-in-swiftui-self-used-before-all-stored-properties-are-i
    var newWindowWidth : Binding<String>
    var newWindowHeight : Binding<String>
    
    @State var currentWindowWidth : Int
    @State var currentWindowHeight : Int
    
    
    
    
    var parsedView : some View {
        
        return createViews(parsedJson: self.parsedJson!, sbjNum: self.mathSubjectNo, pgNum: self.mathPageNo)
    }
    
    
    var body: some View {
        
        //let _ = print("MathSubjectView ENTERED !")
        //print(self.jsonText)
        
        
        if self.parsedJson != nil {
            VStack {
                HStack {
                    
                    // Binding<String> タイプを直接使用する。
                    // https://stackoverflow.com/questions/69071781/struct-initialization-in-swiftui-self-used-before-all-stored-properties-are-i
                    TextField("Image Width", text: self.newWindowWidth.projectedValue)
                    TextField("Image Height", text: self.newWindowHeight.projectedValue)
                }
                
                
                Slider(value: IntDoubleBinding($currentWindowWidth).doubleValue,
                       in: 200.0...1920,
                       step: 10.0) { _ in
                    //print("CURRENT SUBJECT NO IS ::  \(mathSubjectNo)")
                    
                    self.newWindowWidth.wrappedValue = String(currentWindowWidth)
                    
                }
                
                
                Slider(value: IntDoubleBinding($currentWindowHeight).doubleValue,
                       in: 200.0...1920,
                       step: 10.0) { _ in
                    //print("CURRENT SUBJECT NO IS ::  \(mathSubjectNo)")
                    
                    self.newWindowHeight.wrappedValue = String(currentWindowHeight)
                    
                }
                
                
            }
            
            
            Button("EXPORT TO PNG") {
                
                //let _ = print( self.parsedView )
                
                // Viewを画像ファイルとして保存する
                // https://github.com/alexito4/Raster
                // https://www.hackingwithswift.com/forums/swift/correct-way-to-load-a-raw-image-into-an-image-view/13658
                // https://developer.apple.com/documentation/appkit/nsbitmapimagerep
                
                //let _ = print(self.parsedView)
                
                let nsImage = self.parsedView.rasterize(at: CGSize(width: self.currentWindowWidth, height: self.currentWindowHeight))
                
                
                Image(nsImage: nsImage)
                    .openNewWindow( title: "教材 Window RASTERIZED",
                                    width: self.currentWindowWidth,
                                    height: self.currentWindowHeight)
                
                // ┌──────────────────────────────────────┐
                // │                                      │
                // │     SAVING FILE USING DIALOG BOX     │
                // │                                      │
                // └──────────────────────────────────────┘
                // ファイル保存DIALOGを呼び出しファイルを保存する
                // https://swdevnotes.com/swift/2022/save-an-image-to-macos-file-system-with-swiftui/
                //
                if let url = showSavePanel() {
                    
                    savePNGDirect(image: nsImage, path: url)
                    
                }
                
                
            }
            

            // ┌───────────────────────────┐
            // │                           │
            // │          SLIDER           │
            // │                           │
            // └───────────────────────────┘
            // https://stackoverflow.com/questions/65736518/how-do-i-create-a-slider-in-swiftui-for-an-int-type-property
            //
            
            Slider(value: IntDoubleBinding($mathSubjectNo).doubleValue,
                   in: 0.0...Double(self.subjectNumAll-1),
                   step: 1.0) { _ in
                //print("CURRENT SUBJECT NO IS ::  \(mathSubjectNo)")
                
                self.mathSubjectNo = mathSubjectNo
                
            }
            
            
            Slider(value: IntDoubleBinding($mathPageNo).doubleValue,
                   in: 0.0...Double(self.pageNumInSubject-1),
                   step: 1.0) { _ in
                //print("CURRENT PAGE NO IS ::  \(mathPageNo)")
                
                self.mathPageNo = mathPageNo
                
            }
            
            
            
            self.parsedView
                .frame(width: CGFloat(Double(self.newWindowWidth.wrappedValue)!),
                       height: CGFloat(Double(self.newWindowHeight.wrappedValue)!))
            //                .frame(minWidth: 100, idealWidth: CGFloat(Double(self.newWindowWidth.wrappedValue)!), maxWidth: 1920,
            //                       minHeight: 100, idealHeight: CGFloat(Double(self.newWindowHeight.wrappedValue)!), maxHeight: 1920,
            //                       alignment: .center)
            
            
            
        }
        
        
        
    }
    
    
    
    
    init(jsonText: String, newWindowWidth: Binding<String>, newWindowHeight: Binding<String> ) {
        
        // ここの二行が、一番下にあってはならない！！！！！！
        //
        self.currentWindowWidth = Int(newWindowWidth.wrappedValue)!
        self.currentWindowHeight = Int(newWindowHeight.wrappedValue)!
        
        // ここの二行が、一番下にあってはならない！！！！！！
        //
        self.newWindowWidth = newWindowWidth
        self.newWindowHeight = newWindowHeight
        
        self.jsonText = jsonText
        self.parsedJson = self.parseJson(jsonText: jsonText)
        //print( self.parsedJson!.subjects )
        
        // 教材の個数をカウント
        self.subjectNumAll = countSubjects(jsonObject : self.parsedJson!)
        self.pageNumAll = countAllPages(jsonObject : self.parsedJson!)
        self.pageNumInSubject = countPagesInSubject(subjectNo: self.mathSubjectNo, jsonObject: self.parsedJson!)
        //print("\(self.slideNumAll)  IS self.slideNumAll")
        
        
        
    }
    
    
    
    
    
    
    
    
    @ViewBuilder
    private func createViews( parsedJson: MathSubjectResponse, sbjNum: Int, pgNum: Int) -> some View {
        
        
        //let _ = print(parsedJson.subjects[sbjNum].title)
        //let _ = print(parsedJson.subjects[sbjNum].pages[0].pageNum)
        //let _ = print(parsedJson.subjects[sbjNum].pages[0].textElems[0].content)
        //let _ = print(parsedJson.subjects[sbjNum].pages[0].textElems[0].position)
        //let _ = print(parsedJson.subjects[sbjNum].pages[0].textElems[0].timeIn)
        //let _ = print(parsedJson.subjects[sbjNum].pages[0].textElems[0].timeOut)
        
        //let _ = print(parsedJson.subjects[sbjNum].pages[0].graphicElems[0].url)
        //let _ = print(parsedJson.subjects[sbjNum].pages[0].graphicElems[0].position)
        //let _ = print(parsedJson.subjects[sbjNum].pages[0].graphicElems[0].timeIn)
        //let _ = print(parsedJson.subjects[sbjNum].pages[0].graphicElems[0].timeOut)
        
        let subject = parsedJson.subjects[sbjNum]
        //self.slideNumAll = subject.pages.count
        
        let page = subject.pages[pgNum]
        
        
        // 画面サイズを取得する
        // https://stackoverflow.com/questions/24110762/swift-determine-ios-screen-size
        //let screenSize: CGRect = UIScreen.main.bounds
        
        
        //let _ = print(screenSize)
        //let _ = print(pageNum)
        
        Group {
            
            ZStack (alignment: .topLeading) {
                
                VStack (alignment: .leading){
                    
                    
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
                                    .offset(x: elem.position.x * 768,
                                            y: elem.position.y * 1024)
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
    
    
    
    
    private func parseJson( jsonText : String ) -> MathSubjectResponse {
        
        let json = jsonText.data(using: .utf8)!
        let mathSubjectsRes = try! JSONDecoder().decode(MathSubjectResponse.self, from: json)
        
        return mathSubjectsRes
        
    }
    
    
    
    func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save your image"
        savePanel.message = "Choose a folder and a name to store the image."
        savePanel.nameFieldLabel = "Image file name:"
        
        let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
    }
    
    
    func savePNG(imageName: String, path: URL) {
        let image = NSImage(named: imageName)!
        let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)
        let pngData = imageRepresentation?.representation(using: .png, properties: [:])
        do {
            try pngData!.write(to: path)
        } catch {
            print(error)
        }
    }
    
    
    func savePNGDirect(image: NSImage, path: URL) {
        let image = image
        let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)
        let pngData = imageRepresentation?.representation(using: .png, properties: [:])
        do {
            try pngData!.write(to: path)
        } catch {
            print(error)
        }
    }
    
    
    
    mutating func countSubjects( jsonObject : MathSubjectResponse ) -> Int {
        
        var countedSubjects = 0
        
        for _ in jsonObject.subjects {
            
            //print(i)
            countedSubjects += 1
            
        }
        
        print("COUNTING SUBJECTS ::  \(countedSubjects)   ARE COUNTED !!!!")
        
        return countedSubjects
        
        
    }
    
    
    mutating func countPagesInSubject( subjectNo: Int, jsonObject : MathSubjectResponse ) -> Int {
        
        var countedPagesInSubject = 0
        
        let subj = jsonObject.subjects[subjectNo]
        
        
        for _ in subj.pages {
            
            //print(page)
            countedPagesInSubject += 1
            
        }
        
        
        
        print("COUNTING PAGES IN CURRENT SUBJECT ::  \(countedPagesInSubject)   ARE COUNTED !!!!")
        
        return countedPagesInSubject
        
        
    }
    
    
    
    
    mutating func countAllPages( jsonObject : MathSubjectResponse ) -> Int {
        
        var countedPages = 0
        
        for subject in jsonObject.subjects {
            
            //print(i)
            
            for _ in subject.pages {
                
                //print(page)
                countedPages += 1
                
            }
            
        }
        
        print("COUNTING PAGES ::  \(countedPages)   ARE COUNTED !!!!")
        
        return countedPages
        
        
    }
    
    
    
}









//struct MathSubjectView_Previews: PreviewProvider {
//
//
//    @State var exportImgWidth : String = "540"
//    @State var exportImgHeight : String = "960"
//
//    static var previews: some View {
//        let jsonText : String = "Default Json Text"
//
//        MathSubjectView(jsonText: jsonText, newWindowWidth: self.$exportImgWidth, newWindowHeight: self.$exportImgHeight)
//    }
//}





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
