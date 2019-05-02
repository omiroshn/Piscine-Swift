//
//  Article+CoreDataClass.swift
//  omiroshn2019
//
//  Created by Lesha Miroshnik on 4/13/19.
//
//

import Foundation
import CoreData

@objc(Article)
public class Article: NSManagedObject {
    override public var description: String {
        return "(Title: \(title ?? "Unknown"), Content: \(content ?? "Unknown"), Language: \(language ?? "Unknown"))"
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var language: String?
    @NSManaged public var image: NSData?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var modificationDate: NSDate?
}
