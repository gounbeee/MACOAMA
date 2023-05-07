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
    @Published var pageNumInSubject: Int = 0
    @Published var pageNumAll: Int = 0
    @Published var elementNumAll: Int = 0
    
    @Published var jsonText : String = "Default Json Text"
    @Published var jsonObj : MathSubjectResponse? = nil

    @Published var currentWindowWidthStr : String = "540"
    @Published var currentWindowHeightStr : String = "960"
    
    @Published var subjectNo: Int = 0
    @Published var pageNo: Int = 0
    
    
    var elmCtr : MathSubjectElementController? = nil
    
    // ページがレンダリングされると、保存のためこちらに入れておく
    public var parsedView : MathSubjectCreatePageView? = nil
    
    
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
        
        print("COUNTING PAGES ::  \(countedPages)   ARE COUNTED !!!!")
        
        return countedPages
        
        
    }
    
    
    
}