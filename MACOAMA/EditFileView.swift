//
//  EditFileView.swift
//  MACOAMA
//
//  Created by Si Young Choi on 2023/04/21.
//


import SwiftUI



struct EditFileView: View {
    
    // PROPERTY WRAPPER の EnvironmentObject
    // ┌───────────────────┐
    // │ EnvironmentObject │
    // └───────────────────┘
    // https://developer.apple.com/documentation/swiftui/environmentobject
    //
    // A property wrapper type for an observable object supplied by a parent
    // or ancestor view.
    //
    // このView、EditFileViewより上位のViewから供給された
    // Observable ObjectのためのProperty Wrapperである。
    //
    //　ApplicationDataは、カスタム設定されたクラスだ。
    @EnvironmentObject var appData: ApplicationData
    
    
    // Environment PROPERTY WRAPPER
    // ┌───────────────────┐
    // │    Environment    │
    // └───────────────────┘
    // https://developer.apple.com/documentation/swiftui/environment
    //
    // A property wrapper that reads a value from a view’s environment.
    //
    // Viewの環境から値を読み込むためのProperty Wrapper。
    //
    //
    @Environment(\.dismiss) var dismiss
    
    
    
    // TEXT をもとに、VIEWをレンダリングするか否かのフラグ
    @State private var renderingView = false
    
    
    // File を管理するための変数
    let file: File
    
    // メインとなるView
    var body: some View {
        
        
        
        // SWIFTUIのグループ系VIEWの一つ
        // ┌────────┐
        // │GroupBox│
        // └────────┘
        //
        // Use a group box when you want to visually distinguish a portion
        // of your user interface with an optional title for the boxed content.
        //
        // GroupBoxは、画面の一部を区別させ、タイトルとなるテキストとそれ以外の部分を分けて
        // 内容を表示させる。
        //
        //
        GroupBox(file.name) {
                        
            Button("Render to View"){
                
                //print("MathSubjectView IS ENTERING...")
                renderingView = true

            }
            
            // もし、選択されているファイルがあれば、
            // その内容を最初に表示するように送っている
            TextEditor(text: $appData.selectedFile.content)
                .cornerRadius(10)
                .sheet(isPresented: $renderingView) {
                    //let _ = print("SHEET SHOULD BE DISPLAYED")
                    
                    MathSubjectView(jsonText: $appData.selectedFile.content.wrappedValue)
                    
                }
            
        }
        //
        .navigationTitle("Editor")
        //
        // Viewに対しtoolbarを適用することで、
        // 一般的に使用している画面上部のナビゲーション部分を
        // 設定できる
        .toolbar {
            
            // ツールバーのアイテムを設定。
            // Trailingとして配置しているので、
            // 右側に配置される。
            ToolbarItem(placement: .navigationBarTrailing) {
                
                // 「保存」ボタンを表示
                Button("Save") {
                    // 保存して戻る
                    appData.saveContent()
                    dismiss()
                }
   
            }
 
        }
        // Viewクラスが持つ onAppear メソッド
        // ┌────────┐
        // │onAppear│
        // └────────┘
        // https://developer.apple.com/documentation/swiftui/capsule/onappear(perform:)/
        //
        //
        // Adds an action to perform before this view appears.
        //
        // VIEWがレンダリングされる前に実行される関数
        //
        .onAppear {
            
            // 上位のVIEWから送られてきたデータの中から、
            // FILEの内容を取ってくる。
            // その後、選択されているFILEとして登録する。
            let content = appData.getDocumentContent(file: file)
            appData.selectedFile.content = content
            
        }
        
        
        
        
        
        
        
        
    }
    

}





struct EditFileView_Previews: PreviewProvider {
    static var previews: some View {
        EditFileView(file: File(name: ""))
            .environmentObject(ApplicationData())
    }
}

