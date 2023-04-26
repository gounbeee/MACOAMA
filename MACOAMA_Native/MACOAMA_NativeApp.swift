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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
        
    }
}
