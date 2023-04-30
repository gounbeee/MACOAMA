//
//  TextDataView.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/04/26.
//

import SwiftUI


// ┌─────────────────────┐
// │                     │
// │ CREATING NEW WINDOW │
// │                     │
// └─────────────────────┘
//
// 新規ウィンドウを生成する
// https://stackoverflow.com/questions/67344263/swiftui-on-macos-opening-a-new-window
//
extension View {
    private func newWindowInternal(title: String, width: Int , height: Int ) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 20, y: 20, width: width, height: height),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        
        window.center()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(nil)
        
        return window
        
    }
    
    func openNewWindow(title: String = "new Window", width: Int, height: Int) {
        self.newWindowInternal(title: title, width: width, height: height ).contentView = NSHostingView(rootView: self)
    }
}

class NewWindow : ObservableObject {
    
    @Published var newWindowWidth : Int
    @Published var newWindowHeight : Int
    
    init(newWindowWidth: Int, newWindowHeight: Int) {
        self.newWindowWidth = newWindowWidth
        self.newWindowHeight = newWindowHeight
    }
    
}

// JSONのテキストを確認するview
struct TextDataView: View {
    @Environment(\.openWindow) var openWindow
    
    @ObservedObject var textData: TextData
    
    @State private var titleInput: String = ""
    @State private var contentInput: String = ""
    
    @State private var shouldShowDeleteButton: Bool = false
    @State private var shouldPresentConfirm: Bool = false
    
    @State private var newWindowWidth: String = "540"
    @State private var newWindowHeight: String = "960"
    
    
    // TEXT をもとに、VIEWをレンダリングするか否かのフラグ
    //@State private var renderingView = false
    

    var body: some View {
        
        // 表示しようとするテキストのデータが存在するならば、
        // viewを表示する
        if let title = textData.title,
            let updatedAt = textData.updatedAt,
            let content = textData.content {
            
            // 親のViewである、Navigation Barから、遷移先であるViewになる。
            //
            NavigationLink {
                
                // 垂直で並べる
                VStack {
                    
                    
                    HStack {
                        TextField("Image Width", text: $newWindowWidth)
                        TextField("Image Height", text: $newWindowHeight)
                    }
                        
                    
                    // 
                    Button("RENDER TO IMAGE") {
                    
                        let _ = print("RENDERING TO IMAGE !!!")
                        //let _ = print(content)
                        
                        // JSON文字列をParsing、viewへのレンダリングをするためのフラグ
                        //renderingView = true
                        
                        
                        MathSubjectView(jsonText: content,
                                        newWindowWidth: $newWindowWidth,
                                        newWindowHeight: $newWindowHeight)
                            .openNewWindow( title: "教材 Window",
                                            width: Int($newWindowWidth.wrappedValue)!,
                                            height: Int($newWindowHeight.wrappedValue)!)
                        
                        
                        
                    }
                    
                    
                    // 記事のタイトル
                    TextField("Title", text: $titleInput)
                        .onAppear() {
                            // onAppear() MODIFIER
                            // このviewを描画する直前のイベント時に行う
                            self.titleInput = title
                        }
                        .onChange(of: titleInput) { newTitle in
                            // onChange() MODIFIER
                            // State として指定している titleInput に変化があった場合、
                            // このメソッドを実行する。
                            // このメソッドは、メインスレッド実行されるため、
                            // あまり重い処理をさせないのが理想。
                            PersistenceController.shared.updateTextData(
                                textData: textData,
                                title: newTitle,
                                content: contentInput)
                            
                        }
                    
                    
                    
                    TextEditor(text: $contentInput)
                        .font(.system(size: 18))
                        .onAppear() {
                            
                            self.contentInput = content
                            
                        }
                        .onChange(of: contentInput) { newContent in
                            
                            PersistenceController.shared.updateTextData(
                                textData: textData,
                                title: titleInput,
                                content: newContent)
                            
                        }

                }

            } label: {
                
                HStack {
                    
                    Text(title)
                    
                    Text(updatedAt, formatter: itemFormatter)
                    
                    Spacer()
                    
                    
                    if shouldShowDeleteButton || shouldPresentConfirm {
                        
                        
                        Button {
                            
                            shouldPresentConfirm = true
                            
                        } label: {
                            
                            
                            Image(systemName: "minus.circle")
                            
                            
                        }
                        .buttonStyle(.plain)
                        .confirmationDialog("delete_question",
                                            isPresented: $shouldPresentConfirm) {
                            
                            Button("delete_confirm", role: .destructive) {
                                PersistenceController.shared.deleteTextData(
                                    textData: textData)
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                }.onHover { isHover in
                    
                    shouldShowDeleteButton = isHover
                    
                    
                }
                
                
                
            }
            
            
        }
        
        
    }
    
    
}


// 日付のフォーマットを決める
private let itemFormatter: DateFormatter = {
    
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    
    return formatter
    
}()



