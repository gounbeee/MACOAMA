//
//  TextDocument.swift
//  MACOAMA
//
//  Created by Si Young Choi on 2023/04/21.
//


import SwiftUI
import UniformTypeIdentifiers


// SwiftUI のProtocolであるFileDocument
// ┌──────────────┐
// │ FileDocument │
// └──────────────┘
//
// 読み込めるファイルの種類や、描き出せる種類などを指定できる。
// そのような設定を持って、fileWrapperメソッドでエンコーディングする。
//
//
struct TextDocument: FileDocument {
    
    // FileDocument Protocolに定義されている読み込み可能なファイルのタイプ
    static var readableContentTypes: [UTType] = [.json]
    
    // ファイルの内容
    var documentText: String
    
    
    // イニシャライザ引数なし
    init() {
        documentText = ""
    }
    
    // イニシャライザをConfigを使って実行する場合
    init(configuration: ReadConfiguration) throws {
        
        // throws を使ってエラーをチェック
        // throwsを使うと、関数内でthrowを使うことで、値を返す「前」に、エラーを出力できる。
        //
        if let data = configuration.file.regularFileContents {
            
            // text が無事Stringに変換できたら documentText を用意する
            if let text = String(data: data, encoding: .utf8) {
                
                documentText = text
                
            } else {
                
                throw CocoaError(.fileReadCorruptFile)
                
            }
            
        } else {
            
            throw CocoaError(.fileReadCorruptFile)
            
        }
        
    }
    
    
    // FileDocument Protocolの中で定められているメソッド
    //
    // Serializes the document to file contents for a specified configuration.
    //
    // DocumentをFileへエンコードする。
    //
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        
        
        let data = documentText.data(using: .utf8)

        // FileWrapper のregularFileWithContentsを使用するイニシャライザを使用している。
        //
        // A designated initializer for creating an instance for which -isRegularFile returns YES.
        //
        let wrapper = FileWrapper(regularFileWithContents: data!)
        
        
        return wrapper
        
        
    }
    
}

