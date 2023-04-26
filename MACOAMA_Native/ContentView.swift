//
//  ContentView.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/04/26.
//

import SwiftUI
import CoreData




struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TextData.createdAt, ascending: true)],
        animation: .default)
    
    private var allTextData: FetchedResults<TextData>
    
    
    var body: some View {
        
        
        NavigationView {
            
            
            List {
                
                ForEach(allTextData) { textData in
                                        
                    TextDataView(textData: textData)
                    
                }
                
            }
            .toolbar {
                
                ToolbarItem {
                    Button(action: PersistenceController.shared.addTextData) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                
                
            }
            Text("Select an item")
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




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
