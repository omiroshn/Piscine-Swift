//
//  ArticleManager.swift
//  omiroshn2019
//
//  Created by Lesha Miroshnik on 4/13/19.
//

import Foundation
import CoreData

public class ArticleManager {
    
    var managedObjectContext: NSManagedObjectContext
    
    public init() {
        guard let theURL = Bundle(for: omiroshn2019.Article.self).url(forResource: "article", withExtension: "momd") else {
            fatalError("Error with Bundle")
        }

        guard let theMOM = NSManagedObjectModel(contentsOf: theURL) else {
            fatalError("Error with MOM")
        }

        let thePSC = NSPersistentStoreCoordinator(managedObjectModel: theMOM)

        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = thePSC

        guard let theDocumentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Error with file manager")
        }
        let theStoreURL = theDocumentsURL.appendingPathComponent("article.xcdatamodeld")
        do {
            try thePSC.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: theStoreURL, options: nil)
        } catch {
            print("Error migrating store: \(error)")
        }
    }
    
    public func newArticle() -> Article {
        return NSEntityDescription.insertNewObject(forEntityName: "Article", into: managedObjectContext) as! Article
    }
    
    public func getAllArticles() -> [Article] {
        let theArticleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        do {
            let theFetchedArticles = try managedObjectContext.fetch(theArticleRequest) as! [Article]
            return theFetchedArticles
        } catch {
            return []
        }
    }
    
    public func getArticles(withLang aLang: String) -> [Article] {
        let theArticleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        do {
            theArticleRequest.predicate = NSPredicate(format: "language == %@", aLang)
            let theFetchedArticles = try managedObjectContext.fetch(theArticleRequest) as! [Article]
            return theFetchedArticles
        } catch {
            return []
        }
    }
    
    public func getArticles(containString aString: String) -> [Article] {
        let theArticleRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        do {
            theArticleRequest.predicate = NSPredicate(format: "content CONTAINS %@ || title CONTAINS %@", aString, aString)
            let theFetchedArticles = try managedObjectContext.fetch(theArticleRequest) as! [Article]
            return theFetchedArticles
        } catch {
            return []
        }
    }
    
    public func removeArticle(anArticle: Article) {
        managedObjectContext.delete(anArticle)
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    public func save() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
}
