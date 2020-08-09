//
//  EntityManager.swift
//  SportsTracer
//
//  Created by 李进辉 on 2020/8/9.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit
import CoreData

protocol Persistable {
    
    func persist<T: NSManagedObject>() -> T?
}

class EntityManager {
    
    class func fetchEntity<T: NSManagedObject> (with entityName: String, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T]? {
        
        var results: [T] = [T]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        if let sortDescriptors = sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        do {
            
            let resultArray = try PersistenceManager.shared.persistentContainer.viewContext.fetch(fetchRequest)
            
            if resultArray.count > 0 {
                results = resultArray as? [T] ?? [T]()
            }
        } catch {
            print(error)
        }
        
        return results
    }
}
