//
//  MACOAMAApp.swift
//  MACOAMA
//
//  Created by Si Young Choi on 2023/04/20.
//

import SwiftUI

@main
struct MACOAMAApp: App {
    
    // オブジェクトである、STATE
    // アプリのデータを統括するオブジェクト
    // アプリ内の状態管理の主要道具である。
    @StateObject var appData = ApplicationData()
    
    
    var body: some Scene {
        
        // ┌───────────┐
        // │WindowGroup│
        // └───────────┘
        // https://developer.apple.com/documentation/swiftui/windowgroup/
        //
        // A scene that presents a group of identically structured windows.
        //
        // WINDOWをグルーピングして扱うための機能。
        // 単一で、固有のWINDOWを持つSCENEなら、Window構造体を使用する。
        // 複数のWindowで、同一の扱いでグループをなすWindowを使用するならWindowGroup構造体を使用する。
        //
        //
        //
        //
        WindowGroup {
            
            Text("GLOBAL TITLE")
            
            ContentView()
            
                // View Protocol に拡張された機能であるenvironmentObject
                // ┌─────────────────┐
                // │environmentObject│
                // └─────────────────┘
                //
                // The object can be read by any child by using `EnvironmentObject`.
                //
                // このメソッドにObservableObjectを渡すことで、このViewより下位のViewたちの中で、
                // 状態を共有することができるようになる。
                //
                // その際、下位のViewでは、@ EnvironmentObject Property Wrapperを適用することで、
                // ここで渡しているObservableObjectにアクセスできる。
                //
                .environmentObject(appData)
            
                // View Protocol に拡張された機能であるfileExporter
                // ┌────────────┐
                // │fileExporter│
                // └────────────┘
                //
                // Presents a system interface for allowing the user to export an in-memory
                // document to a file on disk.
                //
                // メモリ上に保存しているドキュメントをファイルとして書き出す機能。
                //
                //
                // In order for the interface to appear, both `isPresented` must be `true`
                // and `document` must not be `nil`. When the operation is finished,
                // `isPresented` will be set to `false` before `onCompletion` is called. If
                // the user cancels the operation, `isPresented` will be set to `false` and
                // `onCompletion` will not be called.
                // The `contentType` provided must be included within the document type's
                // `writableContentTypes`, otherwise the first valid writable content type
                // will be used instead.
                //
                //
                // このインタフェースを使用するため、isPresented は trueである必要があって、また、documentはnilではいけない。
                // 実行が終わる時は、isPresentedがfalseになり、その後、onCompletionに渡されているClosureが実行される。
                //
                .fileExporter(isPresented: $appData.openExporter,
                              document: appData.document,
                              contentType: .json,
                              defaultFilename: appData.selectedFile.name,
                              onCompletion: { result in
                    print("Document saved")
                })
            
            
            
        }
    }
    
}
