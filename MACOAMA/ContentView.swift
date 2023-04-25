//
//  ContentView.swift
//  MACOAMA
//
//  Created by Si Young Choi on 2023/04/20.
//

import SwiftUI

struct ContentView: View {
    
    
    
    // このViewより上位のViewから渡された、ObservableObjectを使って
    // このViewの中で起こることを共有し合う。
    @EnvironmentObject var appData: ApplicationData
    
    // ドキュメントの新規作成時必要となるフラグとしての情報
    //
    @State private var openSheet: Bool = false
    
    
    
    var body: some View {
        
        // View Protocol を準拠する構造体 NavaigationStack
        // ┌──────────────────┐
        // │ NavaigationStack │
        // └──────────────────┘
        //
        // A view that displays a root view and enables you
        // to present additional views over the root view.
        //
        // RootとしてのViewを持ち、そのRootからStackのように「重なる」形で
        // 次のViewへ遷移するView。
        // Rootと設定されるViewはずっと常駐し、重なる遷移先のViewはその「上」に
        // 重なるように出現し、役目が終わると下にあったRoot Viewが「現れる」ようになる。
        // だから、Stackという名前がついていると予想する。
        //
        //
        // Rootから遷移するViewたちは、NavigationLinkで定義する。
        //
        //
        NavigationStack {
            
            // 垂直方向でViewを積み上げるように構成
            //
            // ViewBuilder型を持つContentを持っていて、それらを表示させる。
            // ViewBuilderは、Closureを渡してViewを生成させてくれる役割を持つ。
            //
            VStack {
                
                // 一行の情報を複数持って、リスト上に並べるためのView
                List {
                    
                    ForEach(appData.listOfFiles) { file in
                        
                        // NavigationStackのRoot Viewから遷移するViewたち
                        //
                        // Creates a navigation link that presents the destination view.
                        //   - Parameters:
                        //
                        //   - destination: A view for the navigation link to present.
                        //
                        //   - label: A view builder to produce a label describing the `destination`
                        //     to present.
                        //
                        //
                        //
                        NavigationLink(
                            // 遷移する先であるView
                            destination: {
                            
                                EditFileView(file: file)
                            
                            },
                            // 遷移先を描写するためのラベル
                            // ここでは、追加機能として共有用のボタンを表示させているようだ。
                            label: {
                            
                                // File の名前表示
                                // 共有するためのボタン表示
                                HStack {
                                    // File の名前
                                    Text(file.name)
                                    Spacer()

                                    // 共有のためのボタン
                                    // 四角から上向矢印
                                    Button(action: {
                                        appData.exportDocument(file: file)
                                    }, label: {
                                        Image(systemName: "square.and.arrow.up")
                                    })
                                    .buttonStyle(.plain)
                                    

                                }
                            
                            }
                            
                        ) // NavigationLink
                        
                    }
                    
                }
                .listStyle(.plain)
                
            }
            .padding()
            .navigationBarTitle("Files")
            .navigationBarTitleDisplayMode(.inline)
            //
            //
            //
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Add File") {
                        openSheet = true
                    }
                    
                }
                
            }
            
            
            .sheet(isPresented: $openSheet) {
                
                Text("新しいファイルを作成")
                
                AddFileView()
                
            }   // VStack
            
            
            // ここにおくと、FloatするFooterのようになる。
            Text("Test Footer Text")
            
        }
        
    }
    
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ApplicationData())
    }
}


