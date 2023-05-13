//
//  MathSubjectCreate.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/04.
//

import SwiftUI


struct MathSubjectCreatePageView: View {
    
    
    @ObservedObject var ctr : MathSubjectController
    @ObservedObject var synthCtr : SynthController
    @ObservedObject var linkCtr : MathSubjectLinkController
    
    
    var isSubjectVisible : Bool = true
    var isPageVisible : Bool = true
    
    // もし教材番号が振られてきたなら、こちらの教材をロードする
    var subjectSpecified : Int? = nil
    
    // メモリアドレスを調べる
    // https://forums.swift.org/t/memory-address-of-value-types-and-reference-types/6637
    // let _ = print("parsedJson address: \(Unmanaged.passUnretained(parsedJson.wrappedValue).toOpaque())")  init(parsedJson : ParsingJson) {
    // 画面サイズを取得する
    // https://stackoverflow.com/questions/24110762/swift-determine-ios-screen-size
    // let screenSize: CGRect = UIScreen.main.bounds
    
    var subjectNo : Int = 0

    
    init(controller: MathSubjectController, synthCtr: SynthController, linkCtr: MathSubjectLinkController, isSubjectVisible: Bool, isPageVisible: Bool, subjectSpecified: Int?) {
        self.ctr = controller
        self.synthCtr = synthCtr
        self.linkCtr = linkCtr
        
        self.isSubjectVisible = isSubjectVisible
        self.isPageVisible = isPageVisible
        
        self.ctr.parsedView = self
        
        // このオブジェクト固有の値として教材番号を扱う
        // そうしないと、コントローラのプロパティを更新することになり、無限ループでView更新をし続けることになる。
        self.subjectNo = self.ctr.subjectNo
        
        if let sbjSpecf = subjectSpecified {
            
            self.subjectSpecified = sbjSpecf
            self.subjectNo = sbjSpecf
        }

    }

    
    var body: some View {
        
        HStack {
            
            VStack {
                
                if self.ctr.isLinkedView == false {
                    MathSubjectCommandView(ctr: self.ctr, bluetoothCtr: nil, isSubjectVisible: self.isSubjectVisible, isPageVisible: self.isPageVisible)
                } else {
                    MathSubjectCommandView(ctr: self.ctr, bluetoothCtr: nil, isSubjectVisible: self.isSubjectVisible, isPageVisible: self.isPageVisible)
                        .scaleEffect(x: 2.0, y: 2.0)
                }

                
            
                ZStack (alignment: .topLeading) {
                    
                    //let _ = print( page )
                    
                    // 固有のインスタンスプロパティとして教材番号を使用している。
                    let subject = self.ctr.jsonObj!.subjects[self.subjectNo]
                    
                    // BG
                    Color
                        .init(red: Double.random(in: 0.85...1.0), green: Double.random(in: 0.85...1.0), blue: Double.random(in: 0.85...1.0))
                    //.init(red: Double(subject.color.red)/255, green: Double(subject.color.green)/255, blue: Double(subject.color.blue)/255)
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
                        .font(Font.custom("GenEiKoburiMin6-R", size: 62))
                        .foregroundColor(Color.black)
                        .textSelection(.disabled)
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
                    
                    
                    ForEach(subject.pages[self.ctr.pageNo].textElems, id: \.self) { elemInfo in
                        // Viewは、基本的に文脈維持のためControllerを食う
                        let elmCtr : MathSubjectElementController = MathSubjectElementController()
                        
                        MathSubjectElementView(controller: self.ctr, elmCtr: elmCtr, elementInfo: elemInfo, synthCtr: self.synthCtr)
                        
                    }
                    
                    
                    
                }
                .frame(width: MathSubjectController.ElementWidth, height: MathSubjectController.ElementHeight)
                .textSelection(.disabled)
                .padding()
                
                
                //        .onAppear(perform: {
                //
                //            // how-can-i-read-and-get-access-to-mouse-cursor-location-in-a-view-of-macos-swiftu
                //            // https://stackoverflow.com/questions/69369959/how-can-i-read-and-get-access-to-mouse-cursor-location-in-a-view-of-macos-swiftu
                //            NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
                //
                //                print("\(isOverContentView ? "Mouse inside ContentView" : "Not inside Content View") x: \(self.mouseLocation.x) y: \(self.mouseLocation.y)")
                //                return $0
                //
                //            }
                //
                //        })
                
            
            }
            //.frame(maxHeight: .infinity)
            .frame(height: 740)
            .padding()
            

            if self.ctr.isEditMode == true {
                MathSubjectEditView(controller: self.ctr, synthCtr: self.synthCtr, linkCtr: self.linkCtr)
                    .frame(width: 900)
                    .padding()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    


    
    
}

