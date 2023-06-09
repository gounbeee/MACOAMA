//
//  MathSubjectEditView.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/03.
//

import SwiftUI



// SUBLIME TEXT で正規表現で検索
// https://stackoverflow.com/questions/19143429/sublime-text-find-any-text-between-two-defined-characters
//
// \{[^}]*\}


// Idenfiableにすることで、ForEach文をView構造体内で使用する!
// とても有用！ INDEXも簡単に追加することもできる！
// https://sarunw.com/posts/swiftui-foreach/
struct MathPageTextElemIdFied : Hashable, Identifiable {
    
    var id : UUID = UUID()
    
    var index : Int = 0
    
    var element : MathPageTextElm
    
    
    
    
    
}



struct MathSubjectEditView: View {
    
    // STATE プロパティーの配列を初期化
    // https://stackoverflow.com/questions/71997148/different-state-variables-for-new-textfields-in-swiftui
    
    // 初期化時、複数の要素を個数指定で行う
    // https://stackoverflow.com/questions/74682072/swift-multiple-textfields-updating-instead-of-one
    @State private var newElemId : [String] = [String](repeating: String(""), count: 50)
    @State private var newElemPosX : [String] = [String](repeating: String(""), count: 50)
    @State private var newElemPosY : [String] = [String](repeating: String(""), count: 50)
    
    @State private var newElemColorR : [String] = [String](repeating: String(""), count: 50)
    @State private var newElemColorG : [String] = [String](repeating: String(""), count: 50)
    @State private var newElemColorB : [String] = [String](repeating: String(""), count: 50)
    @State private var newElemColorO : [String] = [String](repeating: String(""), count: 50)
    
    @State private var newElemBgColorR : [String] = [String](repeating: String(""), count: 50)
    @State private var newElemBgColorG : [String] = [String](repeating: String(""), count: 50)
    @State private var newElemBgColorB : [String] = [String](repeating: String(""), count: 50)
    @State private var newElemBgColorO : [String] = [String](repeating: String(""), count: 50)
    
    @State private var newElemFontSize : [String] = [String](repeating: String(""), count: 50)
    @State private var newElemFontName : [String] = [String](repeating: String(""), count: 50)
    @State private var newElemContent : [String] = [String](repeating: String(""), count: 50)
    @State private var newElemTimeIn : [String] = [String](repeating: String(""), count: 50)
    @State private var newElemTimeOut : [String] = [String](repeating: String(""), count: 50)
    
    @State private var newCanvasBgColorR : String = "0"
    @State private var newCanvasBgColorG : String = "0"
    @State private var newCanvasBgColorB : String = "0"
    @State private var newCanvasBgColorO : String = "255"
    
    @State private var newLinks : [String] = [String](repeating: String(""), count: 50)
    
    var elemCount : Int = 0
    
    // Identifiable型に拡張された要素を格納
    var elementList : [MathPageTextElemIdFied] = []
    
    // 外部からの文脈マネージャ
    @ObservedObject var ctr : MathSubjectController
    @ObservedObject var synthCtr : SynthController
    @ObservedObject var linkCtr : MathSubjectLinkController
    
    
    @State var deleteElemNo : String = ""
    
    
    @ObservedObject var windowCtr : MathSubjectWindowController
    @ObservedObject var blueToothCtr : BluetoothController
    
    
    
    init(controller: MathSubjectController, synthCtr: SynthController, linkCtr: MathSubjectLinkController, windowCtr: MathSubjectWindowController, blueToothCtr: BluetoothController) {
        
        self.ctr = controller
        self.synthCtr = synthCtr
        self.linkCtr = linkCtr
        self.windowCtr = windowCtr
        self.blueToothCtr = blueToothCtr
        
        self.elemCount = controller.elementNumAll
        
        let elmList = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems
        
        for index in 0..<elmList.count {
            
            // 要素のリストを用意
            var newElm = MathPageTextElemIdFied(element: elmList[index])
            newElm.index = index
            self.elementList.append(newElm)
            
        }

    }
    

    var body: some View {


        HStack {
            
            VStack {
                
                VStack {
                    Text("モニター画面の大きさ").font(.system(size: 18))
                    // NSScreen を使用し、現在のスクリーンの大きさを調べる
                    //https://cocoaapi.hatenablog.com/entry/00000120/recID33859
                    Text( "モニター画面大きさ　横 \(NSScreen.main!.visibleFrame.size.width)" )
                    Text( "モニター画面大きさ　縦 \(NSScreen.main!.visibleFrame.size.height)" )
                    
                    Divider()
                    
                    MathSubjectEditExportView(ctr: self.ctr,
                                              synthCtr: self.synthCtr,
                                              linkCtr: self.linkCtr,
                                              windowCtr: self.windowCtr,
                                              blueToothCtr: self.blueToothCtr)
   
                }
                
                
                VStack {
                    
                    Divider()
                    Text("表示中の教材番号").font(.system(size: 18))
                    HStack {
                        
                        Spacer()
                        
                        HStack {
                            
                            Text("現在のサブジェクト番号")
                            Text(self.ctr.subjectNo.formatted())
                            
                        }
                        
                        Divider()
                        
                        Spacer()
                        
                        HStack {
                            Text("現在のページ番号")
                            Text(self.ctr.pageNo.formatted())
                        }
                    }
                    .frame(height: 30)
                }
                
                VStack {
                    
                    //Divider()
                    //Text("シンセサイザー").font(.system(size: 18))
                    // SYNTHESIS を実装
                    //SynthVM(synthCtr: self.synthCtr)
                    
                    
                    Divider()
                    
                    MathSubjectEditCreateView(ctr: self.ctr)
                    
                    
                    MathSubjectEditDeleteView(deleteElemNo: self.$deleteElemNo, ctr: self.ctr)
                    
                }
                
            }
            
            
            VStack {
                // 2等分の幅、を知るためにここにGeometry Readerを設定した。
                // https://swiftspeedy.com/horizontally-divide-the-screen-into-two-equal-parts-in-swiftui/
                GeometryReader { geo in
                    
                    ScrollView {
                        
                        VStack (alignment: .leading) {
                            Text("全体の要素数  :  \(self.elemCount.formatted())")
                                .font(.caption)
                                .padding()
                            
                            Divider()
                            
                            
                            ForEach(self.elementList, id: \.self) { el in
                                
                                
                                VStack (alignment: .leading) {
                                    let plusIndex = el.index + 1
                                    Text("要素 No. :  \(plusIndex.formatted())")
                                        .font(.title2).foregroundColor(.blue)
                                    
                                    
                                    
                                    HStack {
                                        Text(el.element.id).frame(width: geo.size.width/2).foregroundColor(.gray)
                                        
                                        // TextField の初期値を設定
                                        // https://www.motokis-brain.com/article/26
                                        TextField("Id", text: self.$newElemId[el.index]).frame(width: geo.size.width/3).onAppear() {
                                            self.newElemId[el.index] = el.element.id
                                        }
                                    }
                                    
                                    
                                    if let linksCheck = el.element.links {
                                        VStack (alignment: .leading) {
                                            HStack {
                                                Text("Links").foregroundColor(.blue).frame(width: geo.size.width/4)
                                                Text( linksCheck ).frame(width: geo.size.width).frame(width: geo.size.width/4)
                                                
                                                TextField("Links", text: self.$newLinks[el.index]).frame(width: geo.size.width/4).onAppear() {
                                                    self.newLinks[el.index] = linksCheck
                                                }
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                    
                                    Text("Font").foregroundColor(.blue)
                                    HStack {
                                        Text(el.element.font).frame(width: geo.size.width/6).foregroundColor(.gray)
                                        TextField("Font", text: self.$newElemFontName[el.index]).frame(width: geo.size.width/6).onAppear() {
                                            self.newElemFontName[el.index] = el.element.font
                                        }
                                        Button("Font 1") {
                                            self.newElemFontName[el.index] = "GenEiKoburiMin6-R"
                                        }.frame(width: geo.size.width/6)
                                        Button("Font 2") {
                                            self.newElemFontName[el.index] = "GenEiMonoCode-Regular"
                                        }.frame(width: geo.size.width/6)
                                        Button("Font 3") {
                                            self.newElemFontName[el.index] = "AsciiMath-Regular"
                                        }.frame(width: geo.size.width/6)
                                    }
                                    
                                    Text("Font Size").foregroundColor(.blue)
                                    HStack {
                                        Text(el.element.size.formatted()).frame(width: geo.size.width/3).foregroundColor(.gray)
                                        TextField("FontSize", text: self.$newElemFontSize[el.index]).frame(width: geo.size.width/3).onAppear() {
                                            self.newElemFontSize[el.index] = el.element.size.formatted()
                                        }
                                    }
                                }
                                
                                
                                VStack (alignment: .leading) {
                                    
                                    Text("Content").foregroundColor(.blue)
                                    HStack {
                                        Text(el.element.content).frame(width: geo.size.width/3).foregroundColor(.gray)
                                        TextField("Content", text: self.$newElemContent[el.index]).frame(width: geo.size.width/3).onAppear() {
                                            self.newElemContent[el.index] = el.element.content
                                        }
                                    }
                                    
                                    
                                    Text("Position").foregroundColor(.blue)
                                    HStack {
                                        Text(el.element.position.x.formatted()).frame(width: geo.size.width/5).foregroundColor(.gray)
                                        TextField("PosX", text: self.$newElemPosX[el.index]).frame(width: geo.size.width/5).onAppear() {
                                            self.newElemPosX[el.index] = el.element.position.x.formatted()
                                        }
                                        Text(el.element.position.y.formatted()).frame(width: geo.size.width/5).foregroundColor(.gray)
                                        TextField("PosY", text: self.$newElemPosY[el.index]).frame(width: geo.size.width/5).onAppear() {
                                            self.newElemPosY[el.index] = el.element.position.y.formatted()
                                        }
                                    }
                                    
                                }
                                
                                
                                VStack (alignment: .leading) {
                                    Text("Color").foregroundColor(.blue)
                                    HStack {
                                        Text(el.element.color.red.formatted()).frame(width: geo.size.width/5)
                                        Text(el.element.color.green.formatted()).frame(width: geo.size.width/5)
                                        Text(el.element.color.blue.formatted()).frame(width: geo.size.width/5)
                                        Text(el.element.color.opacity.formatted()).frame(width: geo.size.width/5)
                                    }.foregroundColor(.gray)
                                    HStack {
                                        TextField("Red", text: self.$newElemColorR[el.index]).frame(width: geo.size.width/5).onAppear() {
                                            self.newElemColorR[el.index] = el.element.color.red.formatted()
                                        }
                                        TextField("Green", text: self.$newElemColorG[el.index]).frame(width: geo.size.width/5).onAppear() {
                                            self.newElemColorG[el.index] = el.element.color.green.formatted()
                                        }
                                        TextField("Blue", text: self.$newElemColorB[el.index]).frame(width: geo.size.width/5).onAppear() {
                                            self.newElemColorB[el.index] = el.element.color.blue.formatted()
                                        }
                                        TextField("Opacity", text: self.$newElemColorO[el.index]).frame(width: geo.size.width/5).onAppear() {
                                            self.newElemColorO[el.index] = el.element.color.opacity.formatted()
                                        }
                                    }
                                    
                                }
                                
                                
                                VStack (alignment: .leading) {
                                    
                                    Text("BgColor").foregroundColor(.blue)
                                    HStack {
                                        Text(el.element.bgColor.red.formatted()).frame(width: geo.size.width/5)
                                        Text(el.element.bgColor.green.formatted()).frame(width: geo.size.width/5)
                                        Text(el.element.bgColor.blue.formatted()).frame(width: geo.size.width/5)
                                        Text(el.element.bgColor.opacity.formatted()).frame(width: geo.size.width/5)
                                    }.foregroundColor(.gray)
                                    HStack {
                                        TextField("Red", text: self.$newElemBgColorR[el.index]).frame(width: geo.size.width/5).onAppear() {
                                            self.newElemBgColorR[el.index] = el.element.bgColor.red.formatted()
                                        }
                                        TextField("Green", text: self.$newElemBgColorG[el.index]).frame(width: geo.size.width/5).onAppear() {
                                            self.newElemBgColorG[el.index] = el.element.bgColor.green.formatted()
                                        }
                                        TextField("Blue", text: self.$newElemBgColorB[el.index]).frame(width: geo.size.width/5).onAppear() {
                                            self.newElemBgColorB[el.index] = el.element.bgColor.blue.formatted()
                                        }
                                        TextField("Opacity", text: self.$newElemBgColorO[el.index]).frame(width: geo.size.width/5).onAppear() {
                                            self.newElemBgColorO[el.index] = el.element.bgColor.opacity.formatted()
                                        }
                                    }
                                    
                                }
                                
                                
                                VStack (alignment: .leading) {
                                    Text("TimeIn").foregroundColor(.blue)
                                    HStack {
                                        Text(String("\(el.element.timeIn)")).frame(width: geo.size.width/3).foregroundColor(.gray)
                                        TextField("TimeIn", text: self.$newElemTimeIn[el.index]).frame(width: geo.size.width/3).onAppear() {
                                            self.newElemTimeIn[el.index] = String("\(el.element.timeIn)")
                                        }
                                    }
                                    Text("TimeOut").foregroundColor(.blue)
                                    HStack {
                                        Text(String("\(el.element.timeOut)")).frame(width: geo.size.width/3).foregroundColor(.gray)
                                        TextField("TimeOut", text: self.$newElemTimeOut[el.index]).frame(width: geo.size.width/3).onAppear() {
                                            self.newElemTimeOut[el.index] = String("\(el.element.timeOut)")
                                        }
                                    }
                                    
                                }
                                
                                
                                //
                                Divider()
                                
                                Button("データを更新する") {
                                    
                                    //print(self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].position )
                                    //print(Double(self.newPosX[el.index])!)
                                    
                                    
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].id = self.newElemId[el.index]
                                    
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].content = self.newElemContent[el.index]
                                    
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].size = Double(self.newElemFontSize[el.index])!
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].font = self.newElemFontName[el.index]
                                    
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].position.x = Double(self.newElemPosX[el.index])!
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].position.y = Double(self.newElemPosY[el.index])!
                                    
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].color.red = Int(self.newElemColorR[el.index])!
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].color.green = Int(self.newElemColorG[el.index])!
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].color.blue = Int(self.newElemColorB[el.index])!
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].color.opacity = Int(self.newElemColorO[el.index])!
                                    
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].bgColor.red = Int(self.newElemBgColorR[el.index])!
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].bgColor.green = Int(self.newElemBgColorG[el.index])!
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].bgColor.blue = Int(self.newElemBgColorB[el.index])!
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].bgColor.opacity = Int(self.newElemBgColorO[el.index])!
                                    
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].timeIn = Int(self.newElemTimeIn[el.index])!
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].timeOut = Int(self.newElemTimeOut[el.index])!
                                    
                                    self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems[el.index].links = self.newLinks[el.index]
                                    
                                    
                                    
                                    // JSON 更新とView更新を誘発
                                    self.ctr.updateJsonAndReload()
                                    
                                    
                                    
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                                
                                Divider()
                                
                            }
                            
                        }
                        .padding()
                        
                    }
                    
                }
                
            }
            //.frame(width: 500)
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding()
    }
    
    
    
    
    
}



