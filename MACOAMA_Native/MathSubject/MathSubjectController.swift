//
//  MathSubjectController.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/04.
//

import Foundation
import SwiftUI


class MathSubjectController : ObservableObject {
    
    static let ElementWidth : Double = 540.0
    static let ElementHeight : Double = 960.0
    
    @Published var subjectNumAll: Int = 0

    @Published var pageNumAll: Int = 0
    @Published var elementNumAll: Int = 0
    
    @Published var jsonText : String = "Default Json Text"
    @Published var jsonObj : MathSubjectResponse? = nil

    @Published var currentWindowWidthStr : String = "540"
    @Published var currentWindowHeightStr : String = "960"
    
    @Published var subjectNo: Int = 0
    @Published var pageNo: Int = 0
    

    
    public var elmCtr : MathSubjectElementController? = nil
    
    // ページがレンダリングされると、保存のためこちらに入れておく
    public var parsedView : MathSubjectCreatePageView? = nil
    
    @Published var pageNumInSubject: Int = 0
    
    
    func addNewSubject() {
        
        let newElemId = "txt" + String(self.subjectNo+1) + "-" + "1" + "-" + "1"
        
        let newSubject : MathSubject = MathSubject(title: "Sample Title",
                                                   pages: [MathPage](repeating: MathPage(pageNum: 1,
                                                                                         duration: 5000,
                                                                                         textElems: [MathPageTextElm](repeating: MathPageTextElm(id: newElemId,
                                                                                                                                                 font: "GenEiKoburiMin6-R",
                                                                                                                                                 content: "サンプルコンテンツ"+"-1",
                                                                                                                                                 size: CGFloat(60.0),
                                                                                                                                                 position: MathPosition(x: 0.0, y: 0.0),
                                                                                                                                                 color: MathColor(red: 0, green: 0, blue: 0, opacity: 255),
                                                                                                                                                 bgColor: MathColor(red: 0, green: 0, blue: 0, opacity: 0),
                                                                                                                                                 timeIn: 0,
                                                                                                                                                 timeOut: 1000),
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
                                                                                                  size: CGFloat(60.0),
                                                                                                  position: MathPosition(x: 0.0, y: 0.0),
                                                                                                  color: MathColor(red: 0, green: 0, blue: 0, opacity: 255),
                                                                                                  bgColor: MathColor(red: 0, green: 0, blue: 0, opacity: 0),
                                                                                                  timeIn: 0,
                                                                                                  timeOut: 1000),
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
                                                         font: "initial",
                                                         content: "initial",
                                                         size: 60.0,
                                                         position: MathPosition(x: 0.0, y: 0.0),
                                                         color: MathColor(red: 0, green: 0, blue: 0, opacity: 255),
                                                         bgColor: MathColor(red: 0, green: 0, blue: 0, opacity: 0),
                                                         timeIn: 0, timeOut: 1000)
        
        
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
    
    
    
}
