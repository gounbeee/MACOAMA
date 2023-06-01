//
//  MathSubjectControl.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/04.
//

import SwiftUI

struct MathSubjectCommandView: View {
    
    @ObservedObject var ctr : MathSubjectController
    @State var pageNumInSubject : Int = 100
    @State var subjectNum : String = "1"
    @Binding var pageNum : String
    @State var bluetoothCtr : BluetoothController? = nil
    
    @State var isSubjectVisible : Bool = true
    @State var isPageVisible : Bool = true
    
    @ObservedObject var synthCtr : SynthController
    
    @FocusState var isFocusedSubject: Bool
    @FocusState var isFocusedPage: Bool
    
    @Binding var musicIsPlaying : Bool
    
    @State var isHoveringPGBack : Bool = false
    @State var isHoveringPGForward : Bool = false
    
    
    // 処理に遅延を与える
    // https://developer.apple.com/forums/thread/681962
    //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  /// Anything over 0.5 seems to work
    //    self.pageNum = String(self.ctr.pageNo+1)
    //}
    
    func stopMusicPlaying() {
        
        if let _ = self.synthCtr.audioPlayer {
            self.synthCtr.audioPlayer!.stop()
            self.synthCtr.audioPlayer!.currentTime = 0.0
            //self.synthCtr.timer!.upstream.connect().cancel()
            self.synthCtr.audioPlayer = nil
            self.musicIsPlaying = false
        }
        
    }
    
    
    
    var body: some View {
        
        VStack {

            // サブジェクトコントロールが必要であれば、のチェック
            if self.isSubjectVisible == true {

                HStack {

                    // 教材番号を1減らす
                    Button(action: {
                        // 音楽をストップさせる
                        self.stopMusicPlaying()
                        // ページの番号は初期化
                        self.pageNum = "1"
                        // サブジェクト番号を1減らす
                        let sbjNumTest = self.ctr.subjectNo - 1
                        // 0以下のサブジェクト番号チェック
                        if sbjNumTest < 0 {
                            
                            // サブジェクト番号は0に固定
                            self.ctr.subjectNo = 0
                            // このオブジェクトが持つサブジェクト番号の文字列の方も初期化
                            self.subjectNum = String("1")
                            // Subjectの持つページ数を調べ直す
                            self.pageNumInSubject = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages.count
                            self.ctr.pageNumInSubject = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages.count
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[0].textElems.count
                            // 初期化
                            self.ctr.pageNo = 0
                            
                        } else {
                            
                            // 1減らしても大丈夫なら1減らす
                            self.ctr.subjectNo -= 1
                            self.subjectNum = String(self.ctr.subjectNo + 1)
                            // Subjectの持つページ数を調べ直す
                            self.pageNumInSubject = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages.count
                            self.ctr.pageNumInSubject = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages.count
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[0].textElems.count
                            // 初期化
                            self.ctr.pageNo = 0
                            
                        }
                        
                        
                    }, label: {
                        
                        Image(systemName: "chevron.left.square.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20).padding()
 
                    })
                    .buttonStyle(.borderless)
                    
                    
                    // Textfield の文字のセンタリング
                    // https://developer.apple.com/forums/thread/119704
                    // Textfield の文字大きさ
                    // https://www.choge-blog.com/programming/swiftuitextfieldinputtextsize/
                    TextField("サブジェクト番号", text: self.$subjectNum)
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.squareBorder)
                        .frame(width: 40, height: 20)
                        .focused(self.$isFocusedSubject)
                        .onSubmit {
                            print("CURRENT SUBJECT NO IS ::  \(self.subjectNum)")
                            
                            // 音楽の停止
                            self.stopMusicPlaying()
                            // ページ番号の初期化
                            self.pageNum = "1"
                            // 空欄へのチェック
                            if self.subjectNum == "" {
                                self.subjectNum = String(self.ctr.subjectNo)
                            }
                            
                            // サブジェクト番号のチェック
                            if let sbjNumTest = Int(self.subjectNum) {
                                // サブジェクト番号の0以下チェック
                                if sbjNumTest <= 0  {
                                    // サブジェクト番号の初期化
                                    self.subjectNum = "1"
                                // サブジェクト番号が最大値より大きくなったら
                                } else if sbjNumTest > self.ctr.subjectNumAll {
                                    // 最大値で固定させる
                                    self.subjectNum = String(self.ctr.subjectNumAll)
                                } else {
                                    // 最大値チェックの問題がなければ、1減らす
                                    self.ctr.subjectNo = Int(self.subjectNum)! - 1
                                }
                                
                                // Subjectの持つページ数を調べ直す
                                self.pageNumInSubject = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages.count
                                self.ctr.pageNumInSubject = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages.count
                                //print(self.pageNumInSubject)
                                
                                // エレメントの個数を数え直す
                                self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[0].textElems.count
                                
                                // 初期化
                                self.ctr.pageNo = 0
                                
                                // ---------------------------------------------------------------------------------------
                                // BlueTooth端末にサブジェクト番号を送る
                                //print(self.bluetoothCtr)
                                
                                // もしBluetoothコントローラが存在するなら物理端末に信号を送る
                                if let bleCtr = self.bluetoothCtr {
                                    bleCtr.sendDataToPeripheral(String(self.ctr.subjectNo+1).data(using: .utf8)!)
                                    //print(self.ctr.subjectNo+1)
                                }
                            }
                        }
                    
                    
                    
                    Button(action: {
                        
                        self.stopMusicPlaying()

                        self.pageNum = "1"
                        
                        let sbjNumTest = self.ctr.subjectNo + 1
                        
                        if sbjNumTest >= self.ctr.subjectNumAll {
                            
                            // 初期化
                            self.ctr.pageNo = 0
                            
                            self.ctr.subjectNo = self.ctr.subjectNumAll - 1
                            self.subjectNum = String("\(self.ctr.subjectNumAll)")
                            
                            // Subjectの持つページ数を調べ直す
                            self.pageNumInSubject = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages.count
                            self.ctr.pageNumInSubject = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages.count
                            
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[0].textElems.count
                            
                            
                        } else {
                            
                            // 初期化
                            self.ctr.pageNo = 0
                            
                            self.ctr.subjectNo += 1
                            self.subjectNum = String(self.ctr.subjectNo + 1)
                            
                            // Subjectの持つページ数を調べ直す
                            self.pageNumInSubject = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages.count
                            self.ctr.pageNumInSubject = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages.count
                            
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[0].textElems.count
                            
                        }
                        
                    }, label: {
                        
                        Image(systemName: "chevron.right.square.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20).padding()
 
                    })
                    .buttonStyle(.borderless)
       
                }

                
            }

            
            // ページナビゲーション
            if self.isPageVisible == true {
                
                
                HStack {
                    
                    Button(action: {
                        
                        self.stopMusicPlaying()

                        let pgNumTest = self.ctr.pageNo - 1
                        
                        if pgNumTest < 0 {
                            
                            self.ctr.pageNo = 0
                            self.pageNum = String("1")
                            
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems.count
                            
                            
                        } else {
                            //print("NOT UNDER 0")
                            
                            self.ctr.pageNo -= 1
                            self.pageNum = String(self.ctr.pageNo + 1)
                            
                            //print(self.pageNum)
                            
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems.count
                            //print(self.ctr.elementNumAll)
                        }
                        
                        
                    }, label: {
                        
                        Image(systemName: "arrowshape.turn.up.left.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20).padding()
                            .foregroundColor( self.isHoveringPGBack ? .accentColor : .mint)
                            .onHover{ self.isHoveringPGBack = $0 }

                            // ホバーした時の変化
                            // State のBool値を使用
                            // https://zenn.dev/kyome/articles/f2427e96862c0d
                    })
                    .buttonStyle(.borderless)
                    
                    

                    
                    TextField("ページ番号", text: self.$pageNum)
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.squareBorder)
                        .frame(width: 40, height: 20)
                        .focused(self.$isFocusedPage)
                        .onSubmit {
                            //print("CURRENT PAGE NO IS ::  \(self.pageNum)")
                            
                            self.stopMusicPlaying()

                            // 空欄への対応
                            if self.pageNum == "" {
                    
                                self.pageNum = String(self.ctr.pageNo)
                    
                            }
                    
                            if let pgNumTest = Int(self.pageNum) {
                    
                                if pgNumTest <= 0 {
                    
                                    self.pageNum = "1"
                    
                                } else if pgNumTest > self.ctr.pageNumInSubject {
                    
                                    self.pageNum = String(self.ctr.pageNumInSubject)
                    
                                } else {
                    
                                    self.ctr.pageNo = Int(self.pageNum)! - 1
                    
                                }
                    
                    
                    
                                self.ctr.pageNo = Int(self.pageNum)! - 1
                    
                                // エレメントの個数を数え直す
                                self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[ctr.subjectNo].pages[self.ctr.pageNo].textElems.count
                                //print(self.ctr.elementNumAll)
                    
                            }
                        }
                    
                    

                    
                    Button(action: {

                        
                        self.stopMusicPlaying()
                        
                        
                        let pgNumTest = self.ctr.pageNo + 1
                        
                        if pgNumTest >= self.ctr.pageNumInSubject {
                            
                            self.ctr.pageNo = self.ctr.pageNumInSubject - 1
                            self.pageNum = String("\(self.ctr.pageNumInSubject)")
                            
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems.count
                            
                            
                        } else {
                            
                            self.ctr.pageNo += 1
                            self.pageNum = String(self.ctr.pageNo + 1)
                            print(self.pageNum)
                            
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems.count
                            print(self.ctr.elementNumAll)
                        }
                        
                        
                    }, label: {
                        
                        Image(systemName: "arrowshape.turn.up.right.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20).padding()
                            .foregroundColor( self.isHoveringPGForward ? .accentColor : .mint)
                            .onHover{ self.isHoveringPGForward = $0 }
                    })
                    .buttonStyle(.borderless)
                    
  
                    
                }
                .padding(EdgeInsets(top: -20, leading: 0, bottom: 10, trailing: 0))
  
            }
            

            

            // ┌───────────────────────────┐
            // │                           │
            // │          SLIDER           │
            // │                           │
            // └───────────────────────────┘
            // https://stackoverflow.com/questions/65736518/how-do-i-create-a-slider-in-swiftui-for-an-int-type-property
            //

        }
        .frame(height: 100)
        .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
        .offset(y: self.ctr.yPosAnim)
        .animation(.easeInOut(duration: 0.2), value: self.ctr.yPosAnim)
        
    }

    
}

