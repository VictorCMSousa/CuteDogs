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
    
    static func loadCuteDog(in context: NSManagedObjectContext) throws -> [CuteDog]? {
        
        try load(in: context)?.map({ $0.cuteDog })
    }
    
    private static func load(in context: NSManagedObjectContext) throws -> [CuteDogStored]? {
        let request = NSFetchRequest<CuteDogStored>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    var cuteDog: CuteDog {
        CuteDog(id: id,
                breedName: breedName,
                breedGroup: breedGroup,
                imageURL: URL(string: imageURL ?? ""),
                origin: origin,
                breedTemperament: breedTemperament)
    }
}
