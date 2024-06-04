//
//  CoreDataManager.swift
//  Testing
//
//  Created by kashee on 04/06/24.
//

import Foundation
import CoreData

// Protocol inheritance
protocol CoreDataDelegate: ServiceProtocols {
    func saveDataToCoreData(docs: [Doc])
}

class CoreDataManager: CoreDataDelegate {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func getGenericData<T: Codable>(returnType: T.Type) async throws -> T {
        // Perform Core Data operations in a background context
        let result = try await withCheckedThrowingContinuation { continuation in
               DispatchQueue.global().async {
                   let fetchRequest: NSFetchRequest<Documents> = Documents.fetchRequest()
                   do {
                       let docEntities = try self.context.fetch(fetchRequest)
                       // Convert fetched Core Data objects to [Doc] model objects
                       let docs: [Doc] = docEntities.map { docEntity in
                           let headline = Headline(main: docEntity.headlines?.main)
                           let multimedia = docEntity.multimedias?.compactMap { multimediaEntity in
                               return Multimedia(image: (multimediaEntity as AnyObject).image as? String)
                           }
                           
                           return Doc(id: docEntity.id, description: docEntity.descriptions,
                                      title: headline,
                                      date: docEntity.date,
                                      image: multimedia)
                       }
                       
                       if let result = docs as? T {
                           continuation.resume(returning: result)
                       } else {
                           continuation.resume(throwing: CumstomError.invalidRespone)
                       }
                   } catch {
                       continuation.resume(throwing: error)
                   }
               }
           }
           return result
    }

    func saveDataToCoreData(docs: [Doc]) {
        for doc in docs {
            if checkIfDataAvailable(withId: doc.id) {
                continue
            } else {
                // If the document doesn't exist, create a new one
                createNewRecord(from: doc)
            }
        }
    }
    
    func createNewRecord(from doc: Doc ) {
        Task {
            await saveRecordToCoreData(doc: doc)
        }
    }
    
    func saveRecordToCoreData(doc: Doc) async {
        // Perform Core Data operations in a background context
        await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
                
                let documents = Documents(context: backgroundContext)
                documents.id = doc.id
                documents.descriptions = doc.description
                documents.date = doc.date
                
                // Save title
                if let title = doc.title {
                    let coreDataTitle = Headlines(context: backgroundContext)
                    coreDataTitle.main = title.main
                    documents.headlines = coreDataTitle
                }
                
                if let multimedia = doc.image?.first {
                    let coreDataMultimedia = Multimedias(context: backgroundContext)
                    coreDataMultimedia.image = multimedia.image
                    coreDataMultimedia.documents = documents
                }
                
                do {
                    try backgroundContext.save()
                    continuation.resume()
                } catch {
                    print("DEBUG: failed to save articles to Core Data: \(error.localizedDescription)")
                    // Call the continuation with an error if saving fails
                    continuation.resume(throwing: error as! Never)
                }
            }
        }
    }
    
    func checkIfDataAvailable(withId id: String?) -> Bool {
        guard let id = id else { return false }
        // Fetch the existing document with the given unique identifier
        let fetchRequest: NSFetchRequest<Documents> = Documents.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let existingDocs = try context.fetch(fetchRequest)
            return !existingDocs.isEmpty
        } catch {
            print("Error fetching existing document: \(error)")
            return false
        }
    }
    
}
