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
    @State var pageNum : String = "1"
    @State var bluetoothCtr : BluetoothController? = nil
    
    @State var isSubjectVisible : Bool = true
    @State var isPageVisible : Bool = true
    
    
    var body: some View {
        
        VStack {
            
            if self.isSubjectVisible == true {
                
                MusicPlayView()
                
                HStack {
                    
                    TextField("サブジェクト番号", text: self.$subjectNum)
                        .frame(width: 50)
                        .onSubmit {
                            //print("CURRENT SUBJECT NO IS ::  \(self.subjectNum)")
                            
                            self.pageNum = "1"
                            
                            // 空欄へのチェック
                            if self.subjectNum == "" {
                                
                                self.subjectNum = String(self.ctr.subjectNo)
                                
                            }
                            
                            
                            if let sbjNumTest = Int(self.subjectNum) {
                                
                                
                                if sbjNumTest <= 0  {
                                    
                                    self.subjectNum = "1"
                                    
                                } else if sbjNumTest >
                                            self.ctr.subjectNumAll {
                                    
                                    self.subjectNum = String(self.ctr.subjectNumAll)
                                    
                                } else {
                                    
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
                                if let bleCtr = self.bluetoothCtr {
                                    bleCtr.sendDataToPeripheral(String(self.ctr.subjectNo+1).data(using: .utf8)!)
                                }
                                
                                
                                
                            }
                        }
                    
                    Button("<<") {
                        
                        self.pageNum = "1"
                        
                        let sbjNumTest = self.ctr.subjectNo - 1
                        
                        if sbjNumTest < 0 {
                            
                            self.ctr.subjectNo = 0
                            self.subjectNum = String("1")
                            
                            // Subjectの持つページ数を調べ直す
                            self.pageNumInSubject = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages.count
                            self.ctr.pageNumInSubject = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages.count
                            
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[0].textElems.count
                            
                            // 初期化
                            self.ctr.pageNo = 0
                            
                        } else {
                            
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
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                    
                    
                    
                    
                    Button(">>") {
                        
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
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.regular)
                    
                    
                }
                
                
            }
            
            
            if self.isPageVisible == true {
                
                
                HStack {
                    
                    
                    TextField("ページ番号", text: self.$pageNum)
                        .frame(width: 50)
                        .onSubmit {
                            print("CURRENT SUBJECT NO IS ::  \(self.pageNum)")
                            
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
                                
                                
                            }
                        }
                    
                    Button("<<") {
                        
                        
                        let pgNumTest = self.ctr.pageNo - 1
                        
                        if pgNumTest < 0 {
                            
                            self.ctr.pageNo = 0
                            self.pageNum = String("1")
                            
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems.count
                            
                            
                        } else {
                            
                            self.ctr.pageNo -= 1
                            self.pageNum = String(self.ctr.pageNo + 1)
                            
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems.count
                            
                        }
                        
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)
                    .controlSize(.regular)
                    
                    
                    // ボタンの色付け tint モディファイア
                    // https://sarunw.com/posts/swiftui-button-background-color/
                    
                    
                    
                    Button(">>") {
                        
                        
                        let pgNumTest = self.ctr.pageNo + 1
                        
                        if pgNumTest >= self.ctr.pageNumInSubject {
                            
                            self.ctr.pageNo = self.ctr.pageNumInSubject - 1
                            self.pageNum = String("\(self.ctr.pageNumInSubject)")
                            
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems.count
                            
                            
                        } else {
                            
                            self.ctr.pageNo += 1
                            self.pageNum = String(self.ctr.pageNo + 1)
                            
                            // エレメントの個数を数え直す
                            self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[self.ctr.subjectNo].pages[self.ctr.pageNo].textElems.count
                            
                        }
                        
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.mint)
                    .controlSize(.regular)
                    
                }
                
                
            }
            
            
            
            
            // ┌───────────────────────────┐
            // │                           │
            // │          SLIDER           │
            // │                           │
            // └───────────────────────────┘
            // https://stackoverflow.com/questions/65736518/how-do-i-create-a-slider-in-swiftui-for-an-int-type-property
            //
            //            Text("Subject番号")
            //            Slider(value: IntDoubleBinding(self.$ctr.subjectNo).doubleValue,
            //                   in: 0.0...Double(self.ctr.subjectNumAll-1),
            //                   step: 1.0) { state in
            //                print("CURRENT SUBJECT NO IS ::  \(ctr.subjectNo)")
            //
            //                // Subjectの持つページ数を調べ直す
            //                self.pageNumInSubject = self.ctr.jsonObj!.subjects[ctr.subjectNo].pages.count
            //                //print(self.pageNumInSubject)
            //
            //                // エレメントの個数を数え直す
            //                self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[ctr.subjectNo].pages[0].textElems.count
            //
            //                // 初期化
            //                self.ctr.pageNo = 0
            //
            //            }
            //
            //
            //
            //            Text("Page番号")
            //            Slider(value: IntDoubleBinding(self.$ctr.pageNo).doubleValue,
            //                   in: 0.0...Double(self.pageNumInSubject-1),
            //                   step: 1.0) { _ in
            //                print("CURRENT PAGE NO IS ::  \(self.ctr.pageNo)")
            //
            //                // エレメントの個数を数え直す
            //                self.ctr.elementNumAll = self.ctr.jsonObj!.subjects[ctr.subjectNo].pages[self.ctr.pageNo].textElems.count
            //
            //            }
            //           .onAppear {
            //
            //               self.pageNumInSubject = self.ctr.jsonObj!.subjects[ctr.subjectNo].pages.count
            //
            //           }
            

        }
        .frame(height: 100)
        .padding()

    }

}

