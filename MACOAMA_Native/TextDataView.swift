//
//  TextDataView.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/04/26.
//

import SwiftUI

struct TextDataView: View {
    
    
    @ObservedObject var textData: TextData
    
    
    @State private var titleInput: String = ""
    @State private var contentInput: String = ""
    
    
    @State private var shouldShowDeleteButton: Bool = false
    @State private var shouldPresentConfirm: Bool = false
    
    // TEXT をもとに、VIEWをレンダリングするか否かのフラグ
    @State private var renderingView = false
    
    
    var body: some View {
        
        
        if let title = textData.title,
            let updatedAt = textData.updatedAt,
            let content = textData.content {
            
            // 親のViewである、Navigation Barから、遷移先であるViewになる。
            //
            NavigationLink {
                
                VStack {
                    
                    Button("RENDER TO IMAGE") {
                    
                        let _ = print("RENDERING TO IMAGE !!!")
                        let _ = print(content)
                        
                        renderingView = true
                        
                    }
                    
                    
                    
                    TextField("Title", text: $titleInput)
                        .onAppear() {
                            self.titleInput = title
                        }
                        .onChange(of: titleInput) { newTitle in
                            
                            PersistenceController.shared.updateTextData(
                                textData: textData,
                                title: newTitle,
                                content: contentInput)
                        }
                    
                    
                    
                    TextEditor(text: $contentInput)
                        .onAppear() {
                            self.contentInput = content
                        }
                        .onChange(of: contentInput) { newContent in
                            PersistenceController.shared.updateTextData(
                                textData: textData,
                                title: titleInput,
                                content: newContent)
                            
                        }
                        .sheet(isPresented: $renderingView) {
                            //let _ = print("SHEET SHOULD BE DISPLAYED")
                            
                            MathSubjectView(jsonText: content)
                            
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



