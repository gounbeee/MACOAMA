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

    
    @Binding var isEditMode : Bool
    @ObservedObject var mathWindowCtr : MathSubjectWindowController
    @Binding var newWindowWidth: String
    @Binding var newWindowHeight: String
 
    
    
    
    var body: some View {
        
        if self.isEditMode == true {
            
            VStack {

                NavigationView {

                    List {

                        ForEach(allTextData) { textData in

                            TextDataView(textData: textData,
                                         mathWindowCtr: self.mathWindowCtr,
                                         newWindowWidth: self.$newWindowWidth,
                                         newWindowHeight: self.$newWindowHeight,
                                         isEditMode: self.$isEditMode)

                        }

                    }
                    .toolbar {

                        ToolbarItem {
                            Button(action: PersistenceController.shared.addTextData) {
                                Label("Add Item", systemImage: "plus")
                            }
                        }

                    }
                    Text("JSONテキストを選択して下さい")
                }
                
  
            }
            
        } else {
            
            
            MainIntroVM()
                .frame(minWidth: 300, idealWidth: 300, maxWidth: 300,
                       minHeight: 100, idealHeight: 100, maxHeight: 100,
                       alignment: .center)
            
            
            MathSubjectRootView(jsonText: allTextData[allTextData.count-1].content!,
                                newWindowWidth: $newWindowWidth,
                                newWindowHeight: $newWindowHeight,
                                windowCtr: self.mathWindowCtr,
                                isEditMode: self.isEditMode)
                .openNewWindow( title: "COARAMAUSE教材",
                                xPos: 0,
                                yPos: 0,
                                width: Int(MathSubjectController.ElementWidth),
                                height: Int(MathSubjectController.ElementHeight),
                                isCenter: true,
                                windowCtr: self.mathWindowCtr,
                                view: nil)
    
            
            
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


