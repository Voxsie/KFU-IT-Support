//
//  NSManagedObjectContext+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 18.04.2024.
//

import CoreData
import UIKit


extension NSManagedObjectContext {

    func findManagedObjectByID<T: NSManagedObject>(entityName: String, propertyID: String, value: Any) -> T? {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: [propertyID, value])

        do {
            let result = try self.fetch(fetchRequest)
            return result.first
        } catch {
            print("Error fetching managed object: \(error)")
            return nil
        }
    }

    func findOrCreateManagedObjectByID<T: NSManagedObject>(
        entityName: String,
        propertyID: String,
        value: Any?
    ) -> T {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: [propertyID, value ?? ""])

        do {
            if let existingObject = try self.fetch(fetchRequest).first {
                return existingObject
            }

            guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: self) else {
                fatalError("Error: Entity \(entityName) does not exist.")
            }

            let newObject = T(entity: entity, insertInto: self)

            newObject.setValue(value, forKey: propertyID)

            return newObject
        } catch {
            fatalError("Error fetching or creating managed object: \(error)")
        }
    }

    func updateManagedObjectByID<T: NSManagedObject>(
        entityName: String,
        propertyID: String,
        value: Any,
        updateFields: [String: Any]
    ) -> T? {
        guard let managedObject: T = self.findManagedObjectByID(
            entityName: entityName,
            propertyID: propertyID,
            value: value
        ) else {
            return nil
        }

        for (fieldName, fieldValue) in updateFields {
            managedObject.setValue(fieldValue, forKey: fieldName)
        }

        do {
            try self.save()
            return managedObject
        } catch {
            print("Error updating managed object: \(error)")
            return nil
        }
    }

    func findAllManagedObjects<T: NSManagedObject>(entityName: String) -> [T]? {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)

        do {
            let result = try self.fetch(fetchRequest)
            return result
        } catch {
            print("Error fetching managed objects: \(error)")
            return nil
        }
    }
}

extension NSPersistentContainer {
    func deleteAllData() {
        let managedContext = viewContext

        // Загрузка всех сущностей (entities)
        let entityNames = managedObjectModel.entities.compactMap({ $0.name })

        // Удаление всех объектов в каждой сущности
        entityNames.forEach { entityName in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try managedContext.execute(deleteRequest)
                try managedContext.save()
                print("Deleted all data from entity: \(entityName)")
            } catch let error {
                print("Error deleting data from entity \(entityName): \(error.localizedDescription)")
            }
        }
    }
}
