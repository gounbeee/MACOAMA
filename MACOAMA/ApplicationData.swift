//
//  ApplicationData.swift
//  MACOAMA
//
//  Created by Si Young Choi on 2023/04/21.
//

import SwiftUI



struct File: Identifiable {
    
    let id: UUID = UUID()
    
    var name: String
    
}



struct FileContent {
    
    var name: String
    
    var content: String
    
}


// Protocol の ObservableObject
//
// ┌──────────────────┐
// │ ObservableObject │
// └──────────────────┘
//
// このProtocolが準拠されたオブジェクトでは、@ PublishedのPropertyWrapperで定義された情報が「変更された時」
// そのオブジェクトの持つobjectWillChangeというPublisher（ObjectWillChangePublisher型）を実行する。
//

class ApplicationData: ObservableObject {
    
    // Fileたちのリスト
    @Published var listOfFiles: [File] = []
    
    // 現在修正中、または新規作成中のファイル
    @Published var selectedFile: FileContent
    
    // 書き出しを行うためのフラグ用の情報
    @Published var openExporter: Bool = false
    

    // 共有中のファイルに関連して様々な機能を提供する。
    // 内部的に、Singletonとして実装されている模様。
    var manager: FileManager
    
    // Fileの場所を示すパス
    var docURL: URL
    
    // FileDocument 型のカスタムクラスである TextDocument
    var document: TextDocument
    

    
    init() {
        
        // FileManager のシングルトンであるインスタンスを取ってくる
        manager = FileManager.default
        
        // FileManager クラスの urls メソッド
        // ┌────┐
        // │urls│
        // └────┘
        //
        // This API is suitable when you need to search for a file or files which
        // may live in one of a variety of locations in the domains specified.
        //
        // 一箇所、または複数の場所にあるファイル、または複数のファイルを検索するために使う。
        //
        let documents = manager.urls(for: .documentDirectory, in: .userDomainMask)
            
        // documents は、urls()　の戻り値の[URL]である。
        // よって、その配列の最初の要素、を下で取得している。
        docURL = documents.first!
        
        // カスタム構造体であるTextDocumentのオブジェクトを生成
        document = TextDocument()
        
        // 現在選択しているファイルを指定するための構造体をインスタンス化
        selectedFile = FileContent(name: "", content: "")
        
        // FileManagerクラスのメソッドである contentsOfDirectory()メソッド
        // ┌───────────────────┐
        // │contentsOfDirectory│
        // └───────────────────┘
        //
        // returns an NSArray of NSStrings representing the filenames of the items in the directory.
        //
        // 渡されたパスの中にあるファイルたちの名前を配列として取得する。
        //
        if let list = try? manager.contentsOfDirectory(atPath: docURL.path) {
            
            // ファイルオブジェクトを収納した配列を埋めて用意する。
            for name in list {
                // 文字列だけではなく、Fileインスタンスを生成して配列に入れる。
                let newFile = File(name: name)
                listOfFiles.append(newFile)
                
            }
            
        }

        
    }
    
    
    
    func saveFile(name: String) {
        
        // 渡された文字列をもとに、パスのURL情報を整える
        let newFileURL = docURL.appendingPathComponent(name)
        
        // URLから、パス情報を取得
        let path = newFileURL.path
        
        // ファイルを生成
        manager.createFile(atPath: path, contents: nil, attributes: nil)
        
        // もし、現在のファイルリストにこの新しいファイルが「ない」のであれば、
        // このファイルは確実に「新規ファイル」である。
        // なので、ファイルリストに追加を行う。
        if !listOfFiles.contains(where: { $0.name == name}) {
            
            listOfFiles.append(File(name: name))
            
        }
        
        
    }
    
    
    // 新しくファイルを生成することはなく、既存のファイルを保存し直す。
    func saveContent() {
        
        if let data = selectedFile.content.data(using: .utf8, allowLossyConversion: true) {
            
            let path = docURL.appendingPathComponent(selectedFile.name).path
            
            manager.createFile(atPath: path, contents: data, attributes: nil)
            
        }
                
    }
    
    
    // ファイルの書き出し
    func exportDocument(file: File) {
        
        let content = getDocumentContent(file: file)
        
        selectedFile = FileContent(name: file.name, content: content)
        
        document.documentText = content
        
        // fileExporterは、フラグをtrueにすることで、起動する。
        openExporter = true
        
        
    }
    
    
    // ファイルの内容を取得するメソッド
    func getDocumentContent(file: File) -> String {
        
        selectedFile.name = file.name
        
        let path = docURL.appendingPathComponent(file.name).path
        
        if manager.fileExists(atPath: path) {
            
            if let data = manager.contents(atPath: path) {
                
                if let content = String(data: data, encoding: .utf8) {
                    
                    return content
                    
                }
            }
        }
        
        // もし問題があったら、空白の文字列を返す。
        return ""
                
    }
    
}

