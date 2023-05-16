//
//  MathSubjectController.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/04.
//

import Foundation
import SwiftUI


class MathSubjectController : ObservableObject {
    
    static var ElementWidth : Double = 480
    static var ElementHeight : Double = 640
    
    static var ElementWidthLimit : Double = 1920
    static var ElementHeightLimit : Double = 1920
    
    @Published var subjectNumAll: Int = 0

    @Published var pageNumAll: Int = 0
    @Published var elementNumAll: Int = 0
    
    @Published var jsonText : String = "Default Json Text"
    @Published var jsonObj : MathSubjectResponse? = nil

    @Published var currentWindowWidthStr : String = String(MathSubjectController.ElementWidth)
    @Published var currentWindowHeightStr : String = String(MathSubjectController.ElementHeight)
    
    var subjectNo: Int = 0
    var pageNo: Int = 0
    
    // 開発用画面表示の有無
    var isEditMode = false
 
    // ページがレンダリングされると、保存のためこちらに入れておく
    public var parsedView : MathSubjectCreatePageView? = nil
    
    @Published var pageNumInSubject: Int = 0
    
    // ページ移動用のコントローラの表示有無
    @Published var isSubjectVisible : Bool = true
    @Published var isPageVisible : Bool = true
    
    
    var isLinkedView : Bool = false
    

    
    
    func addNewSubject() {
        
        let newElemId = "txt" + String(self.subjectNo+1) + "-" + "1" + "-" + "1"
        
        let newSubject : MathSubject = MathSubject(title: "Sample Title",
                                                   pages: [MathPage](repeating: MathPage(pageNum: 1,
                                                                                         duration: 5000,
                                                                                         textElems: [MathPageTextElm](repeating: MathPageTextElm(id: newElemId,
                                                                                                                                                 font: "GenEiKoburiMin6-R",
                                                                                                                                                 content: "サンプルコンテンツ"+"-1",
                                                                                                                                                 size: CGFloat(100.0),
                                                                                                                                                 position: MathPosition(x: 0.02, y: 0.25),
                                                                                                                                                 color: MathColor(red: 0, green: 0, blue: 0, opacity: 255),
                                                                                                                                                 bgColor: MathColor(red: 0, green: 0, blue: 0, opacity: 0),
                                                                                                                                                 timeIn: 0,
                                                                                                                                                 timeOut: 1000,
                                                                                                                                                 links: "none"),
                                                                                                                      count: 1) ),
                                                                     count: 1),
                                                   color: MathColor(red: 80,
                                                                    green: 130,
                                                                    blue: 200,
                                                                    opacity: 255))
        
        
        self.jsonObj!.subjects.insert(newSubject, at: self.subjectNo + 1)
        
        self.subjectNo += 1
        self.pageNo = 0

        self.subjectNumAll = self.jsonObj!.subjects.count
        self.pageNumInSubject = self.jsonObj!.subjects[self.subjectNo].pages.count
        self.pageNumAll = countAllPages(jsonObject : self.jsonObj!)
        self.elementNumAll = self.jsonObj!.subjects[self.subjectNo].pages[self.pageNo].textElems.count
        
        
        self.updateJsonAndReload()
        
        print( self.pageNumInSubject )
        
    }
    
    
    func addNewPage() {
        
        let newElemId = "txt" + String(self.subjectNo + 1) + "-" + String(self.pageNo + 1 + 1) + "-" + "1"
        
        let newPage : MathPage = MathPage(pageNum: self.pageNo + 1,
                                          duration: 5000,
                                          textElems: [MathPageTextElm](repeating: MathPageTextElm(id: newElemId,
                                                                                                  font: "GenEiKoburiMin6-R",
                                                                                                  content: "サンプルコンテンツ"+"-1",
                                                                                                  size: CGFloat(100.0),
                                                                                                  position: MathPosition(x: 0.02, y: 0.25),
                                                                                                  color: MathColor(red: 0, green: 0, blue: 0, opacity: 255),
                                                                                                  bgColor: MathColor(red: 0, green: 0, blue: 0, opacity: 0),
                                                                                                  timeIn: 0,
                                                                                                  timeOut: 1000,
                                                                                                  links: "none"),
                                                                       count: 1))
                                                                  
                                                   
        
        
        self.jsonObj!.subjects[self.subjectNo].pages.insert(newPage, at: self.pageNo + 1)
        
        self.pageNo += 1

        self.pageNumInSubject = self.jsonObj!.subjects[self.subjectNo].pages.count
        self.pageNumAll = countAllPages(jsonObject : self.jsonObj!)
        self.elementNumAll = self.jsonObj!.subjects[self.subjectNo].pages[self.pageNo].textElems.count

        self.updateJsonAndReload()
        
        print( self.pageNumInSubject )
        
    }
    
    
    
    func addNewElement() {
        
        
        let element : MathPageTextElm = MathPageTextElm(id: "initial",
                                                         font: "GenEiKoburiMin6-R",
                                                         content: "initial",
                                                         size: 100.0,
                                                         position: MathPosition(x: 0.02, y: 0.25),
                                                         color: MathColor(red: 0, green: 0, blue: 0, opacity: 255),
                                                         bgColor: MathColor(red: 0, green: 0, blue: 0, opacity: 0),
                                                         timeIn: 0, timeOut: 1000,
                                                         links: "none")
        
        
        self.jsonObj!.subjects[self.subjectNo].pages[self.pageNo].textElems.append(element)
        
        
        self.updateJsonAndReload()
        
       
        
    }
    
    
    
    func deleteCurrentSubject() {
        

        if self.subjectNumAll != 1 {
            
            let sbjNumTest = self.subjectNo - 1
            self.jsonObj!.subjects.remove(at: self.subjectNo)

            
            if sbjNumTest < 0 {
                
                self.subjectNo = 0
                
            } else {
                
                self.subjectNo -= 1
                
            }

            self.pageNumInSubject = self.jsonObj!.subjects[self.subjectNo].pages.count
            self.pageNumAll = countAllPages(jsonObject : self.jsonObj!)
            self.elementNumAll = self.jsonObj!.subjects[self.subjectNo].pages[self.pageNo].textElems.count
            
            self.updateJsonAndReload()
            
        }
        
        
    }
    
    
    func deleteCurrentPage() {
        
        if self.pageNumInSubject != 1 {

            let pgNumTest = self.pageNo - 1
            
            self.jsonObj!.subjects[self.subjectNo].pages.remove(at: self.pageNo)
            
            
            
            if pgNumTest < 0 {
                
                self.pageNo = 0
                
            } else {
                
                self.pageNo -= 1
                
            }
            
            self.pageNumInSubject = self.jsonObj!.subjects[self.subjectNo].pages.count
            self.pageNumAll = countAllPages(jsonObject : self.jsonObj!)
            self.elementNumAll = self.jsonObj!.subjects[self.subjectNo].pages[self.pageNo].textElems.count
            
            self.updateJsonAndReload()
            
        }
        
    }
    
    
    
    func deleteElementWithNumber( num: Int ) {
        
        
        self.jsonObj!.subjects[self.subjectNo].pages[self.pageNo].textElems.remove(at: num)
        
        self.updateJsonAndReload()
        
    }
    
    
    func updateJsonAndReload() {
        
        // Contorller が管理するJSONテキストまで更新をする
        
        // JSONとして書き出し
        let encoder = JSONEncoder()
        
        // 綺麗なJSONフォーマットに出力
        // https://www.hackingwithswift.com/example-code/language/how-to-format-json-using-codable-and-pretty-printing
        encoder.outputFormatting = .prettyPrinted
        
        guard let jsonValue = try? encoder.encode(self.jsonObj!) else {
            
            fatalError("JSON構成でエラー発生")
            
        }
        
        // 現在のJSONテキストを更新
        self.jsonText = String(bytes: jsonValue, encoding: .utf8)!
        
        
        // その後、新しくなったテキストをもとに、JSONオブジェクトを更新
        // この関数は、ObservableObjectであるコントローラーを更新するため、関連するView全体が更新される。
        self.parseJson()
        
    }
    
    
    
    
    func parseJson() {
        let json = self.jsonText.data(using: .utf8)!
        let mathSubjectsRes = try! JSONDecoder().decode(MathSubjectResponse.self, from: json)
        
        self.jsonObj = mathSubjectsRes
        
        
        // 教材の個数をカウント
        self.subjectNumAll = self.jsonObj!.subjects.count
        self.pageNumInSubject = self.jsonObj!.subjects[self.subjectNo].pages.count
        self.pageNumAll = countAllPages(jsonObject : self.jsonObj!)
        self.elementNumAll = self.jsonObj!.subjects[self.subjectNo].pages[self.pageNo].textElems.count
        
        
        
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
    
    
    
    func countSubjects( jsonObject : MathSubjectResponse ) -> Int {
        
        var countedSubjects = 0
        
        for _ in jsonObject.subjects {
            
            //print(i)
            countedSubjects += 1
            
        }
        
        print("COUNTING SUBJECTS ::  \(countedSubjects)   ARE COUNTED !!!!")
        
        return countedSubjects
        
        
    }
    
    
    func countPagesInSubject( subjectNo: Int, jsonObject : MathSubjectResponse ) -> Int {
        
        var countedPagesInSubject = 0
        
        let subj = jsonObject.subjects[subjectNo]
        
        
        for _ in subj.pages {
            
            //print(page)
            countedPagesInSubject += 1
            
        }
        
        
        
        print("COUNTING PAGES IN CURRENT SUBJECT ::  \(countedPagesInSubject)   ARE COUNTED !!!!")
        
        return countedPagesInSubject
        
        
    }
    
    
    
    
    func countAllPages( jsonObject : MathSubjectResponse ) -> Int {
        
        var countedPages = 0
        
        for subject in jsonObject.subjects {
            
            //print(i)
            
            for _ in subject.pages {
                
                //print(page)
                countedPages += 1
                
            }
            
        }
        
        //print("COUNTING PAGES ::  \(countedPages)   ARE COUNTED !!!!")
        
        return countedPages
        
        
    }
    
    
    
    func renameElemTitleWithIndex() {
                
        //var countedPages = 0
        
        for subjectInd in 0...self.jsonObj!.subjects.count-1 {
            
            for pageInd in 0...self.jsonObj!.subjects[subjectInd].pages.count-1 {
                
                //JSONのページ番号をインデックス番号にする
                self.jsonObj!.subjects[subjectInd].pages[pageInd].pageNum = pageInd + 1
                
                for elemInd in 0...self.jsonObj!.subjects[subjectInd].pages[pageInd].textElems.count-1 {
                    
                    //JSONの要素番号をインデックス番号にする
                    self.jsonObj!.subjects[subjectInd].pages[pageInd].textElems[elemInd].id = "txt" + String(subjectInd+1) + "-" + String(pageInd+1) + "-" + String(elemInd+1)
                    
                }
                
            }
            
        }
        
        self.updateJsonAndReload()
        //print("COUNTING PAGES ::  \(countedPages)   ARE COUNTED !!!!")
        
        print("RENAMED!")
        
    }
    
    
    
    func randomLinkArray(currentSbjNo : Int , inputLinks: [String]) -> [String] {
        
        var inputProxy : [String] = inputLinks
        var randomedArr : [String] = []
        var resultArr : [String] = []
        
        // 1. まずは、ランダムに」配置しなおすだけ
        // [1,3,5]   -->   [3,1,5]
        for _ in 0...inputLinks.count-1 {
            // まず、入力をただランダムに並べ替える
            if let randomPicked = inputProxy.randomElement() {
                if inputProxy.count > 0 {
                    //print(randomPicked)
                    randomedArr.append(randomPicked)
                    // 選ばれたのは削除
                    inputProxy.removeAll(where: { $0 == randomPicked })
                }
            }
        }

        
        // 2. もし、そもそも入力の要素数が9を超えるなら、むしろ削るべき
        // [ 1,2,3,4,5,6,7,8,9,10,11 ]   -->   [ 1,2,3,4,5,6,7,8,9 ]
        var adjustedNine : [String] = []
        
        if randomedArr.count > 9 {
            // 9個までインプット
            for i in 0...9 {
                adjustedNine.append(randomedArr[i])
            }
        } else {
            adjustedNine = randomedArr
        }
        
        
        // 3. 9個の要素を持つように再構成
        for ind in 0..<9 {
            // まず、入力をただランダムに並べ替える
            if let randomPickedAgain = randomedArr.randomElement() {
                
                // 4. 最初のインデックス番号のとき、入力された教材の番号にする必要がある。
                // 最初の要素は、COARAMAUSEのサーバー機が表示する教材である。
                // なので、パラメーターで入力された、この教材の番号を、最初の要素に適用しておく
                if ind == 0 {
                    
                    // ["157", "5" ---
                    // になっていくので、最初の要素はまだ０ベースのインデックスだ。１と足して保存する。
                    resultArr.append(String(currentSbjNo+1))
                    
                } else if resultArr.count <= 9 {
                    
                    resultArr.append(randomPickedAgain)
                    
                } else {
                    break
                }
            }
        }
        
   
        //print(resultArr)

        return resultArr

    }
    
    
    // この関数は、旧バージョンの教材番号に変えるための機能
    func transformLinkArray(inputLinksStr: [String]) -> [String] {
        
        var result : [String] = []
        
        // ここの教材番号は、１から始まるインデックスとする
        let transfromTable : [Int : Int] = [
         1  : 1,
         2  : 2,
         3  : 3,
         4  : 4,
         5  : 5,
         6  : 6,
         7  : 7,
         8  : 8,
         9  : 9,
         10 : 10,
         11 : 11,
         12 : 12,
         13 : 13,
         14 : 14,
         15 : 15,
         16 : 16,
         17 : 17,
         18 : 18,
         19 : 19,
         20 : 20,
         21 : 21,
         22 : 22,
         23 : 23,
         24 : 24,
         25 : 25,
         26 : 26,
         27 : 27,
         28 : 28,
         29 : 29,
         30 : 30,
         31 : 31,
         32 : 32,
         33 : 33,
         34 : 34,
         35 : 35,
         36 : 36,
         37 : 37,
         38 : 38,
         39 : 39,
         40 : 40,
         41 : 41,
         42 : 42,
         43 : 43,
         44 : 44,
         45 : 45,
         46 : 46,
         47 : 50,
         48 : 51,
         49 : 52,
         50 : 53,
         51 : 54,
         52 : 55,
         53 : 56,
         54 : 57,
         55 : 58,
         56 : 59,
         57 : 60,
         58 : 61,
         59 : 62,
         60 : 63,
         61 : 64,
         62 : 65,
         63 : 66,
         64 : 67,
         65 : 68,
         66 : 94,
         67 : 95,
         68 : 96,
         69 : 97,
         70 : 98,
         71 : 99,
         72 : 100,
         73 : 101,
         74 : 102,
         75 : 103,
         76 : 104,
         77 : 105,
         78 : 106,
         79 : 107,
         80 : 108,
         81 : 109,
         82 : 110,
         83 : 111,
         84 : 112,
         85 : 113,
         86 : 114,
         87 : 115,
         88 : 116,
         89 : 117,
         90 : 118,
         91 : 119,
         92 : 120,
         93 : 121,
         94 : 122,
         95 : 123,
         96 : 124,
         97 : 125,
         98 : 126,
         99 : 150,
        100 : 151,
        101 : 152,
        102 : 153,
        103 : 154,
        104 : 155,
        105 : 156,
        106 : 157,
        107 : 158,
        108 : 159,
        109 : 160,
        110 : 161,
        111 : 162,
        112 : 163,
        113 : 164,
        114 : 165,
        115 : 166,
        116 : 500,
        117 : 501,
        118 : 502,
        119 : 503,
        120 : 2000,
        121 : 2001,
        122 : 2002,
        123 : 2003,
        124 : 2004,
        125 : 2005,
        126 : 2006,
        127 : 2007,
        128 : 2008,
        129 : 3000,
        130 : 3001,
        131 : 3002,
        132 : 3003,
        133 : 3004,
        134 : 3005,
        135 : 3006,
        136 : 3007,
        137 : 3008,
        138 : 3009,
        139 : 3010,
        140 : 3011,
        141 : 3012,
        142 : 3013,
        143 : 3014,
        144 : 3015,
        145 : 3016,
        146 : 3017,
        147 : 3018,
        148 : 4000,
        149 : 4001,
        150 : 4002,
        151 : 4003,
        152 : 4004,
        153 : 4005,
        154 : 6000,
        155 : 6001,
        156 : 7000,
        157 : 7001,
        158 : 7002
        ]
        
        
        // 入力される数字の配列の一つ一つを上のテーブルを基盤に変換する

        for subjectNo in inputLinksStr {
            
            //print(Int(subjectNo)!)
            result.append(String(transfromTable[ Int(subjectNo)! ]!))
            
        }

        //print(transfromTable)

        return result
        
    }
    
    
    
}
