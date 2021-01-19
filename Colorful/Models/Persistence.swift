//
//  Persistence.swift
//  Colorful
//
//  Created by Jakub "GPH4PPY" Dąbrowski on 13/01/2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0 ..< 10 {
            let newItem = LovedColor(context: viewContext)
            newItem.hex = ""
            newItem.rgb = ""
            newItem.hsb = ""
            newItem.id = UUID()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    // Allows access to viewContext, where objects are created, fetched updated and deleted.
    // Then it saves it back into the persistent store.
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        // LovedColors Data Model
        container = NSPersistentContainer(name: "LovedColors")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
