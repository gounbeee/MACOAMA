//
//  Persistence.swift
//  MACOAMA_Native
//
//  Created by Si Young Choi on 2023/04/26.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        
        for _ in 0..<10 {
            
            let newTextData = TextData(context: viewContext)
            newTextData.createdAt = Date()
            newTextData.updatedAt = Date()
            newTextData.content = "(Content)"
            newTextData.title = "(title)"
              
            
        }
        
        
        
        do {
            
            try viewContext.save()
            
        } catch {
            
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            
        }
        
        
        return result
        
        
        
    }()
    
    
    
    
    let container: NSPersistentContainer
    
    
    
    init(inMemory: Bool = false) {
        
        
        container = NSPersistentContainer(name: "MACOAMA_Native")
        
        
        if inMemory {
            
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            
        }
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            
            if let error = error as NSError? {
                
                
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
                
                
            }
            
            
        })
        
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        
    }
    
    
    
    
    func save() {
        
        
        let viewContext = container.viewContext
        
        do {
            
            try viewContext.save()
            
        } catch {
            
            let nsError = error as NSError
            
            
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            
        }
    }
    
    
    
    func addTextData() {
        
        let newTextData = TextData(context: container.viewContext)
        
        newTextData.createdAt = Date()
        
        newTextData.updatedAt = Date()
        
        newTextData.title = "Untitled"
        
        newTextData.content = "TBD"
        
        
        save()
        
        
    }
    
    
    
    func addTextDataWithString(title: String, input: String) {
        
        let newTextData = TextData(context: container.viewContext)
        
        newTextData.createdAt = Date()
        
        newTextData.updatedAt = Date()
        
        newTextData.title = title
        
        newTextData.content = input
        
        
        save()
        
        
    }
    
    
    
    func updateTextData(textData: TextData, title:String, content: String) {
        
        
        textData.content = content
        
        
        textData.title = title
        
        textData.updatedAt = Date()
        
        save()
        
        
    }
    
    
    
    func deleteTextData(textData: TextData) {
        
        container.viewContext.delete(textData)
        
        
        save()
        
        
    }
    
    
    
    
    
    
    
}
