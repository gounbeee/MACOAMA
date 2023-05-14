//
//  MACOAMA_NativeApp.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/04/26.
//

import SwiftUI

@main
struct MACOAMA_NativeApp: App {
    
    // このアプリの中で、様々な状態を共有し、管理するためのオブジェクト
    // Staticを使用し、SINGLETON として実装されている。
    let persistenceController = PersistenceController.shared

    
    
    @State var isEditMode : Bool = false
    
    
    
    var mathWindowCtr : MathSubjectWindowController = MathSubjectWindowController()
    @State private var newWindowWidth: String = String(MathSubjectController.ElementWidth)
    @State private var newWindowHeight: String = String(MathSubjectController.ElementHeight)

    
    
    var body: some Scene {
        
        
        WindowGroup {
            
            
            ContentView(isEditMode: self.$isEditMode,
                        mathWindowCtr: self.mathWindowCtr,
                        newWindowWidth: self.$newWindowWidth,
                        newWindowHeight: self.$newWindowHeight)

                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            

        }
        // ウィンドウのサイズを固定させる
        // https://developer.apple.com/forums/thread/719389
        .windowResizabilityContentSize()
        
        
    }
}
