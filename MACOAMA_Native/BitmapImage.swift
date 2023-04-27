//
//  BitmapImage.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/04/27.
//


import SwiftUI

@MainActor final class BitmapImage : ObservableObject {
    
    @Published var images: [String: NSImage] = [:]

    init(targetView: AnyView) {
        let view = targetView
        let renderer = ImageRenderer(content: view)
        
        #if os(macOS)
//            renderer.scale = NSApplication.shared
//                                          .mainWindow?
//                                          .backingScaleFactor ?? 2.0
            
        
            if let nsImage = renderer.nsImage {
                
                print(nsImage)
                print(nsImage.size)
                
                images["1"] = nsImage
                
            }
        #endif
    }
}
