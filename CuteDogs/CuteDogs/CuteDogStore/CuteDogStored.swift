//
//  CuteDogStored.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import CoreData

@objc(CuteDogStored)
class CuteDogStored: NSManagedObject {
    
    @NSManaged var id: String
    @NSManaged var breedName: String
    @NSManaged var breedGroup: String
    @NSManaged var imageURL: String?
    @NSManaged var origin: String
    @NSManaged var breedTemperament: String
}

extension CuteDogStored {
    
    static func loadCuteDog(in context: NSManagedObjectContext) throws -> [CuteDogStored]? {
        
        try load(in: context)
    }
    
    private static func load(in context: NSManagedObjectContext) throws -> [CuteDogStored]? {
        let request = NSFetchRequest<CuteDogStored>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
}
