//
//  Extensions.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/05/03.
//

import Foundation
import SwiftUI




// Stringの中で特定の文字のINDEX番号を調べる
// https://stackoverflow.com/questions/24029163/finding-index-of-character-in-swift-string
public extension String {
  func indexInt(of char: Character) -> Int? {
    return firstIndex(of: char)?.utf16Offset(in: self)
  }
}



public extension String {
    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789.")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}



struct IntDoubleBinding {
    let intValue : Binding<Int>
    
    let doubleValue : Binding<Double>
    
    init(_ intValue : Binding<Int>) {
        self.intValue = intValue
        
        self.doubleValue = Binding<Double>(get: {
            return Double(intValue.wrappedValue)
        }, set: {
            intValue.wrappedValue = Int($0)
        })
    }
}




extension CGPoint {
    
    
    
    func toStrTuple() -> (String?, String?) {
        return ("\(x)", "\(y)")
    }
    

}


// 文字列を初期化で入力され、Bindingタイプを返すように拡張
// https://stackoverflow.com/questions/63341176/optional-extension-with-custom-binding-in-swiftui
extension Binding where Value == String? {
    var optionalBinding: Binding<String> {
        .init(
            get: {
                self.wrappedValue ?? ""
            }, set: {
                self.wrappedValue = $0
            }
        )
    }
}






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
    
    
    // 実際、ウィンドウを生成させる関数
    private func newWindowInternal(title: String, xPos: Int, yPos: Int, width: Int , height: Int , isCenter: Bool ) -> NSWindow {
        
        // NSWindowを使用してウィンドウを作成する。
        //
        let window = NSWindow(
            contentRect: NSRect(x: xPos, y: yPos, width: width, height: height),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        
        // スクリーンの中央にウィンドウを位置させる。
        if isCenter == true {
            window.center()
        }
        
        
        // 閉じられた時、メモリ解放をするかの設定
        window.isReleasedWhenClosed = false
        
        // タイトルの設定
        window.title = title
        
        // このウィンドウを一番前に持ってくるかの設定
        window.makeKeyAndOrderFront(nil)
        
        return window
        
    }
    
    
    // この関数を、Viewを返すようにすることでView ModelファイルのBodyで、条件次第でこちらの関数を実行して終われるようになる。
    // なぜなら、View構造体のBodyでは、もしIf文を使うなら、「同じタイプのView」オブジェクトを返す必要があるからである。
    func openNewWindow(title: String = "new Window",
                       xPos: Int, yPos: Int,
                       width: Int, height: Int,
                       isCenter: Bool,
                       windowCtr: MathSubjectWindowController,
                       view: AnyView?) -> AnyView? {
        
        // NSHostingView オブジェクトを使用
        // Creates a hosting view object that wraps the specified SwiftUI view.
        // このオブジェクトは、指定されたSwiftUIのViewをラッピングする、ホスティングViewオブジェクトを生成する。
        let newWindow = self.newWindowInternal(title: title, xPos: xPos, yPos: yPos, width: width, height: height, isCenter: isCenter)
        newWindow.contentView = NSHostingView(rootView: self)
        
        windowCtr.addWindowToList(window: newWindow)
        
                
        if view != nil {
            return view
        } else {
            return nil
        }
        
            
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




extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}
