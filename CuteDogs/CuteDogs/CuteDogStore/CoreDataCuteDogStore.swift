//
//  CoreDataCuteDogStore.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import CoreData

protocol CuteDogStore {
    
    func retrieve() throws -> [CuteDogStored]?
    func insert(cuteDogs: [CuteDog]) throws
}

final class CoreDataCuteDogStore {
    
    private static let modelName = "CuteDogStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataCuteDogStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    init(storeURL: URL) throws {
        guard let model = CoreDataCuteDogStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: CoreDataCuteDogStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}

extension CoreDataCuteDogStore: CuteDogStore {
    
    func retrieve() throws -> [CuteDogStored]? {
        try performSync { context in
            Result {
                try CuteDogStored.loadCuteDog(in: context)
            }
        }
    }
    
    func insert(cuteDogs: [CuteDog]) throws {
        try performSync { context in
            Result {
                cuteDogs.forEach({ cuteDog in
                    let managedCache = CuteDogStored(context: context)
                    managedCache.id = cuteDog.id
                    managedCache.breedName = cuteDog.breedName
                    managedCache.imageURL = cuteDog.imageURL?.absoluteString ?? ""
                    managedCache.breedTemperament = cuteDog.breedTemperament
                    managedCache.origin = cuteDog.origin
                    managedCache.breedGroup = cuteDog.breedGroup
                })
                try context.save()
            }
        }
    }
}
